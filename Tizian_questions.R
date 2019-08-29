library(ggplot2)
data(diamonds)


varVec <- c('x','y','z')
chk <- list()
for (i in 1:3){
 firstVar <- (diamonds[,varVec[i]] - (4 * 3.2))
 chk[[i]] <- firstVar
 names(chk[[i]]) <- paste0('changed_',varVec[i])
 diamonds[,varVec[i]] <- NULL

}
head(do.call(cbind, chk))
