ls()
rm(list = ls())
setwd("Desktop/HackerEarth/Predict_the_Happiness/")
library(data.table)
train <- fread("train.csv")
test <- fread("test.csv")
dim(train)
dim(test)
colnames(train)
str(train)
summary(train)
unique(train$Browser_Used)
unique(train$Device_Used)

#here Browser_used has repeated levels
library(plyr)
train$Browser_Used <- revalue(train$Browser_Used,replace = c("Chrome"="Google Chrome","Firefox" = "Mozilla Firefox","Mozilla"="Mozilla Firefox",
                                       "IE"="Internet Explorer","InternetExplorer"="Internet Explorer"))
table(train$Browser_Used)

unique(test$Device_Used)
unique(test$Browser_Used)
test$Browser_Used <- revalue(test$Browser_Used,replace = c("Chrome"="Google Chrome","Firefox" = "Mozilla Firefox","Mozilla"="Mozilla Firefox",
                                                             "IE"="Internet Explorer","InternetExplorer"="Internet Explorer"))
table(test$Browser_Used)

library(NLP)
library(purrr)
library(tm)
library(qdap)
library(textclean)
library(lexicon)
library(SnowballC)
#install.packages("text2vec")
#library(text2vec)

#cleanData <- function(data)
#{
  
#  data[, Description := map_chr(Description, tolower)] # to lower
#  data[, Description := map_chr(Description, function(k) gsub(pattern = "[[:punct:]]",replacement = "",x = k))] # remove punctuation
#  data[, Description := map_chr(Description, function(k) gsub(pattern = "\\d+",replacement = "",x = k))] # remove digits
#  data[, Description := map_chr(Description, function(k) replace_abbreviation(k))] # Sr. to Senior
#  data[, Description := map_chr(Description, function(k) replace_contraction(k))] # isn't to is not
#  data[,Description := map(Description, function(k) rm_stopwords(k, Top200Words, unlist = T))] # remove stopwords
#  data[, Description := map(Description, function(k) stemmer(k))] # played, plays to play
#  data[, Description :=  map(Description, function(k) k[nchar(k) > 2])] # remove two alphabet words like to, ok, po
#  return (data)
#}
#train_clean <- cleanData(train)
#test_clean <- cleanData(test)


train_clean <- train[,Description:=map_chr(Description,tolower)]
train_clean[,Description:=map_chr(Description,removePunctuation)]
train_clean[,Description:=map_chr(Description,function(k) gsub(pattern = "\\d+",replacement = "",x = k))]
train_clean[,Description:=map_chr(Description,replace_abbreviation)]
train_clean[,Description:=map_chr(Description,replace_contraction)]
train_clean[,Description:=map(Description,function(k) rm_stopwords(k,Top200Words,unlist = T))]
train_clean[,Description:=map(Description,function(k) stemmer(k))]
train_clean[,Description:=map(Description,function(k) k[nchar(k) > 2])]
train_clean_frame <- as.data.frame(train_clean)
fwrite(train_clean, file ="train_clean.csv")


test_clean <- test[,Description:=map_chr(Description,tolower)]
test_clean[,Description:=map_chr(Description,removePunctuation)]
test_clean[,Description:=map_chr(Description,function(k) gsub(pattern = "\\d+",replacement = "",x=k))]
test_clean[,Description:=map_chr(Description,replace_abbreviation)]
test_clean[,Description:=map_chr(Description,replace_contraction)]
test_clean[,Description:=map(Description,function(k) rm_stopwords(k,Top200Words,unlist = T))]
test_clean[,Description:=map(Description,function(k) stemmer(k))]
test_clean[,Description:=map(Description,function(k) k[nchar(k) > 2])]
fwrite(test_clean,file = "test_clean.csv")

