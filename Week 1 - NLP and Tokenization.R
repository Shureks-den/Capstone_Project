##Downloading a file
zip_url<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
zip_name <- "Data.zip"
download.file(zip_url, zip_name)
unzip(zip_name)



## Reading into memory

data.blogs<-readLines("./final/en_US/en_US.blogs.txt", skipNul = TRUE, warn = FALSE, encoding = "UTF-8")
data.news<-readLines("./final/en_US/en_US.news.txt", skipNul = TRUE, warn = FALSE, encoding = "UTF-8")
data.twitter<-readLines("./final/en_US/en_US.twitter.txt", skipNul = TRUE, warn = FALSE, encoding = "UTF-8")


## What's to do next ????

library(tidyverse) #keepin' things tidy
library(tidytext) #package for tidy text analysis (Check out Julia Silge's fab book!)
library(glue) #for pasting strings
library(data.table)



tidytext <- function (filename) {
    structed.info<-as_data_frame(filename)
    structed.info
}

tidyword <- function (filename) {
    structed.info<-as_data_frame(filename)
    head(structed.info)
    blogTokens<-structed.info %>% unnest_tokens(word,value) %>% anti_join(data.frame(word = "a"))
    blogTokens
}

structedNews<-tidyword(data.news)
structedBlogs<-tidyword(data.blogs)
structedTwitter<-tidyword(data.twitter)
rm(data.twitter, data.news, data.blogs)

# Quiz 3
max(nchar(tidytext(data.blogs)$value))
max(nchar(tidytext(data.news)$value))
max(nchar(tidytext(data.twitter)$value))

# Quiz 4
twitterLines<-tidytext(data.twitter)
twitterLinesWithLove<-twitterLines$value[grepl("love", twitterLines$value, ignore.case = FALSE)]
twitterLinesWithLove<-tidytext(twitterLinesWithLove)

twitterLinesWithHate<-twitterLines$value[grepl("hate", twitterLines$value, ignore.case = FALSE)]
twitterLinesWithHate<-tidytext(twitterLinesWithHate)

nrow(twitterLinesWithLove) / nrow(twitterLinesWithHate)

# Quiz 5 
BiostatRules<-twitterLines$value[grepl("biostat", twitterLines$value, ignore.case = FALSE)]
BiostatRules

# Quiz 6 
nrow(tidytext(twitterLines$value[grepl(
    "A computer once beat me at chess, but it was no match for me at kickboxing", 
    twitterLines$value, ignore.case = FALSE)]))


rm(data.twitter, data.news, data.blogs)
