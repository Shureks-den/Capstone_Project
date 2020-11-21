library(tm)
library(XML)
library(wordcloud) 
library(RColorBrewer)
library(caret)
library(NLP) 
library(openNLP) 
library(RWeka)
library(qdap)
library(ggplot2)
set.seed(3999)


## words
words<-sample(structedBlogs$word,10000)
words<-c(words, sample(structedNews$word, 10000))
words<-c(words, sample(structedTwitter$word, 10000))
wordcloud(words, max.words = 250, random.order = FALSE, colors = brewer.pal(8, "Set2"))



sample.news<-sample(data.news, 2000)
sample.twitter<-sample(data.twitter, 2000)
sample.blogs<-sample(data.blogs, 2000)
mass_sample<-c(sample.blogs, sample.news, sample.twitter)
txt<-sent_detect(mass_sample)
rm(sample.blogs, sample.news, sample.twitter)
txt <- removeNumbers(txt)
txt <- removePunctuation(txt)
txt <- stripWhitespace(txt)
txt <- tolower(txt)
txt <- txt[which(txt!="")]
txt <- data.frame(txt,stringsAsFactors = FALSE)
grams<-NGramTokenizer(txt)

for(i in 1:length(grams)) {
    if(length(WordTokenizer(grams[i]))==2) 
        break
}

for(j in 1:length(grams)) {
    if(length(WordTokenizer(grams[j]))==1) 
        break
    }

bigrams <- data.frame(table(grams[i:(j-1)]))
bigrams <- bigrams[order(bigrams$Freq, decreasing = TRUE),]
trigrams <- data.frame(table(grams[1:(i-1)]))
trigrams <- trigrams[order(trigrams$Freq, decreasing = TRUE),]

## 2 word graphic
top_bigrams <- bigrams[1:20,]
bi_plot <- ggplot(top_bigrams, aes(x = reorder(Var1, -Freq), Freq))
bi_plot + geom_bar(stat = "identity", col = "purple", fill = "#009999")

## 3 word graphic
top_trigrams <- trigrams[1:20,]
tri_gram_plot <- ggplot(top_trigrams, aes(x = reorder(Var1, -Freq), Freq))
tri_gram_plot + geom_bar(stat = "identity", col = "blue", fill = "Forest Green")
