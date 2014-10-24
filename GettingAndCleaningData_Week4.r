###################################
#Getting and Cleaning Data - Week 4
###################################

###############################
#Lec 4-1 Editing Text Variables
###############################

#fixing char vectors - tolower(), toupper()
if(!file.exists("./data")){
    dir.create("./data")
} 
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras.csv")
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)
tolower(names(cameraData))

#fixing char vectors - strsplit()
#good for auto spliting var names
#important params: x, split
splitNames <- strsplit(names(cameraData), "\\.") #split on '.'
splitNames[[5]]
splitNames[[6]]


#An aside - lists
mylist <- list(letters = c("A","b","c"), numbers = 1:3, matrix(1:25, ncol = 5))
head(mylist)
#see: http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%203.pdf

mylist[1]
mylist$letters
mylist[[1]]
class(mylist[1])
class(mylist$letters)
class(mylist[[1]])
mylist$letters == mylist[[1]]

#Fixing character vectors - sapply()
#apply a fcn to each elt of vec or list
#important params: X, FUN

splitNames[[6]][1]

firstElt <- function(x){x[1]}
sapply(splitNames, firstElt)


#Peer review data
fileUrl1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews.csv")
download.file(fileUrl2,destfile="./data/solutions.csv")
reviews <- read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)


#Fixing char vectors - sub()
#important params: pattern, replacement, x
names(reviews)
sub("_", "", names(reviews),) #remove underscores

#Fixing char vectors - gsub()
testName <- "this_is_a_test"
sub("_", "", testName) #only replaces first _
gsub("_", "", testName) #replaces all _

#finding values - grep(), grepl()
grep("Alameda", cameraData$intersection)

table(grepl("Alameda", cameraData$intersection))

cameraData2 <- cameraData[!grepl("Alameda", cameraData$intersection), ]
table(grepl("Alameda", cameraData2$intersection)) #subset all intersections not = "Alameda"

#More on grep()
grep("Alameda", cameraData$intersection, value = T)

grep("JeffStreet", cameraData$intersection)

length(grep("JeffStreet", cameraData$intersection))

#see: http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%203.pdf

#More useful string fcns
library(stringr)
nchar("David Schonberger")

substr("David Schonberger", 1,7) #1-7 inclusive

paste("David", "Schonberger")

paste0("David", "Schonberger")

str_trim("   David     ")


##############################
#Lec 4-2 Regular Expressions I
##############################

#literals and/or metacharacters that define a grammar
#need to express:
#whitespace word boundaries
#sets of literals
#beginng and end of a line
#alternatives

#^ matches start of a line
#^i think matches
#i think of nothing all day
#i think i need to sleep

#$ matches end of line
#end$ matches:
#This is the end
#It hit my rear end
#Try to make it bend

#character classes using []
#[Bb][Uu][Ss][Hh] matches
#Name the worst thing about Bush
#I saw a burning bush in the desert
#I read the Bushwacked Piano

#^[Ii] am matches:
#i am at home
#I am not at home
#i ambled in to work

#Can specify ranges of letters or numbers
#^[0-9][a-zA-Z] matches:
#7th inning stretch
#2nd half coming up
#3am is my best time of day
#5cm give or tale

#In a character class the ^ is also a meta char indicates matching chars NOT in class
#[^?.]$ matches lines that do not end in . or ?:
#hello my friend!
#goodbye my friend,
#hello
#hmmm????!


###############################
#Lec 4-3 Regular Expressions II
###############################

#'.' is a wildcar referring to any single char
#9.11 matches:
#it's 9:11am
#today is 9/11
#tomorrow is 9-11
#the ip addy is 127.169.111.0
#the number 9811 is prime

#The pipe '|' is a logical or
#flood|fire matches:
#he said fire
#my land flooded
#Fire him!
#I was just fired for insubordination

#Okay to pipe several alternatives:
#flood|fire|earthquake|plague|pestilence

#alternatives may be expressions, not just literals:
#^[Gg]ood|[Bb]ad matches any line beginning with Good/good or containing Bad/bad anywhere in the line:
#Badass
#bad dog
#goodness gracious
#Good grief
#I had a bad day

#^([Gg]ood|[Bb]ad) only matches line that begin with either word:
#Good day!
#bad news
#goodness me
#Badly done

#The ? indicates the expression is optional
#[Gg]eorge( [Ww]\.)? [Bb]ush matches:
#Never should have elected George Bush
#george w. bush is a war criminal

#Note the '\.' abovematches the literal '.' since we recall a '.' by itself is a wildcard
#In general need a backslash in front any metachar you wish match as an actual char in the expression

#Metachars * and +
#indicate repetition
#* means 0 or more occurences
#+ means at least one occurence
#(.*) matches:
#(anybody in there?)
#(a)
#()

#[0-9]+(.*)[0-9]+ matches
#720 dpi
#I will be 23 next week
#time 4 me 2 go 2 bed

#{ and } are interval quantifiers: specify min and max number of matches
#[Bb]ush( +[^ ]+ +){1,5} debate matches "B/bush", then 1-5 reps of ">= 1 space, >= 1 non-space, followed by >= 1 space", then "debate":
#Bush can't debate
#bush says he wants one more debate
#Bush will lose this debate

#'m,n' means >=m but  <= n matches
#'m' means exactly m matches
#'m,' means >= m matches

