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
source('/cloud/project/Z_otherScripts/ZZZ_supportingFunctions.R')

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
txtDTM
dim(txtDTM)

# Examine Tidy & Compare
tmp      <- as.DocumentTermMatrix(txtDTM, weighting = weightTf ) #switch back to DTM
tidyCorp <- tidy(tmp)
tidyCorp
dim(tidyCorp)

# Get bing lexicon
# "afinn", "bing", "nrc", "loughran"
bing <- get_sentiments(lexicon = c("bing"))
head(bing)

# Perform Inner Join
bingSent <- inner_join(tidyCorp, bing, by=c('term'='word'))
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
afinnSent <- inner_join(tidyCorp,afinn, by=c('term'='word'))
afinnSent

# Quick Analysis
summary(afinnSent$score) #updated version is $value
plot(afinnSent$score, type="l", main="Quick Timeline of Identified Words") 

##### BACK TO PPT #####

# Get nrc lexicon; deprecated
#nrc <- get_sentiments(lexicon = c("nrc"))
nrc <- read.csv('nrcSentimentLexicon.csv')
head(nrc)

# Perform Inner Join
nrcSent <- inner_join(tidyCorp,nrc, by=c('term'='term'))
nrcSent

# Quick Analysis
table(nrcSent$sentiment)
emos <- data.frame(table(nrcSent$sentiment))
emos <- emos[-c(6,7),] #drop pos/neg
chartJSRadar(scores = emos, labelSize = 10, showLegend = F)

# End

