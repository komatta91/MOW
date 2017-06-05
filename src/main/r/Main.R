
library(foreign)



MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]

unmanaged <- MyData[,1:ncol(MyData)-1]
managed <- MyData
labels <- c(MyData[,'CLASSIFICATION'])

ograniczony <- unmanaged[6500:7000,]


# source("EM.R")
# em1 = emFunction1(dataset=unmanaged, labels=labels)
# em2 = emFunction2(dataset=unmanaged, labels=labels)

source("IsolationForest.R")
samplesPerTree <- 700
anomalyTreshold <- 0.1
isolationForest <- iForest(X=unmanaged, numberOfTrees=10, samplesPerTree=samplesPerTree, multicore=FALSE)
anomalies <- sum(unlist(lapply(isolationForest$forest[], function(tree) Filter(function(size) size > 0 && size < anomalyTreshold*samplesPerTree, tree[, 'Size']))))
print(anomalies)
