###################################
#Getting and Cleaning Data - Week 2
###################################

###########################
#Lec 2-1 Reading from MySql 
###########################

#after installing RTools, MySql server, and RMySQL, can connect to dbs, such as...


ucscDb <- dbConnect(MySQL(), user = "genome", host = "genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb) #always remember to disconnect!
head(result)

#connect to hg19 and get list of all tables
hg19Con <- dbConnect(MySQL(), user = "genome", db = "hg19",host = "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19Con)
length(allTables)
allTables[1:10]

#get dims of a table
dbListFields(hg19Con, "affyU133Plus2")
dbGetQuery(hg19Con, "select count(*) from affyU133Plus2")

#table read
affyData <- dbReadTable(hg19Con, "affyU133Plus2")
head(affyData)
str(affyData) #58k+ obs of 22 vars


#select specific subset
query1_hg19 <- dbSendQuery(hg19Con, "select * from affyU133Plus2 where misMatches between 1 and 3") #send qeury to mysql server
affyMis <- fetch(query1_hg19) #pull results back to machine
quantile(affyMis$misMatches)
affyMisSmall <- fetch(query1_hg19, n = 10) #pull small number of results back to machine
dbClearResult(query1_hg19) #clear query from the remote server
dim(affyMisSmall)

#always remember to disconnect!
dbDisconnect(hg19Con)


##########################
#Lec 2-2 Reading from HDF5
##########################

source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created <- h5createFile("example.h5")

#create groups
created <- h5createGroup("example.h5","foo")
created <- h5createGroup("example.h5","baa")
created <- h5createGroup("example.h5","foo/foobaa")

#write data to groups
A <- matrix(1:10, nr = 5, nc = 2)
h5write(A, "example.h5", "foo/A")
B <- array(seq(0.1,2.0,by = 0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

#write a dataset
df <- data.frame(1L : 5L, seq(0,1,length.out = 5), c("ab","cde","fghi","a","s"), stringsAsFactors = F)
h5write(df, "example.h5", "df")
h5ls("example.h5")

#reading data
readA <- h5read("example.h5", "foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readdf <- h5read("example.h5", "df") #data set in top levele group
readA
readB
readdf

#writing and reading chunks
h5write(c(12,13,14), "example.h5", "foo/A", index = list(1:3,1))
h5read("example.h5", "foo/A")


#############################
#Lec 2-3 Reading from the Web
#############################

#getting data off webpages - readLines()
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode <- readLines(con)
close(con)
htmlCode

#parsing with xml
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url ,useInternalNodes = T)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue) #?????
xpathSApply(html, "//td", xmlValue)

#GET from the httr package
library(httr)
html2 <- GET(url)
content2 <- content(html2, as="text")
parsedHtml <- htmlParse(content2, asText = T)
xpathSApply(parsedHtml, "//title", xmlValue)

#accessing websites with passwords
pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1

pg2 <- GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))
pg2
names(pg2)

#using handles
google <- handle("http://google.com")
pg1 <- GET(handle = google, path = "/")
pg2 <- GET(handle = google, path = "search")


###########################
#Lec 2-4 Reading from API's
###########################

API key	TcMCh85xoi9TNoXZhf8rtR14B
API secret	XQwEBLxQTxNXSIH7lubu72bYNaMNa0PIUrqaUFwnmhLig0VDFC
Access token	806871344-35xzEcL7SyF4XZIzozKr1RM0xYpk4a5TxS1xHq5D
Access token secret	9uiLWokCwi6Vef8WaW5av1VusrDfZzclXhQpYeKI6MUoM

library(jsonlite)
myapp <- oauth_app("twitter", key = "TcMCh85xoi9TNoXZhf8rtR14B", secret = "XQwEBLxQTxNXSIH7lubu72bYNaMNa0PIUrqaUFwnmhLig0VDFC")
sig <- sign_oauth1.0(myapp, token = "806871344-35xzEcL7SyF4XZIzozKr1RM0xYpk4a5TxS1xHq5D", token_secret = "9uiLWokCwi6Vef8WaW5av1VusrDfZzclXhQpYeKI6MUoM")
homeTL <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 <- content(homeTL)
json2 <- fromJSON(toJSON(json1))
json2[1,1:4]
