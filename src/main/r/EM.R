# Title     : TODO
# Objective : TODO
# Created by: MrRadziu
# Created on: 2017-06-03

emFunction1 <- function(dataset, labels) {

    library(EMCluster)
    max = nrow(dataset)
    x1 = 1:max
    plot( x1, dataset[1:max, 1] )

    i <- 1
    j <- 2

    mix = matrix(nrow = max, ncol = ncol(dataset)+1)
    mix[,1] = c(x1)
    while (i <= ncol(dataset)) {
        mix[,j] = c(dataset[1:max, i])
        i <- i + 1
        j <- j + 1
    }

    mixclust1 = em.EM(mix, lab=labels, nclass=length(unique(labels)))
    print(mixclust1)
}

emFunction2 <- function(dataset, labels) {

    library(EMCluster)
    max = nrow(dataset)
    x1 = 1:max
    plot( x1, dataset[1:max, 1] )

    i <- 1
    j <- 2

    mix = matrix(nrow = max, ncol = ncol(dataset)+1)
    mix[,1] = c(x1)
    while (i <= ncol(dataset)) {
        mix[,j] = c(dataset[1:max, i])
        i <- i + 1
        j <- j + 1
    }

    mixclust2 = rand.EM(mix, lab=labels, nclass=length(unique(labels)))
    print(mixclust2)
}