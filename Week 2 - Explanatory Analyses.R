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
words<-sample(structedBlogs$word,50000)
words<-c(words, sample(structedNews$word, 50000))
words<-c(words, sample(structedTwitter$word, 50000))
wordcloud(words, max.words = 250, random.order = FALSE, colors = brewer.pal(8, "Set2"))
rm(structedBlogs, structedNews, structedTwitter)

unique_words<-as.data.frame(table(words))
View(unique_words)
unique_words <- unique_words[-(1:785),]
unique_words <- unique_words[order(unique_words$Freq, decreasing = TRUE),]
unique_words$words <- as.character(unique_words$words)
unique_words$Pred <- unique_words$words
saveRDS(unique_words, "Words")

sample.news<-sample(data.news, 5000)
sample.twitter<-sample(data.twitter, 5000)
sample.blogs<-sample(data.blogs, 5000)
mass_sample<-c(sample.blogs, sample.news, sample.twitter)
txt<-sent_detect(mass_sample)
rm(sample.blogs, sample.news, sample.twitter)
txt <- removeNumbers(txt)
txt <- removePunctuation(txt)
txt <- stripWhitespace(txt)
txt <- tolower(txt)
txt <- txt[which(txt!="")]
txt <- data.frame(txt,stringsAsFactors = FALSE)
grams<-NGramTokenizer(txt, Weka_control(min = 2, max = 2))

for(i in 1:length(grams)) {
    if(length(WordTokenizer(grams[i]))==2) 
        break
}

for(j in 1:length(grams)) {
    if(length(WordTokenizer(grams[j]))==1) 
        break
}

bigramss <- data.frame(table(grams))
bigrams <- bigrams[order(bigrams$Freq, decreasing = TRUE),]
trigrams <- data.frame(table(grams[1:(i-1)]))
trigrams <- trigrams[order(trigrams$Freq, decreasing = TRUE),]

## 2 word graphic
top_bigrams <- bigrams[1:20,]
bi_plot <- ggplot(top_bigrams, aes(x = reorder(Var1, -Freq), Freq))
bi_plot + geom_bar(stat = "identity", col = "purple", fill = "#009999")

## 3 word graphic
top_trigrams <- trigrams[1:15,]
tri_gram_plot <- ggplot(top_trigrams, aes(x = reorder(Var1, -Freq), Freq))
tri_gram_plot + geom_bar(stat = "identity", col = "blue", fill = "Forest Green")
