#' Title: Pyramids & comparison cloud
#' Purpose: 2 more visuals to compare word frequencies among corpora.
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-6-18
#'

# Set the working directory
setwd("/cloud/project/Z_otherData/US_Presidential_CampaignSpeeches")

# libs
library(pbapply)
library(tm)
library(rvest)

# custom functions
source('/cloud/project/Z_otherScripts/ZZZ_supportingFunctions.R')

# List files
clinton <- list.files(path = '/cloud/project/Z_otherData/US_Presidential_CampaignSpeeches/Clinton', pattern = 'Clinton_speech*', full.names = T)

trump <- list.files(path = '/cloud/project/Z_otherData/US_Presidential_CampaignSpeeches/Trump', pattern = 'Trump_speech*', full.names = T)

# Read in multiple files
clinton <- pblapply(clinton, read.csv)
trump   <- pblapply(trump, read.csv)

# Examine
head(clinton[[1]])
head(trump[[1]])

# Combine each speech into a data frame
x <- do.call(rbind, clinton)
y <- do.call(rbind, trump)

# Collapse the text of each speech
clintonCollapse <- paste(x$word, collapse = ' ')
trumpCollapse   <- paste(y$word, collapse = ' ')

# Make a single corpus of 2 docs
allTxt <- c(clintonCollapse, trumpCollapse)

# Declare stop words
stops <- stopwords('SMART')

# Declare Vec Source
allTxt <- VectorSource(allTxt)

# Make a volatile corpus
allCorp <- VCorpus(allTxt)

# Clean
allCorp <- cleanCorpus(allCorp, stops)

# Make a TDM then matrix
allTDM  <- TermDocumentMatrix(allCorp)
allTDMm <- as.matrix(allTDM)

# Name
colnames(allTDMm) <- c('clinton', 'trump')


# Viz
comparison.cloud(allTDMm, 
                 max.words=50, 
                 random.order=FALSE,
                 title.size=0.5,
                 colors=brewer.pal(ncol(allTDMm),"Dark2"),
                 scale=c(3,0.1))

# End