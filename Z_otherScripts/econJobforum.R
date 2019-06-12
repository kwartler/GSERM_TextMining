#' Title: Obtain text from econonics job forum
#' Purpose: Learn some basic scraping
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-5-12


# Lib
library(rvest)
library(purrr)

# Init
pg <- read_html('https://www.econjobrumors.com/') #https://www.econjobrumors.com/page/2
maxPg <- pg %>% html_node('.nav') %>% html_text()
maxPg <- as.numeric(gsub('Next|,| »','', tail(strsplit(maxPg, '…')[[1]],1)))

# Construct all pages
allURLS <- paste0('https://www.econjobrumors.com/page/', 1:maxPg)

# Get all possible threads among all pages
allLinks <- list()
for (i in 1:5){ #length(allURLS)
  print(paste('getting page ', allURLS[i]))
  
  # Get all links
  tmp <- pg %>% html_nodes("a") %>% html_attr("href")
  tmp <- tmp [grep('https://www.econjobrumors.com/topic/', tmp)]
  
  # Try to avoid appearing like DDOS
  Sys.sleep(1)
  allLinks[[allURLS[i]]] <- tmp
  print('finished')
}

# Organize into comprehensive thread vector
allThreads <- unlist(allLinks)

# Identify & Remove dupes
allThreads <- allThreads[-grep('#post', allThreads)]
allThreads <- unique(allThreads)
saveRDS(allThreads, 'C:/Users/Edward/Desktop/StGallen2019_student/Z_otherData/econForum/allThreads6_6_2019.rds')

# Extract elements from each page
threadScrape <- list()
for (i in 1:5){
  print(paste('scraping page', allThreads[i]))
  threadPg <- read_html(allThreads[i]) 
  threadPg %>% html_nodes(xpath = '//*[@id="position-1"]/div[1]') 
  threadPg %>% html_nodes(xpath = '//*[@id="thread"]') %>% html_text()
  
  # Author
  author <- threadPg %>% html_node(xpath = '//*[@id="thread"]') %>% html_nodes("[class='threadauthor']") %>% html_text()
  author <- trimws(gsub("\n|\t", '', author))
  
  postMeta <- threadPg %>% html_node(xpath = '//*[@id="thread"]') %>% html_nodes("[class='poststuff']") %>% html_text()
  
  allTxt <- vector()
  for(j in 1:length(postMeta)){
    postTxt <- threadPg %>% html_node(xpath = paste0('//*[@id="position-',j,'"]/div[2]/div[1]')) %>% 
      html_text()                              
    postTxt <- gsub('[\n]','', postTxt)
    allTxt[j] <- postTxt
  }
  
  
  # Get time
  postTime <- vector()
  for(j in 1:length(postMeta)){
    postTime[j] <- paste('SysTime:', Sys.time(), 'WebpageTime:',trimws(head(strsplit(postMeta, "[#]")[[j]],1)))
  }
  
  
  resp <- data.frame(author, 
                     postTime, 
                     raw_postMeta = postMeta,
                     url  = allThreads[i], 
                     text = allTxt )
  threadScrape[[i]] <- resp
  Sys.sleep(1)
}


threadScrape[[1]]$raw_postMeta
threadScrape[[1]]$text
# End

