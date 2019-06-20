#' Purpose: Explore the sentiment and topics for polymath
#' TK
#' 6-20
#' 

# wd
setwd("/cloud/project/Z_otherData/misc")

# libs
library(qdap)
library(tm)
library(tidytext)
library(dplyr)
library(readxl)

# options
options(scipen = 999)
options(stringsAsFactors = F)

# data in
alex <- read_xlsx("Polymath_GSERM_Text_Mining_Cayrol_Alex.xlsx")

# Sample pretrent we downsampled
#...

# Explore
unique(as.factor(alex$`Name_authors(without spaces)`))
names(alex)
str(alex)
table(alex$`Name_authors(without spaces)`)

# Clean up the column name to avoid spacing
grep("Name_authors", names(alex))
names(alex)[8] <- 'Name_authors'
names(alex)

grep('post', names(alex), ignore.case = T)
names(alex)[10] <- 'text'

alexDF <- data.frame(doc_id     = alex$doc_id,
                     text       = alex$text,
                     ID_authors = alex$ID_authors)

# Create custom stopwords
stops <- stopwords(kind = 'SMART')

# Modify or Preprocessing
alexDF$text <- tolower(alexDF$text)
alexDF$text <- stripWhitespace(alexDF$text)
alexDF$text <- bracketX(alexDF$text)
alexDF$text <- rm_url(alexDF$text)
alexDF$text <- removeWords(alexDF$text, stops)
alexDF$text <- removePunctuation(alexDF$text)
alexDF$text <- removeNumbers(alexDF$text)
alexDF$text <- stripWhitespace(alexDF$text)

# Declare our source and construct a VCorpus
alexCorp <- VCorpus(DataframeSource(alexDF))


# Make DTM
alexDTM  <- DocumentTermMatrix(alexCorp)
alexDTM2 <- removeSparseTerms(alexDTM,sparse = 0.995)
alexDTMm <- as.matrix(alexDTM2) 

# "Model"
qdapAlex <- polarity(alexDF$text[1:10], alexDF$ID_authors[1:10])

# Make tidy format
tmp      <- as.DocumentTermMatrix(alexDTM2, weighting = weightTf ) #switch back to DTM
tidyCorp <- tidy(tmp)

# Bring in a lexicon
nrc <- read.csv('/cloud/project/C_Wednesday/data/nrcSentimentLexicon.csv')

# inner join
nrcResults <- inner_join(tidyCorp, nrc, by = 'term') 

# Afinn 
afinn <- get_sentiments(lexicon = c("afinn"))

afinnResults <- inner_join(tidyCorp, afinn, by =c('term' = 'word'))


# Assess
summary(afinnResults)
hist(afinnResults$score)
table(nrcResults$sentiment)


# End