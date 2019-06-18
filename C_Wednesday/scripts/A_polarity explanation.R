#' Title: Polarity Cluster
#' Purpose: Explore polarity calc
#' Author: Ted Kwartler
#' email: ehk116@gmail.com
#' License: GPL>=3
#' Date: 2019-5-13
#'

library(qdap)
polarity("She is doing a very good job.")
#ave.polarity = 0.68


# 1 polarized word = "good" = 1
#6 word cluster of 4 before and 2 after the polarized word
# cluster neutrals = "she" "is" "doing" "a" "job = 0
# amplifiers = "very" = 0.8
# total words in passage  = 7
# here is the result
(1 + 0.8) / sqrt(7) #= 0.6803361

polarity("He is doing a good job.")
#ave.polarity = .408
#without the amplifier it is 1 amplifier and N is now 6 not 7
(1) /sqrt(6) #=  0.4082483

polarity("the professor is not very good in lectures but entertaining")
#ave.polarity = 0.0
#-1.8 (*not* + very + good) + 1 (entertaining) = 0.8/sqrt(10)
0.8/sqrt(10) #=.253

polarity("the professor is very good in lectures and entertaining")
#ave.polarity = 0.0
#1.8 ( very + good) + 1 (entertaining) = 2.8/sqrt(9)
2.8/sqrt(9) #=.933
# End