#parens may be used to also 'remember' text matched by enclosed subexpression, using \1, \2. etc to refer to matched text
# +([a-zA-Z]+) +\1 + means
#at least one space 
#followed by one or more chars
#followed by at least one space
#followed by the remembered char seq
#followed by at least one space
#So it matches:
#time for bed, night night y'all
#blah blah blah
#my ass is so so very itchy
# anybody anybody here?


#By default, the * is greedy so it matches the longest possible string satisfying the reg ex
#^s(,*)s matches each of these entirely:
#sitting at starbucks
#setting up mysql and rails
#studying shit for the last exams

#Turn off greedy * with ?
#^s(.*?)s

################################################
#Function that take regular expressions as args:
#grep() 
#grepl() 
#sub()
#gsub()
################################################




###########################
#Lec 4-4 Working with Dates
###########################
d1 <- date()
d1
class(d1) #character

d2 <- Sys.Date()
d2 #2014-09-15
class(d2) #Date

#Formatting dates:
#%d - day as number 0-31
#%a - abbrev weekday
#%A - unabbrev weekday
#%m - month 01-12
#%b - abbrev month
#%B - unabbrev month
#%y - 2 digit year
#%Y - 4 digit year

format(d2, "%a %b %d") #e.g Mon Sep 15

#Creating dates
x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
z <- as.Date(x, "%d%b%Y")
z
z[1] - z[2] #diff of -1 days
as.numeric(z[1] - z[2]) #-1

#Converting to Julian
weekdays(d2) #Monday
months(d2) #September
julian(d2) #16328 (days since 1/1/1970

#Lubridate
intall.packages("lubridate")
library(lubridate)
ymd("20140108") #2014-01-08 UTO
mdy("08/04/2013") #2013-08-04 UTC
dmy("03-04-2013") #2013-04-03 UTC

#see http://www.r-statistics.com/2012/03/do-more-with-dates-and-times-in-r-with-lubridate-1-1-0/

#Dealing with times
ymd_hms("2011-08-03 10:15:03") #2011-08-03 10:15:03 UTC
ymd_hms("2011-08-03 10:15:03", tz = "Pacific/Auckland") # 2011-08-03 10:15:03 NZST
?Sys.timezone #for more info

#see http://www.r-statistics.com/2012/03/do-more-with-dates-and-times-in-r-with-lubridate-1-1-0/

#Some fcns have slightly different syntax
x <- dmy(c("1jan2013", "2jan2013", "31mar2013", "30jul2013"))
wday(x[1]) #3
wday(x[1], label = T) #Tuesday

#see also http://cran.r-project.org/web/packages/lubridate/vignettes/lubridate.html

#ultimately wants dates as Date class or else POSIXct or POSIXlt classes
?POSIXlt


#######################
#Lec 4-5 Data Resources
#######################



#######
#Quiz 4
#######

###########
#Question 1
###########

if(!file.exists("./data")){
    dir.create("./data")
} 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./data/idahoHousingData.csv")
dat <- read.csv("./data/idahoHousingData.csv")
names(dat)
splitNames <- strsplit(names(dat), "wgtp") #split on 'wgtp'
splitNames[[123]] # "" "15"

###########
#Question 2
###########

library(stringr)
library(plyr)
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1, destfile = "./data/gdpData.csv")
gdp <- read.csv("./data/gdpData.csv", header = F) #note, need to manually remove crap at beginning of file, or skip about 10 lines when reading in
names(gdp) <- c("CountryCode", "GDP.Rank", "X1", "Long.Name", "GDP", "X2", "X3", "X4", "X5", "X6")
gdp$GDP <- as.character(gdp$GDP)
gdp$GDP <- str_trim(gdp$GDP)
gdp$GDP <- str_replace_all(gdp$GDP, ",", "")
gdp$GDP <- as.numeric(gdp$GDP)
meanGDP <- mean(gdp$GDP) #about 377652

###########
#Question 3
###########

grep("^United", gdp$Long.Name, value = T) #USA, UK, UAE


###########
#Question 4
###########

library(stringr)
library(plyr)
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1, destfile = "./data/gdpData.csv")
gdp <- read.csv("./data/gdpData.csv", header = F) #note, need to manually remove crap at beginning of file, or skip about 10 lines when reading in
names(gdp) <- c("CountryCode", "GDP.Rank", "X1", "Long.Name", "GDP", "X2", "X3", "X4", "X5", "X6")
gdp$GDP <- as.character(gdp$GDP)
gdp$GDP <- str_trim(gdp$GDP)
gdp$GDP <- str_replace_all(gdp$GDP, ",", "")
gdp$GDP <- as.numeric(gdp$GDP)


fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl2, destfile = "./data/educationalData.csv")
edu <- read.csv("./data/educationalData.csv")

#gdp$V1 and edu$CountryCode are the three letter country codes on which we match
mergedData <- merge(gdp, edu, by.x = "CountryCode", by.y = "CountryCode")

#Info on FY end is in 'Special.Notes' var
specialNotes <- mergedData$Special.Notes
sum(grepl("^.*Fiscal year end: June", specialNotes)) #13 coutries have fy ending in June

###########
#Question 5
###########

install.packages("quantmod")
library(quantmod)
library(lubridate)
amzn <- getSymbols("AMZN", auto.assign = F)
sampleTimes <- index(amzn)
sum(grepl("2012", sampleTimes)) #250 data points from 2012
sum(wday(sampleTimes, label = T) == "Mon" & year(sampleTimes) == 2012) #47

