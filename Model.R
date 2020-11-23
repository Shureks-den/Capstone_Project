words <- readRDS("./Words")
trigrams <- readRDS("./trigrams")
bigrams <- readRDS("./bigrams")
quadgrams <- readRDS("./quadgrams")



PredictWord <- function(input, number = 0) {
    if (length(strsplit(input, split = " ")[[1]]) == 1) {
        Result <- UseDataBase(input, ngrams = 2)
    } else if (length(strsplit(input, split = " ")[[1]]) == 2) {
        Result <- UseDataBase(input, ngrams = 3)
    } else if (length(strsplit(input, split = " ")[[1]]) > 2) {
        Result <- UseDataBase(input, ngrams = 4)
    }
    
    suppressWarnings(if (is.na(Result) != TRUE) {
        if(nrow(Result) >= number) {
            return (Result[1:number,3])
        }
        else {
            print("Matches found less than needed")
            print("Matches found:", nrow(Result))
            return (Result[,3])
        }
    }
    else {
        print("No matches found")
    })
    
}



UseDataBase <- function(input, ngrams) {
    ## using quadgrams
    if (ngrams > 3) {
        UserInput <- paste(strsplit(input, split = " ")[[1]][length(strsplit(input, split = " ")[[1]])-2], 
                           strsplit(input, split = " ")[[1]][length(strsplit(input, split = " ")[[1]])-1],
                           strsplit(input, split = " ")[[1]][length(strsplit(input, split = " ")[[1]])])
        Tokens <- quadgrams %>% filter(Predictor == UserInput)
        if (nrow(Tokens) >= 1) {
            return(Tokens[1:3])
        }
        return (UseDataBase(input, ngrams - 1))
    }

    
    ## using trigrams
    if (ngrams == 3) {
        UserInput <- paste(strsplit(input, split = " ")[[1]][length(strsplit(input, split = " ")[[1]])-1], 
                           strsplit(input, split = " ")[[1]][length(strsplit(input, split = " ")[[1]])])
        Tokens <- trigrams %>% filter(Predictor == UserInput)
        if (nrow(Tokens) >= 1) {
            return(Tokens[1:3])
        }
        return (UseDataBase(input, ngrams - 1))
    }
   
    if (ngrams == 2) {
        UserInput <- paste(strsplit(input, split = " ")[[1]][length(strsplit(input, split = " ")[[1]])])
        Tokens <- bigrams %>% filter(Predictor == UserInput)
        if (nrow(Tokens) >= 1) {
            return(Tokens[1:3])
        }
        words[1:3,]
    }
}
