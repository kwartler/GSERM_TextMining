#' Title: Obtain text from jeopardy archive
#' Purpose: Learn some basic scraping
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-5-12
#'

#libs
library(rvest)
library(fst)

# Make all season URLS
seasons <- paste0('http://www.j-archive.com/showseason.php?season=',1:35)

# Drill down to all games within all seasons
allGameID <- list()
for(i in 1:length(seasons)){
  print(i)
  episodes <- read_html(seasons[i])
  episodes <- episodes %>% html_nodes("a") %>% html_attr("href")
  
  allGameID[[i]] <- episodes[grep('game_id', episodes)]
  Sys.sleep(1)
}

allGameID <- unlist(allGameID)

# Drill down to all clues in all games in all seasons; just getting 1000 games worth
clueID <- list()
for(j in 1:1000){#length(allGameID)){
  pg   <- read_html(allGameID[j])
  clue <- pg %>% html_nodes("a") %>% html_attr("href")
  clue <- clue[grep('clue_id', clue)]
  clue <- paste0('http://www.j-archive.com/', clue)
  clueID[[j]] <- clue
  print(j)
  #Sys.sleep(1)
}

clueID <- unlist(clueID)
clueID <- clueID[grepl('clue_id', clueID)] # odd, this didn't catch all in loop
#writeLines(clueID,'/cloud/project/jeopardyArchive/clueID_1000shows.txt')

allQuestions <- list()
for(k in 1:length(clueID)){
  pg <- read_html(clueID[k])
  
  # Clue
  clueTxt <- pg %>% html_nodes('#correction_clue_text') %>% html_text()
  
  # Answer
  answerTxt <- pg %>% html_nodes('#correction_clue_correct_response.clue_correct_response_input') %>% html_attrs()
  answerTxt <- answerTxt[[1]]['value']
  
  #allNodes <- pg %>% html_nodes("*") %>% 
  #  html_attr("class") %>% 
  #  unique()
  #allIDs <- pg %>% html_nodes("*") %>% 
  #  html_attr("id") %>% 
  #  unique()
  
  response <- data.frame(clue   = clueTxt, 
                         answer = answerTxt,
                         pg     = clueID[k])
  
 
  allQuestions[[k]] <- response
  print(k)
  
}

allQuestionsDF <-do.call(rbind, allQuestions)
write_fst(allQuestionsDF,'/cloud/project/jeopardyArchive/joepardyArchive.fst')

# End
