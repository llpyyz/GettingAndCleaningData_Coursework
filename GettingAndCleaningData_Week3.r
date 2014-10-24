###################################
#Getting and Cleaning Data - Week 3
###################################


###############################
#Lec 3-1 Subsetting and Sorting
###############################

#quick review
set.seed(13435)
X <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA
X
X[,1] #col 1
X[,"var1"] #col 1
X[1:2, "var2"] #rows 1-2 of col 2

#ANDs & ORs
X[(X$var1 <= 3 & X$var3 > 11),] #intersection of two subsets

X[(X$var1 <= 3 | X$var3 > 15),] #union of two subsets

#Dealing with missing values
X[which(X$var2 > 8),]


#Sorting
sort(X$var1)
sort(X$var1, decreasing = T)
sort(X$var2, na.last = T)
sort(x$var2) #NA's removed
sort(X$var2, na.last = F)

#Ordering
X[order(X$var1),]
X[order(X$var2),]
X[order(X$var2, na.last = F),]
X[order(X$var1, X$var3),]


#Ordering with plyr
library(plyr)
arrange(X, var1)
arrange(X, desc(var1))

#Adding rows and columns
X$var4 <- rnorm(5)
X

Y <- cbind(X, rnorm(5))
Y

#########################
#Lec 3-2 Summarizing Data
#########################

#Baltimore City, restaurants
if(!file.exists("./data")){
    dir.create("./data")
} 
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv")
restaurantData <- read.csv("./data/restaurants.csv")
head(restaurantData, n = 3)
tail(restaurantData, n = 3)
summary(restaurantData)
str(restaurantData)
quantile(restaurantData$councilDistrict, na.rm = T)
quantile(restaurantData$councilDistrict, probs = c(0.5, 0.75, 0.9))

#Make table
table(restaurantData$zipCode, useNA="ifany")
table(restaurantData$councilDistrict, restaurantData$zipCode)

#Check for missing values
sum(is.na(restaurantData$councilDistrict)) #0

any(is.na(restaurantData$councilDistrict)) #False

all(restaurantData$zipCode > 0) #False, i.e. not all zips are > 0 so at least one is <0 , bad data!

#Row and column sums
colSums(is.na(restaurantData)) #0, the count of all NA's by column

all(colSums(is.na(restaurantData)) == 0) #True, since no cols have any NAs

#Values with Specific Characteristics
table(restaurantData$zipCode %in% c("21212"))

table(restaurantData$zipCode %in% c("21212", "21213"))

s <- restaurantData[restaurantData$zipCode %in% c("21212","21213	"),]
head(s)
tail(s)

#Cross tabs
data(UCBAdmissions)
DF <- as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data = DF)
xt

#Flat tables
warpbreaks$replicate <- rep(1:9,len = 54)
xt <- xtabs(breaks ~ ., data = warpbreaks)
xt
ftable(xt)

#Size of a data set
fakeData <- rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units = "Mb")


###############################
#Lec 3-3 Creating New Variables
###############################


#Baltimore City, restaurants
if(!file.exists("./data")){
    dir.create("./data")
} 
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv")
restaurantData <- read.csv("./data/restaurants.csv")

#Creating sequences
s1 <- seq(1, 10, by = 2)
s1

s2 <- seq(1, 10, length = 3)
s2

x <- c(1, 3, 8, 25, 100)
s3 <- seq(along = x)
s3

#Subsetting variables
restaurantData$nearMe <- restaurantData$neighborhood %in% c("Roland Park", "Homeland")
table(restaurantData$nearMe)

#Creating binary variables
restaurantData$zipWrong <- ifelse(restaurantData$zipCode < 0 , T, F)
table(restaurantData$zipWrong)
table(restaurantData$zipWrong, restaurantData$zipCode < 0)

#Creating categorical variables
restaurantData$zipGroups <- cut(restaurantData$zipCode, breaks = quantile(restaurantData$zipCode))
table(restaurantData$zipGroups)
table(restaurantData$zipGroups, restaurantData$zipCode)

#Easier cutting
library(Hmisc)
restaurantData$zipGroups <- cut2(restaurantData$zipCode, g = 4)
table(restaurantData$zipGroups)

#Creating factor variables
restaurantData$zcf <- factor(restaurantData$zipCode)
restaurantData$zcf[1:10]
class(restaurantData$zcf)

#Levels of factor variables
yesno <- sample(c("yes","no"), size = 10, replace = T)
yesnofac <- factor(yesno, levels = c("yes","no")) #forces "yes" to be first level
yesnofac2 <- factor(yesno) #makes "no" the first level since it is first alphabetically
relevel(yesnofac, ref = "yes")
as.numeric(yesnofac)

#Cutting produces factor variables
class(restaurantData$zipGroups) #factor


restaurantData$zipGroups <- cut2(restaurantData$zipCode, g = 4)
table(restaurantData$zipGroups)


library(Hmisc)
library(plyr)
#mutate simultaneously adds a new var and makes it a factor
restaurantData2 <- mutate(restaurantData, zipGroups = cut2(zipCode, g = 4))
table(restaurantData2$zipGroups)


#######################
#Lec 3-4 Reshaping Data
#######################

