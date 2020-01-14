#' Title: Correlated Topic Modeling
#' Purpose: apply k-means
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: Jan-14-2020
#'

# Wd
setwd("/cloud/project/lessons/C_Wednesday/data")

# Libs
library(tm)
library(tidytext)
library(dplyr)
library(qdap)
library(radarchart)

# Bring in our supporting functions
source('/cloud/project/lessons/Z_otherScripts/ZZZ_supportingFunctions.R')

# Create custom stop words
stops <- c(stopwords('english'))

# Clean and Organize
txtDTM <- cleanMatrix('Weeknd.csv',
                      'text',
                      collapse        = F, 
                      customStopwords = stops, 
                      type            = 'DTM', 
                      wgt             = 'weightTf')

# Examine original & Compare

txtDTM[,1:10]
dim(txtDTM)

# Examine Tidy & Compare
# switch back to DTM because the convience function I wrote returns a matrix!!
# you can avoid this by not using the cleanMatrix function and instead coding it yourself
tmp      <- as.DocumentTermMatrix(txtDTM, weighting = weightTf ) 
tidyCorp <- tidy(tmp)
tidyCorp
dim(tidyCorp)

# Get bing lexicon
# "afinn", "bing", "nrc", "loughran"
bing <- get_sentiments(lexicon = c("bing"))
head(bing)

# Perform Inner Join
bingSent <- inner_join(tidyCorp, bing, by=c('term' = 'word'))
bingSent

# Quick Analysis
table(bingSent$sentiment)
#Negative:Positive 2.75:1

# Compare original with qdap::Polarity
polarity(read.csv('Weeknd.csv')$text)
# avg. polarity  -0.409

# Get afinn lexicon
afinn<-get_sentiments(lexicon = c("afinn"))
head(afinn)

# Perform Inner Join
afinnSent <- inner_join(tidyCorp,afinn, by=c('term' = 'word'))
afinnSent

# Quick Analysis
summary(afinnSent$value) 
plot(afinnSent$value, type="l", main="Quick Timeline of Identified Words") 

##### BACK TO PPT #####

# Get nrc lexicon; deprecated
#nrc <- get_sentiments(lexicon = c("nrc"))
nrc <- read.csv('nrcSentimentLexicon.csv')
head(nrc)

# Perform Inner Join
nrcSent <- inner_join(tidyCorp,nrc, by=c('term' = 'term'))
nrcSent

# Quick Analysis
table(nrcSent$sentiment)
emos <- data.frame(table(nrcSent$sentiment))
emos <- emos[-c(6,7),] #drop pos/neg
chartJSRadar(scores = emos, labelSize = 10, showLegend = F)

# End

