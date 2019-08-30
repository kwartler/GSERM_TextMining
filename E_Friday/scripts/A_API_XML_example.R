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
youtubeCaption <- 'https://www.youtube.com/api/timedtext?v=Q-wRhzWaCac&asr_langs=de%2Cen%2Ces%2Cfr%2Cit%2Cja%2Cko%2Cnl%2Cpt%2Cru&caps=asr&xorp=true&hl=en&ip=0.0.0.0&ipbits=0&expire=1567169943&sparams=ip%2Cipbits%2Cexpire%2Cv%2Casr_langs%2Ccaps%2Cxorp&signature=BD28A73423534B9B1D17D008387C53B7E5F52F8E.7B5B3EA007E5A5FCCE607B1B12590457511FA853&key=yt8&kind=asr&lang=en&fmt=srv3'

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