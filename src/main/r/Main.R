
library(foreign)



MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]

unmanaged <- MyData[,1:ncol(MyData)-1]
managed <- MyData
labels <- c(MyData[,'CLASSIFICATION'])

source("EM.R")
em1 = emFunction1(dataset=managed, labels=labels)


#plot(em1)