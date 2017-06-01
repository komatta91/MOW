library(foreign)

MyData <- read.arff(file="../resources/1year.arff")


print(as.list(read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)))
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]
print(MyData[1,])

