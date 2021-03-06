#' Title: K Means
#' Purpose: apply k-mediods
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: Jan-14-2020
#' https://cran.r-project.org/web/packages/kmed/vignettes/kmedoid.html

# Wd
setwd("/cloud/project/lessons/C_Wednesday/data")

# Libs
library(kmed)
library(tm)
library(clue)
library(cluster)
library(wordcloud)

# Bring in our supporting functions
source('/cloud/project/lessons/Z_otherScripts/ZZZ_plotCluster.R')
source('/cloud/project/lessons/Z_otherScripts/ZZZ_supportingFunctions.R')

# Options & Functions
options(stringsAsFactors = FALSE)
Sys.setlocale('LC_ALL','C')

# Stopwords
stops <- c(stopwords('SMART'), 'work')

# Read & Preprocess
txtMat <- cleanMatrix(pth = '1yr_plus_final4.csv', 
                      columnName  = 'text', # clue answer text 
                      collapse = F, 
                      customStopwords = stops, 
                      type = 'DTM', 
                      wgt = 'weightTfIdf') #weightTf or weightTfIdf

# Remove empty docs w/TF-Idf
txtMat <- subset(txtMat, rowSums(txtMat) > 0)

# Use a manhattan distance matrix; default for kmed
manhattanDist <- distNumeric(txtMat, txtMat, method = "mrw")

# Calculate the k-mediod
txtKMeds <- fastkmed(manhattanDist, ncluster = 5, iterate = 5)

# Number of docs per cluster
table(txtKMeds$cluster)
barplot(table(txtKMeds$cluster), main = 'k-mediod')

# Visualize separation
plotcluster(manhattanDist, txtKMeds$cluster, pch = txtKMeds$cluster)

# Silhouette
silPlot          <- silhouette(txtKMeds$cluster, manhattanDist)
plot(silPlot, col=1:max(txtKMeds$cluster), border=NA)

# Median centroid documents:
txtKMeds$medoid

# End