library(twitteR)
#https://developer.twitter.com/en


consumerKey        <- "[your Twitter consumer key]"
consumerSecret     <- "[your Twitter consumer secret]"
accessToken        <- "[your Twitter access token]"
accessTokenSecret  <- "[your Twitter access token secret]"

# Get tweets by search term (can use userTimeline)
subjectA <- searchTwitter('carrefour', n=1000, lang = 'en')

# chg to a data frame
subjectA <- twListToDF(subjectB)

#### UPDATED VERSION, howver does not play nicely w/cloud 
library(rtweet)

# Search w/new package will make you a "user" of the Rtweets app
tmls <- get_timelines('jairbolsonaro', n = 3200)

# Nested lists fix up, then you can write.csv for results
jairbolsonaro <- flatten(tmls)

# If desired, you can authorize your own app following this help page
vignette("auth", package = "rtweet")

# End

