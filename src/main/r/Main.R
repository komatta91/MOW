library(foreign)

MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]

unmanaged <- MyData[,1:ncol(MyData)-1]
managed <- MyData

nonBancrupt <- nrow(managed[managed$CLASSIFICATION==0,])
bancrupt <- nrow(managed[managed$CLASSIFICATION==1,])

print(unmanaged[1,])
print(nonBancrupt)
print(bancrupt)

