
library(foreign)



MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]

unmanaged <- MyData[,1:ncol(MyData)-1]
managed <- MyData
labels <- c(MyData[,'CLASSIFICATION'])

ograniczony <- unmanaged[6500:7000,]


source("EM.R")
em1 = emFunction1(dataset=unmanaged, labels=labels)

#source("IsolationForest.R")
#isolationForest <- iForest(X=unmanaged, nt=10, phi=700, multicore=FALSE)

#print(isolationForest$nTrees)
#print(isolationForest$l)

#print(isolationForest)


#plot(em1)