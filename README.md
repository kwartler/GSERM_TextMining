# GSERM_TextMining
*For students of GSERM Text Mining Course*

## Environment Set-up
- The easiest method to execute code and avoid technical issues will be to use [https://rstudio.cloud](https://rstudio.cloud).  We may encounter some challenges along the way but this will likely mitigate technical problems related to individual systems.

- Please follow the setup instructions in the lecture 1 powerpoint located in [https://github.com/kwartler/GSERM_TextMining/blob/master/Rstudio_Cloud_Instructions.docx](https://github.com/kwartler/GSERM_TextMining/blob/master/Rstudio_Cloud_Instructions.docx) to set up a cloud space for programming.  You will need to click "download" to get the word doc locally.

- You *can* install R, R-Studio & Git locally on your laptop but any system issues will be yours to resolve.  However, your teaching staff will attempt to help.  We prefer the cloud instance so that all students are working on similar environments.

- If you encounter any errors during set up don't worry!  Please request technical help from Prof K.  The `qdap` library is usually the trickiest because it requires Java and `rJava`.  So if you get any errors, try removing that from the code below and rerunning.  This will take **a long time**, so if possible please run prior to class, and at a time you don't need your computer ie *at night*.  We have some time Monday morning devoted to resource allocation and package provisioning.

## R Packages

```
# Easiest Method to run in your console
install.packages('pacman')
pacman::p_load(ggplot2, ggthemes, stringi, hunspell, qdap, spelling, tm, dendextend, 
wordcloud, RColorBrewer, wordcloud2, pbapply, plotrix, ggalt, tidytext, textdata, dplyr, radarchart, 
lda, LDAvis, treemap, clue, cluster, fst, skmeans, kmed, text2vec, caret, glmnet, pROC, 
xml2, stringr, rvest, twitteR, jsonlite, docxtractr, readxl, udpipe, reshape2, openNLP, vtreat, e1071)

# Additionally we will need this package from a different repo
install.packages('openNLPmodels.en', repo= 'http://datacube.wu.ac.at/')

# You can install packages individually such as below if pacman fails.
install.packages('tm')

# Or using base functions use a nested `c()`
install.packages(c("lda", "LDAvis", "treemap"))

```

## Prerequisite Work
- As an intensive course students are expected to do the following homework.
  - Read the ethics articles in the repo before the ethics lecture
  - Read chapter 1 of the book [Text Mining in Practice with R](https://www.amazon.com/Text-Mining-Practice-Ted-Kwartler/dp/1119282012) book.
