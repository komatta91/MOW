library(foreign)

MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- readLines(file("../resources/attributes.csv"))

print(MyData[1,])

