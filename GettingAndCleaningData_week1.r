###################################
#Getting and Cleaning Data - Week 1
###################################


#checking for and creating dirs
if(!file.exists("data")){
    dir.create("data")
}

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras.csv")
list.files("./data")
dateDownloaded <- date()
dateDownloaded

cameraData <- read.table("./data/cameras.csv", sep = ",", header = T)
head(cameraData)

#alternate:
cameraData2 <- read.csv("./data/cameras.csv")
head(cameraData2)

#Excel format
install.packages("xlsx")
library(xlsx)

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras2.xlsx", mode = "wb")
dateDownloaded2 <- date()
dateDownloaded2
cameraData2 <- read.xlsx("./data/cameras2.xlsx", sheetIndex = 1, header = T)
head(cameraData2)


#Reading specific rows and cols
colIndex <- 2:3
rowIndex <- 1:4
cameraData2Subset <- read.xlsx("./data/cameras2.xlsx", sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)
cameraData2Subset


##########
#XML files
##########
install.packages("XML")
library(XML)
fileUrl <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternal = T)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

#access part of the xml doc directly
rootNode[[1]]
rootNode[[1]][[1]]
rootNode[[1]][[2]]
rootNode[[1]][[3]]
rootNode[[1]][[4]]

#programatically extract part of file
xmlSApply(rootNode, xmlValue)

#XPath to pinpoint particular parts you want to extract

xpathSApply(rootNode, "//name", xmlValue) #//name find this node at any level
xpathSApply(rootNode, "//price", xmlValue) #//price find this node at any level

#Another example:
fileUrl <- "http://espn.go.com/nfl/team/_/name/sf/san-francisco-49ers"
doc <- htmlTreeParse(fileUrl, useInternal = T)
scores <- xpathSApply(doc, "//li[@class = 'score']", xmlValue) #list node with class = 'score'
teams <- xpathSApply(doc, "//li[@class = 'team-name']", xmlValue) #list node with class = 'team-name'
teams
scores

######
#JSON
######
install.packages("jsonlite")
library(jsonlite)

jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login

#writing data frames to json
myjson <- toJSON(iris, pretty = T)
cat(myjson)

#convert from json to df
iris2 <- fromJSON(myjson)
head(iris2)


###########
#data.table
###########
install.packages("data.table")

library(data.table)
set.seed(1)
df <- data.frame(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z = rnorm(9))
head(df,3)

set.seed(1)
dt <- data.table(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z = rnorm(9))
head(dt,3)


tables() #all data tables in memory

#subsetting rows
dt[2,]
dt[dt$y != "a",]
dt[c(2,3)] #subsets based on rows, i.e. takes rows 2-3

#subsetting cols: different from data.table than for data.frame
{
x <- 1
y <- 2
}
k = {print(10); 5}
print(k)

dt[,list(mean(x), sum(z))] #pass a list of fcns. returns mean of x vals and sum of z vals in this case
dt[,table(y)] #create table from y vals

#add new cols
dt[,w:=z^2]

dt2 <- dt
dt[,y:= 2]
head(dt)
head(dt2) #no copy made, dt2 is pointer to dt and changes with it, thus it is the same as dt! Use copy() to make clean copy

#multiple ops with expressions
dt[,m := {tmp <- (x+z); log2(tmp + 5)}]

#plyr like ops
dt[,a := x >= 0]
dt[, b:= mean(x+w), by = a]

#special variables
set.seed(123)
dt2 <-data.table(x = sample(letters[1:3], size = 1E5, T)) #100000 a's, b's and c's, randomly sampled
dt2[, .N, by = x] #.N counts number of times, grouped by x, i.e. counts # of a's, b's, and c's. Faster than table(dt$x)

#keys: by setting a key can subset and sort much more rapidly versus a data frame
set.seed(2)
dt3 <- data.table(x = rep(c("a","b","c"),each = 100), y = rnorm(300))
setkey(dt3,x)
dt3['a']

#joins
dt4 <- data.table(x = c('a','a','b','dt4'), y = 1:4)
dt5 <- data.table(x = c('a','b','dt5'), z = 5:7)
setkey(dt4, x)
setkey(dt5,x)
merge(dt4,dt5)

#fast reading
bigdf <- data.frame(x = rnorm(1e6), y = rnorm(1e6))
file <- tempfile()
write.table(bigdf, file = file, row.names = F, col.names = T, sep = "\t", quote = F)
system.time(fread(file)) #faster
system.time(read.table(file, header = T, sep = "\t")) #slower

#######
#Quiz 1
#######

#Q1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/housing_Idaho.csv")
idahoHousingData <- read.table("./data/housing_Idaho.csv", sep = ",", header = T)
dateDownloaded <- date()
dateDownloaded
head(idahoHousingData)

#from code book: VAL gives property value. If VAL == 24 the value is >= 1000000
millionPlus <- idahoHousingData$VAL
millionPlusCount <- length(millionPlus[!is.na(millionPlus) & millionPlus == 24])


#Q3
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./data/NGAP.xlsx", mode = "wb")
dateDownloaded2 <- date()
dateDownloaded2

colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("./data/NGAP.xlsx", sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)
sum(dat$Zip * dat$Ext, na.rm = T)

#Q4
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl, useInternal = T)
rootNode <- xmlRoot(doc)
res <- sum(xpathSApply(rootNode, "//zipcode", xmlValue) == "21231")
res


#Q5
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./data/housing_Idaho2.csv")
DT <- fread("./data/housing_Idaho2.csv")
dateDownloaded3 <- date()
dateDownloaded3

system.time(DT[,mean(pwgtp15), by  = SEX]) #fastest
system.time(sapply(split(DT$pwgtp15, DT$SEX),mean)) #fast
system.time(rowMeans(DT)[DT$SEX == 1])
system.time(rowMeans(DT)[DT$SEX == 2])

system.time(mean(DT$pwgtp15, by=DT$SEX)) #wrong answer

system.time(tapply(DT$pwgtp15, DT$SEX,mean)) #fast

system.time(mean(DT[DT$SEX == 1]$pwgtp15)) #slower
system.time(mean(DT[DT$SEX == 2]$pwgtp15))
