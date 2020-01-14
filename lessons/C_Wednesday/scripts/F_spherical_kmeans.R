#' Title: K Means
#' Purpose: apply spherical k-means
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: Jan-14-2020
#'

# Wd
setwd("/cloud/project/lessons/C_Wednesday/data")

# Libs
library(skmeans)
library(tm)
library(clue)
library(cluster)
library(wordcloud)

# This is an orphaned lib which gives us plotcluster:
#https://www.rdocumentation.org/packages/fpc/versions/2.1-11.2
#library(fpc)

# Bring in our supporting functions
source('/cloud/project/Z_otherScripts/ZZZ_plotCluster.R')
source('/cloud/project/Z_otherScripts/ZZZ_supportingFunctions.R')

# Options & Functions
options(stringsAsFactors = FALSE)
Sys.setlocale('LC_ALL','C')

# Stopwords
stops  <- c(stopwords('SMART'), 'jeopardy')

# Read & Preprocess
txtMat <- cleanMatrix(pth = 'jeopardyArchive_1000.fst', 
                      columnName  = 'clue', # clue answer text 
                      collapse = F, 
                      customStopwords = stops, 
                      type = 'DTM', 
                      wgt = 'weightTfIdf') #weightTf or weightTfIdf

# Remove empty docs w/TF-Idf
txtMat <- subset(txtMat, rowSums(txtMat) > 0)

# Apply Spherical K-Means
txtSKMeans <- skmeans(txtMat, 3, m = 1, control = list(nruns = 5, verbose = T))
barplot(table(txtSKMeans$cluster), main = 'spherical k-means')

# Plot cluster to see separation
plotcluster(cmdscale(dist(txtMat)),txtSKMeans$cluster)

# Silhouette plot
sk <- silhouette(txtSKMeans)
plot(sk, col=1:3, border=NA)

# ID protypical terms
protoTypical           <- t(cl_prototypes(txtSKMeans))
colnames(protoTypical) <- paste0('cluster_',1:ncol(protoTypical))
comparison.cloud(protoTypical, max.words = 50, scale = c(.25,.75), 
                 title.size = 1, res=300)


clusterWC <- list()
for (i in 1:ncol(protoTypical)){
  jsWC <- data.frame(term = rownames(protoTypical),
                     freq = protoTypical[,i])
  jsWC <- jsWC[order(jsWC$freq, decreasing = T),]
  clusterWC[[i]] <- wordcloud2::wordcloud2(head(jsWC[1:200,]))
  print(paste('plotting',i))
}

clusterWC[[1]]
clusterWC[[2]]
clusterWC[[3]]


# Examine a portion of the most prototypical terms per cluster
nTerms <- 5
(clustA <- sort(protoTypical[,1], decreasing = T)[1:nTerms]) #American history
(clustB <- sort(protoTypical[,2], decreasing = T)[1:nTerms]) #author/playright
(clustC <- sort(protoTypical[,3], decreasing = T)[1:nTerms]) #geography

# End