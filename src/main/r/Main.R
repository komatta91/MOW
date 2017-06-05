
library(foreign)


AllTheData <- list(
    list(read.arff(file="../resources/polishcompanies/1year.arff"), function(data) ncol(data)),
    list(read.arff(file="../resources/polishcompanies/2year.arff"), function(data) ncol(data)),
    list(read.arff(file="../resources/polishcompanies/3year.arff"), function(data) ncol(data)),
    list(read.arff(file="../resources/polishcompanies/4year.arff"), function(data) ncol(data)),
    list(read.arff(file="../resources/polishcompanies/5year.arff"), function(data) ncol(data)),
    list(read.csv(file="../resources/dota2/dota2Test.csv", sep=",", header=FALSE), function(data) 1),
    list(read.csv(file="../resources/dota2/dota2Train.csv", sep=",", header=FALSE), function(data) 1)
)

lapply(AllTheData, function(Data){
    DataTable <- Data[[1]]
    labelcol <- Data[[2]](DataTable)
    datacols <- seq.int(1, ncol(DataTable))
    datacols <- datacols [! datacols %in% labelcol]
    unmanaged <- DataTable[,datacols]
    managed <- DataTable
    labels <- c(DataTable[,labelcol])

    #source("EM.R")
    #em1 = emFunction1(dataset=unmanaged, labels=labels)

    source("IsolationForest.R")
    samplesPerTree <- 700
    anomalyTreshold <- 0.01
    isolationForest <- iForest(X=unmanaged, numberOfTrees=10, samplesPerTree=samplesPerTree, multicore=FALSE)
    anomalies <- sum(unlist(lapply(isolationForest$forest[], function(tree) Filter(function(size) size > 0 && size < anomalyTreshold*samplesPerTree, tree[, 'Size']))))
    print(c(nrow(unmanaged)-anomalies, anomalies))
})

