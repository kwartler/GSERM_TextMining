#' Title: XML Data
#' Purpose: Explore XML data and organization
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-4-13
#'

# Libraries
library(xml2)
library(stringr)
library(rvest)

# WD
setwd("/cloud/project/E_Friday/data")

# Youtube URL
#https://www.youtube.com/watch?v=Q-wRhzWaCac
youtubeCaption <- 'https://www.youtube.com/api/timedtext?signature=E0EA69A0B9C9CBD233D899114B85449BDA3000D5.72A6F9E9CC7FC7068E67A3867490CEABAAA08EC1&v=Q-wRhzWaCac&sparams=asr_langs%2Ccaps%2Cv%2Cxoaf%2Cxorp%2Cexpire&asr_langs=es%2Cru%2Cit%2Cfr%2Cde%2Cko%2Cja%2Cnl%2Cen%2Cpt&key=yttt1&expire=1560339074&xoaf=1&caps=asr&hl=en&xorp=True&kind=asr&lang=en&fmt=srv3'

# Go get the data
dat <- read_xml(youtubeCaption)

# Extract text, remove carriage returns, remove special characters
text <- xml_text(dat)
text <- str_replace_all(text, "[\r\n]" , "")
text <- iconv(text, "latin1", "ASCII", sub="")

# Save as a plain text file
writeLines(text,'someNews.txt')

# Or to organize all of the information, XML "nodes" to list then DF 
pNodes    <- xml_find_all(dat, ".//p")
startTime <- xml_attr(pNodes, 't') #initial time to display
duration  <- xml_attr(pNodes, 'd') #duration from start time
text      <- xml_text(pNodes)

# Organize
textDF <- data.frame(startTime, duration, text)
textDF

# Identify blank lines and drop
chk <- ifelse(nchar(as.character(textDF$text))==1 & 
                grepl("[\n]", textDF$text)==T,'DROP','KEEP')
textDF <- subset(textDF, chk=='KEEP')

# Sometimes line breaks exist on lines we want to keep ie nchar > 1; so drop the breaks only
textDF$text <- gsub('[\n]', '', textDF$text)

# Examine to make sure format is ok
textDF

write.csv(textDF, 'timedText2.csv', row.names = F)

# End