library(foreign)

MyData <- read.arff(file="../resources/1year.arff")
colnames(MyData) <- read.csv(file="../resources/attributes.csv", sep=",", header=FALSE)[,1]

unmanaged <- MyData[,1:ncol(MyData)-1]
managed <- MyData

print(managed)

library(mclust)

#max = 500
max = nrow(MyData)

x1 = 1:max
y1 = 0

plot( x1, managed[1:max, 1] )
#y1 <- managed[1:max, 1]


i <- 1
j <- 2

mix = matrix(nrow = max, ncol = ncol(managed)+1)
mix[,1] = c(x1)
while (i <= ncol(managed)) {
    mix[,j] = c(managed[1:max, i])
    i <- i + 1
    j <- j + 1
}


print(mix)


mixclust = Mclust(mix)

print(mixclust)

#plot(mixclust, data = mix)
