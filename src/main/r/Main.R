
library(foreign)



MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]

unmanaged <- MyData[,1:ncol(MyData)-1]
managed <- MyData

source("EM.R")
em1 = emFunction1(managed)


#plot(em1)