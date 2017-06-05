library(parallel)

max_nodes <- function(level, b=2) { 
    return((b ^ (level) - 1) + b ^ level)
}

split_on_var <- function(x, ...) 
    UseMethod("split_on_var")

split_on_var.numeric <- function(x, ...) {
    v = do.call(runif, as.list(c(1, range(x))))
    list(value = v, filter = x < v)
}

split_on_var.factor <- function(x, ..., idx=integer(32)) {
    level = which(levels(x) %in% unique(x))
    if (length(level) < 1) print("zero length!?")
    s = sample(max(1, 2^(length(level)) - 2), 1)
    i = level[which(intToBits(s) == 1)]
    idx[i] = 1L
    list(value = packBits(idx, type="integer"), filter = x %in% levels(x)[i])
}

recurse <- function(idx, e, level, ni=0, env) {
    dups <- sapply(env$X[idx,], function(x) all(duplicated(x)[-1L]))
    if (e >= level || length(idx) <= 1 || all(dups)) {
        env$mat[ni,c("Type", "Size")] <- c(-1, length(idx))
        return()
    }
    i = sample(which(!dups), 1)
    res = split_on_var(env$X[idx, i, TRUE])
    f = res$filter
    env$mat[ni, c("Left")] <- nL <- 2 * ni
    env$mat[ni, c("Right")] <- nR <- 2 * ni + 1
    env$mat[ni, c("SplitAtt", "SplitValue", "Type")] <- c(i, res$value, 1)
    env$mat[ni, "AttType"] <- ifelse(is.factor(env$X[,i,T]), 2, 1)
    recurse(idx[which(f)] , e + 1, level, nL, env)
    recurse(idx[which(!f)], e + 1, level, nR, env)
}

compress_matrix <- function(m) {
    m = cbind(seq.int(nrow(m)), m)[m[,"Type"] != 0,,drop=FALSE]
    m[,"Left"] = match(m[,"Left"], m[,1], nomatch = 0)
    m[,"Right"] = match(m[,"Right"], m[,1], nomatch = 0)
    m[m[,"Type"] == -1,"TerminalID"] = seq.int(sum(m[,"Type"] == -1))
    m[,-1,drop=FALSE]
}

iTree <- function(X, level) {
    env = new.env()
    env$mat = matrix(0,
    nrow = max_nodes(level),
    ncol = 8,
    dimnames = list(NULL, c("TerminalID", "Type","Size","Left","Right","SplitAtt","SplitValue","AttType")))
    env$X = X
    recurse(seq.int(nrow(X)), e=0, level=level, ni=1, env)
    compress_matrix(env$mat)
}

iForest <- function(X, numberOfTrees=100, samplesPerTree=256, seed=6163, multicore=FALSE) {
    set.seed(seed)
    level = ceiling(log(samplesPerTree, 2))
    if (!is.data.frame(X)) X <- as.data.frame(X)
    factor32 <- sapply(X, function(x) class(x) == "factor" & nlevels(x) > 32)
    if(sum(factor32) > 0) stop("Can not handle categorical predictors with more than 32 categories.")
    if (multicore) {
        ncores <- detectCores()
        sample_dfs <- replicate(numberOfTrees, {X[sample(nrow(X), samplesPerTree),]}, simplify = F)
        cl <- makeCluster(getOption("cl.cores", ncores))
        forest <- parLapply(cl, sample_dfs, iTree, level)
        stopCluster(cl)
    } else {
        forest <- vector("list", numberOfTrees)
        for (i in 1:numberOfTrees) {
            s <- sample(nrow(X), samplesPerTree)
            forest[[i]] <- iTree(X[s,], level)
        }
    }

    structure(
    list(
    forest  = forest,
    samplesPerTree     = as.integer(samplesPerTree),
    level   = level,
    vLevels = sapply(X, levels)),
    nTrees  = as.integer(numberOfTrees),
    nVars   = NCOL(X),
    nTerm   = sapply(forest, function(t) max(t[,"TerminalID"])),
    vNames  = colnames(X),
    class = "iForest")
}
