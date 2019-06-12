#' Title: K Means
#' Purpose: apply k-mediods
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-5-12
#' https://cran.r-project.org/web/packages/kmed/vignettes/kmedoid.html

# Wd
setwd("/cloud/project/C_Wednesday/data")

# Libs
library(kmed)
library(tm)
library(clue)
library(cluster)
library(wordcloud)

# Bring in our supporting functions
source('/cloud/project/Z_otherScripts/ZZZ_plotCluster.R')
source('/cloud/project/Z_otherScripts/ZZZ_supportingFunctions.R')

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

# Two silhouette functions...kmed
silKMed <- kmed::silhoutte(manhattanDist, txtKMeds$medoid, txtKMeds$cluster)

# Examine results
silKMed$result[c(1:3,22:26, 47:50),]
silKMed$plot

# Two silhouette functions...kmed
silPlot <- cluster::silhouette(txtKMeds$cluster, manhattanDist)
plot(silPlot, border=NA)

# Median centroid documents:
txtKMeds$medoid

# End