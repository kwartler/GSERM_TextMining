#' Author: TK
#' Date: 8-26-2019
#' Purpose: Answer student questions
#' 

# Q1. How to restart the R session?

# in cloud (R-Studio Server)
q('no')

# to restart the session with the same objects in your environment
# the benefit of this is freeing up RAM but not really a "fresh restart"
.rs.restartR()

# This is a custom function taken from this site:
#https://stackoverflow.com/questions/6313079/quit-and-restart-a-clean-r-session-from-within-r
restart_r <- function(status = 0, debug = TRUE) {
  if (debug) message("restart_r(): Customizing .Last() to relaunch R ...")
  assign(".Last", function() {
    args <- commandArgs()
    system2(args[1], args = args[-1])
  }, envir = globalenv())   
  if (debug) message("restart_r(): Quitting current R session and starting a new one ...")
  quit(save = "no", status = status, runLast = TRUE)
}
restart_r()


# there is a package that does this but would require loading it 
# or calling from the namespace with ::
# inside it will run the rm() to remove everything after the restart
rstudioapi::restartSession(command = rm(list = ls()))

# Q2.  Can I read and separate a txt file

# Read in a txt file (change this to your file)
txt1 <- readLines('https://raw.githubusercontent.com/kwartler/GSERM_TextMining/cacd1d9131fef31309d673b24e744a6fee54269d/E_Friday/data/clinton/C05758905.txt')

# Examine
txt1

# Collapse all lines to make it like a single giant document
txt2 <- paste(txt1, collapse = ' ')

# split on a string "Doc No." to demonstrate getting a single document to
# individual documents
indDocs <- strsplit(txt2, "Doc No.")

# The result is a list object so can be worked with this way
indDocs[[1]][1] # first doc
indDocs[[1]][2] # second doc
indDocs[[1]][3] # third doc

# or "unlist" the object, but this can be challenging if the list is complex
indDocs <- unlist(indDocs)
indDocs[1] # first Doc
indDocs[2] #second doc
indDocs[3] #third doc





# End