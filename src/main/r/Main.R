library(foreign)

MyData <- read.arff(file="../resources/1year.arff")

print(MyData[1,])
