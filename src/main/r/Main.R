
library(foreign)


AllTheData <- list(
    read.arff(file="../resources/polishcompanies/1year.arff"),
    read.arff(file="../resources/polishcompanies/2year.arff"),
    read.arff(file="../resources/polishcompanies/3year.arff"),
    read.arff(file="../resources/polishcompanies/4year.arff"),
    read.arff(file="../resources/polishcompanies/5year.arff"),
    read.csv(file="../resources/dota2/dota2Test.csv", sep=",", header=FALSE),
    read.csv(file="../resources/dota2/dota2Train.csv", sep=",", header=FALSE)
)

lapply(AllTheData, function(Data){
    unmanaged <- Data[,1:ncol(Data)-1]
    managed <- Data
    labels <- c(Data[,ncol(Data)])

    #source("EM.R")
    #em1 = emFunction1(dataset=unmanaged, labels=labels)

    source("IsolationForest.R")
    samplesPerTree <- 700
    anomalyTreshold <- 0.01
    isolationForest <- iForest(X=unmanaged, numberOfTrees=10, samplesPerTree=samplesPerTree, multicore=FALSE)
    anomalies <- sum(unlist(lapply(isolationForest$forest[], function(tree) Filter(function(size) size > 0 && size < anomalyTreshold*samplesPerTree, tree[, 'Size']))))
    print(c(nrow(unmanaged)-anomalies, anomalies))
})

