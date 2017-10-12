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


train_clean <- train[,Description:=map_chr(Description,tolower)]# transform all letters to lower case
train_clean[,Description:=map_chr(Description,removePunctuation)] #remove punctuation
train_clean[,Description:=map_chr(Description,function(k) gsub(pattern = "\\d+",replacement = "",x = k))] #remove all the digits
train_clean[,Description:=map_chr(Description,replace_abbreviation)] #replace abbreviation like Sr. to Senior
train_clean[,Description:=map_chr(Description,replace_contraction)] #replace contraction like isn't to is not
train_clean[,Description:=map(Description,function(k) rm_stopwords(k,Top200Words,unlist = T))] #remove stopwords
train_clean[,Description:=map(Description,function(k) stemmer(k))] #stemming
train_clean[,Description:=map(Description,function(k) k[nchar(k) > 2])] #remove words that have two alphabets
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



