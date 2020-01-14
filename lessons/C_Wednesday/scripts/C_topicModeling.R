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
library(qdap)
library(pbapply)
library(lda)
library(LDAvis)
library(dplyr)
library(treemap)

# Bring in our supporting functions
source('/cloud/project/Z_otherScripts/ZZZ_supportingFunctions.R')

# In some cases, blank documents and words are created bc of preprocessing.  This will remove.
blankRemoval<-function(x){
  x<-unlist(strsplit(x,' '))
  x<-subset(x,nchar(x)>0)
  x<-paste(x,collapse=' ')
}

# Each term is assigned to a topic, so this will tally for a document & assign the most frequent as membership
docAssignment<-function(x){
  x<-table(x)
  x<-as.matrix(x)
  x<-t(x)
  x<-max.col(x)
}


# Options & Functions
options(stringsAsFactors = FALSE)
Sys.setlocale('LC_ALL','C')

# Stopwords
stops <- c(stopwords('SMART'), 'pakistan', 'gmt', 'pm')

# Data articles from ~2016-04-04
text <- readRDS("Guardian_text.rds")
text$body[1]

# String clean up 
text$body <- iconv(text$body, "latin1", "ASCII", sub="")
text$body <- gsub('http\\S+\\s*', '', text$body ) #rm URLs
text$body <- bracketX(text$body , bracket="all") #rm strings in between parenteses
text$body <- replace_abbreviation(text$body ) # replaces a.m. to AM etc


# Instead of DTM/TDM, just clean the vector w/old functions
txt <- VCorpus(VectorSource(text$body))
txt <- cleanCorpus(txt, stops)

# Extract the clean text
txt <- unlist(pblapply(txt, content))

# Remove any blanks, happens sometimes w/tweets bc small length & stopwords
txt<-pblapply(txt,blankRemoval)

# Lexicalize
txtLex <- lexicalize(txt)

# Examine
head(txtLex$vocab)
head(txtLex$documents[[1]])
head(txtLex$documents[[20]])

# Corpus stats
txtWordCount  <- word.counts(txtLex$documents, txtLex$vocab)
txtDocLength  <- document.lengths(txtLex$documents)

# LDA Topic Modeling
k       <- 5
numIter <- 25 
alpha   <- 0.02 
eta     <- 0.02
set.seed(1234) 
fit <- lda.collapsed.gibbs.sampler(documents      = txtLex$documents, 
                                   K              = k, 
                                   vocab          = txtLex$vocab, 
                                   num.iterations = numIter, 
                                   alpha          = alpha, 
                                   eta            = eta, 
                                   initial        = NULL, 
                                   burnin         = 0,
                                   compute.log.likelihood = TRUE)

# Prototypical Document
top.topic.documents(fit$document_sums,1)

# LDAvis params
theta <- t(pbapply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi   <- t(pbapply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

ldaJSON <- createJSON(phi = phi,
                      theta = theta, 
                      doc.length = txtDocLength, 
                      vocab = txtLex$vocab, 
                      term.frequency = as.vector(txtWordCount))

serVis(ldaJSON)

# Topic Extraction
top.topic.words(fit$topics, 10, by.score=TRUE)

# Name Topics
topFive <- top.topic.words(fit$topics, 5, by.score=TRUE)
topFive <- apply(topFive,2,paste, collapse=' ')

# Topic fit for first 10 words of 2nd doc
fit$assignments[[2]][1:10]

# Get numeric assignments
topicAssignments <- unlist(pblapply(fit$assignments,docAssignment))


# Recode to the top words for the topics
length(topicAssignments)
topicAssignments
assignments <- recode(topicAssignments, topFive[1], topFive[2], 
                      topFive[3],topFive[4],topFive[5])

# Polarity calc to add to visual
txtPolarity <- polarity(txt)[[1]][3]
#saveRDS(txtPolarity, 'txtPolarity.rds')

# Final Organization
allTree <- data.frame(topic=assignments, 
                      polarity=txtPolarity,
                      length=txtDocLength)

set.seed(1237)
treemap(allTree,
        index=c("topic","length"),
        vSize="length",
        vColor="polarity",
        type="value", 
        title="Guardan Articles mentioning Pakistan",
        palette=c("red","white","green"))


# End