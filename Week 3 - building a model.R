set.seed(3999)


## making test data


## making a finalize triagrams to use in prediction 
trigrams$pred <- 1
trigrams$Var1 <- as.character(trigrams$Var1)
for (i in 1:nrow(trigrams)) {
    trigrams[i, 3] <- strsplit(trigrams[i, 1], split = " ")[[1]][3]
    trigrams[i, 1] <- paste(strsplit(trigrams[i, 1], split = " ")[[1]][1], strsplit(trigrams[i, 1], split = " ")[[1]][2])
}

## making a finalize bigrams to use in prediction
bigrams$pred <- 1
bigrams$Var1 <- as.character(bigrams$Var1)
for (i in 1:nrow(bigrams)) {
    bigrams[i, 3] <- strsplit(bigrams[i, 1], split = " ")[[1]][2]
    bigrams[i, 1] <- strsplit(bigrams[i, 1], split = " ")[[1]][1]
}

colnames(quadgrams) <- c("Predictor", "Freq", "Result")
colnames(trigrams) <- c("Predictor", "Freq", "Result")
colnames(bigrams) <- c("Predictor", "Freq", "Result")

saveRDS(trigrams,"trigrams")
saveRDS(bigrams, "bigrams")
saveRDS(quadgrams,"quadgrams")




