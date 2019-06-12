#' Title: Dendros_WordNetworks_Associations
#' Purpose: Learn how to create a dendrogram, word network and association
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-4-29
#'

# Set the working directory
setwd("/cloud/project/B_Tuesday/data")

# Libs
library(tm)
library(qdap)
library(ggplot2)
library(ggthemes)
library(dendextend)

# Options & Functions
options(stringsAsFactors = FALSE)
Sys.setlocale('LC_ALL','C')

tryTolower <- function(x){
  y = NA
  try_error = tryCatch(tolower(x), error = function(e) e)
  if (!inherits(try_error, 'error'))
    y = tolower(x)
  return(y)
}

cleanCorpus<-function(corpus, customStopwords){
  corpus <- tm_map(corpus, content_transformer(qdapRegex::rm_url))
  corpus <- tm_map(corpus, content_transformer(replace_contraction)) 
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, content_transformer(tryTolower))
  corpus <- tm_map(corpus, removeWords, customStopwords)
  return(corpus)
}

# Dendogram coloring function
colLab <- function(n) {
  if (is.leaf(n)) {
    a <- attributes(n)
    labCol <- labelColors[clusMember[which(names(clusMember) == a$label)]]
    attr(n, "nodePar") <- c(a$nodePar, lab.col = labCol)
  }
  n
}

# Create custom stop words
stops <- c(stopwords('SMART'), 'amp', 'britishairways', 'british',
                     'flight', 'flights', 'airways')

# Read in Data, clean & organize
text      <- read.csv('BritishAirways.csv')
txtCorpus <- VCorpus(VectorSource(text$text))
txtCorpus <- cleanCorpus(txtCorpus, stops)
tweetTDM  <- TermDocumentMatrix(txtCorpus)
tweetTDMm <- as.matrix(tweetTDM)

# Frequency Data Frame
tweetSums <- rowSums(tweetTDMm)
tweetFreq <- data.frame(word=names(tweetSums),frequency=tweetSums)

# Simple barplot; values greater than 15
topWords      <- subset(tweetFreq, tweetFreq$frequency >= 15) 
topWords      <- topWords[order(topWords$frequency, decreasing=F),]

# Chg to factor for ggplot
topWords$word <- factor(topWords$word, 
                        levels=unique(as.character(topWords$word))) 

ggplot(topWords, aes(x=word, y=frequency)) + 
  geom_bar(stat="identity", fill='darkred') + 
  coord_flip()+ theme_gdocs() +
  geom_text(aes(label=frequency), colour="white",hjust=1.25, size=3.0)

# qdap version, slightly different results based on params but faster
plot(freq_terms(text$text, top=35, at.least=2, stopwords = stops))

############ Back to PPT

# Inspect word associations
associations <- findAssocs(tweetTDM, 'brewdog', 0.30)
associations

# Organize the word associations
assocDF <- data.frame(terms=names(associations[[1]]),
                       value=unlist(associations))
assocDF$terms <- factor(assocDF$terms, levels=assocDF$terms)
assocDF

# Make a dot plot
ggplot(assocDF, aes(y=terms)) +
  geom_point(aes(x=value), data=assocDF, col='#c00c00') +
  theme_gdocs() + 
  geom_text(aes(x=value,label=value), colour="red",hjust="inward", vjust ="inward" , size=3) 

############ Back to PPT

# Reduce TDM
reducedTDM <- removeSparseTerms(tweetTDM, sparse=0.985) #shoot for ~50 terms; 1.5% of cells in row have a value  
reducedTDM

# Organize the smaller TDM
reducedTDM <- as.data.frame(as.matrix(reducedTDM))

# Basic Hierarchical Clustering
hc <- hclust(dist(reducedTDM))
plot(hc,yaxt='n')

# Improved visual
hcd         <- as.dendrogram(hc)
clusMember  <- cutree(hc, 2)
labelColors <- c("#ff6347", "#036564")#, "#EB6841", "#EDC951")
clusDendro <- dendrapply(hcd, colLab)

par(mar=c(5,1,1,5)) #padding coordinates
plot(clusDendro, 
     main = "Hierarchical Dendrogram", 
     type = "triangle",
     yaxt='n')

############ Back to PPT

networkStops <- c(stops, 'britishairways', 'british', 'airways', 'rt')

assocText <- rm_url(text$text)


word_associate(assocText, 
               match.string = 'brewdog', 
               stopwords = networkStops,
               network.plot = T,
               cloud.colors = c('gray85','darkred'))

word_associate(assocText, 
               match.string = 'brewdog', 
               stopwords = networkStops,
               wordcloud = T,
               cloud.colors = c('gray85','darkred'))


# End