#Goal is tidy data:
#1. each var is a col
#2. each obs is a row
#3. each table/file stores data about one kind of obs

#Start with reshape
library(reshape2)
head(mtcars, n = 5)

#Melting data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id = c("carname","gear","cyl"), measure.vars = c("mpg","hp"))
head(carMelt, n = 3)
tail(carMelt, n = 3)

#Casting data frames
cylData <- dcast(carMelt, cyl ~ variable)
cylData

cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData

#Averaging values

head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)

#Another way - split/apply/combine
#http://www.r-bloggers.com/a-quick-primer-on-split-apply-combine-problems/

#1. split
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns

#2. apply
sprCount <- lapply(spIns, sum)
sprCount

#3. combine
unlist(sprCount)

#alternative: sapply does the apply and combine in one step
sapply(spIns, sum)

#another way - plyr package
library(plyr)
ddply(InsectSprays,.(spray), summarise, sum = sum(count))

#Creating a new variable
spraySums <- ddply(InsectSprays,.(spray), summarise, sum = ave(count, FUN = sum))
dim(spraySums)
head(spraySums)

#####################
#Lec 3-5 Merging Data
#####################

if(!file.exists("./data")){
    dir.create("./data")
}
fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1, destfile = "./data/reviews.csv")
download.file(fileUrl2, destfile = "./data/solutions.csv")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews, 2)
head(solutions, 2)

#Merging data - merge()
#merge data frames
#important params: x, y, by, by.x, by.y, all
names(reviews)
names(solutions)
mergedData <- merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = T)
head(mergedData)

#Default - merge all common column names
intersect(names(solutions), names(reviews))
mergedData2 <- merge(reviews, solutions, all = T)
head(mergedData2)

#Using join the plyr package
#Faster but less full featured; defaults to left join
library(plyr)
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
df3 <- arrange(join(df1, df2), id)

#With multiple data frames
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
df3 <- data.frame(id = sample(1:10), z = rnorm(10))
df4 <- data.frame(id = sample(1:10), w = rnorm(10))
dfList <- list(df1,df2,df3,df4)
dfJoin <- arrange(join_all(dfList),id)

#More on merging data:
#R data merging: http://www.statmethods.net/management/merging.html
#plyr: http://plyr.had.co.nz/
#types of joins: http://en.wikipedia.org/wiki/Join_(SQL

########
#Quiz 3
########

###########
#Question 1
###########

if(!file.exists("./data")){
    dir.create("./data")
} 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/idahoHousingData.csv")
dat <- read.csv("./data/idahoHousingData.csv")
head(dat, n = 3)
tail(dat, n = 3)
summary(dat)
str(dat)

#ACR is code for acreage, value = 3 for 10+ acres
#AGS is code for ag sales, value of 6 for 10K+
dat$agLogical <- ifelse(dat$ACR == 3 & dat$AGS == 6 , T, F)
res <- which(dat$agLogical) #125, 238, 262, ...

###########
#Question 2
###########
install.packages("jpeg")
library(jpeg)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl, destfile = "./data/jeffleekpic.jpg", mode = "wb")
pic <- readJPEG("./data/jeffleekpic.jpg", native = T)
quantile(pic, probs = c(.3, .8))

###########
#Question 3
###########
#Number of countries in merged data set and which has 13th lowest gdp

install.packages("stringr")
library(stringr)
library(plyr)
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl1, destfile = "./data/gdpData.csv")
download.file(fileUrl2, destfile = "./data/educationalData.csv")
gdp <- read.csv("./data/gdpData.csv", header = F) #note, need to manually remove crap at beginning of file, or skip about 10 lines when reading in
names(gdp) <- c("CountryCode", "GDP.Rank", "X1", "Long.Name", "GDP", "X2", "X3", "X4", "X5", "X6")
gdp$GDP <- as.character(gdp$GDP)
gdp$GDP <- str_trim(gdp$GDP)
gdp$GDP <- str_replace_all(gdp$GDP, ",", "")
gdp$GDP <- as.numeric(gdp$GDP)
edu <- read.csv("./data/educationalData.csv")
#gdp$V1 and edu$CountryCode are the three letter country codes on which we match
mergedData <- merge(gdp, edu, by.x = "CountryCode", by.y = "CountryCode")
sortedByGDP <- arrange(mergedData, GDP)
sub1 <- sortedByGDP[1:13, c("CountryCode", "GDP.Rank", "Long.Name.x", "GDP")]

###########
#Question 4
###########
#mean gdp rank for high income: oecd and high income: non-oecd
#edu$Income.Group is the category needed

sub1 <- mergedData$GDP.Rank[mergedData$Income.Group == "High income: nonOECD"]
sub2 <- mergedData$GDP.Rank[mergedData$Income.Group == "High income: OECD"]

mean(sub1) #nonOECD
mean(sub2) #OECD

###########
#Question 5
###########
#How many countries are lower middle income but in top quantile, [1, 39), i.e. gdp rank in top 38
library(Hmisc)
library(plyr)
mergedData$GDPGroups <- cut2(mergedData$GDP.Rank, g = 5)
table(mergedData$GDPGroups, mergedData$Income.Group) #5 countries in top quantile but lower middle income
