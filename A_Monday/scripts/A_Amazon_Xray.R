#' Author: Ted Kwartler
#' Data: 4-23-2019
#' Purpose: GSERM: Intro to basic R operations
#' 
### 1. Set working directory to your specific movie
setwd("/cloud/project/Monday/data/xRay/legoMovie")
  
# Turn off scientific notation
options(scipen = 999)

### 2. Load libraries to customize R
library(ggplot2)
library(ggthemes)

### 3. Read in data
# Use the read.csv function for your specific definedScenes.csv file
scenesDF   <- read.csv('lego_definedScenes.csv')

### 4. Apply functions to clean up data & get insights/analysis
# Use the names function to review the names of scenesDF
names(scenesDF)

# Review the bottom 6 records of scenesDF
tail(scenesDF)

# Clean up the raw data with a "global substitution"
scenesDF$id <- gsub('/xray/scene/', "", scenesDF$id)
tail(scenesDF)

# Change ID class from string to numeric
scenesDF$id <-as.numeric(scenesDF$id)

# Remove a column
scenesDF$fictionalLocation <- NULL

# Make a new column
scenesDF$length <- scenesDF$end - scenesDF$start 

# Basic statistics
summary(scenesDF) 

### 5. Project artifacts ie visuals & (if applicable)modeling results/KPI
# Quick plot
hist(scenesDF$length)
summary((scenesDF$length/1000)%/%60) 

# Identify the outlier, review; note the double ==
subset(scenesDF, scenesDF$length == max(scenesDF$length))

################ BACK TO PPT FOR EXPLANATION ##################
ggplot(scenesDF, aes(colour=scenesDF$name)) + 
  geom_segment(aes(x=scenesDF$start, xend=scenesDF$end,
                   y=scenesDF$id, yend=scenesDF$id),size=3) +
  geom_text(data=scenesDF, aes(x=scenesDF$end, y=scenesDF$id,  label = scenesDF$name), 
            size = 2.25, nudge_y = 1.15,color = 'black', alpha = 0.5) +
  theme_gdocs() + theme(legend.position="none")

# End