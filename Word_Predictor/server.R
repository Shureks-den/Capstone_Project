#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)

words <- readRDS("./data/Words")
trigrams <- readRDS("./data/trigrams")
bigrams <- readRDS("./data/bigrams")
quadgrams <- readRDS("./data/quadgrams")



PredictWord <- function(input, number = 0) {
    
    input <- cleanInput(input)
    
    if (length(input) == 1) {
        Result <- UseDataBase(input, ngrams = 2)
    } else if (length(input) == 2) {
        Result <- UseDataBase(input, ngrams = 3)
    } else if (length(input) > 2) {
        Result <- UseDataBase(input, ngrams = 4)
    }
    
    suppressWarnings(if (is.na(Result) != TRUE) {
        if(nrow(Result) >= number) {
            return (Result[1:number,3])
        }
        else {
            return (c(Result[,3], words[4:10,3]))
        }
    }
    else {
        words[1:4,]
    })
    
}



UseDataBase <- function(input, ngrams) {
    ## using quadgrams
    if (ngrams > 3) {
        UserInput <- paste(input[length(input)-2], input[length(input)-1], input[length(input)])
        Tokens <- quadgrams %>% filter(Predictor == UserInput)
        if (nrow(Tokens) >= 1) {
            return(Tokens[1:3])
        }
        return (UseDataBase(input, ngrams - 1))
    }
    
    
    ## using trigrams
    if (ngrams == 3) {
        UserInput <- paste(input[length(input)-1], input[length(input)])
        
        Tokens <- trigrams %>% filter(Predictor == UserInput)
        if (nrow(Tokens) >= 1) {
            return(Tokens[1:3])
        }
        return (UseDataBase(input, ngrams - 1))
    }
    
    if (ngrams == 2) {
        UserInput <- paste(input[length(input)])
        Tokens <- bigrams %>% filter(Predictor == UserInput)
        if (nrow(Tokens) >= 1) {
            return(Tokens[1:3])
        }
    }
    words[1:4,]
}

cleanInput <- function(input) {
    if (input == "" | is.na(input)) {
        return("")
    }
    input <- tolower(input)
    
    input <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("\\S+[@]\\S+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("@[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("#[^\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[0-9](?:st|nd|rd|th)", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[^\\p{L}'\\s]+", "", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("[.\\-!]", " ", input, ignore.case = FALSE, perl = TRUE)
    input <- gsub("^\\s+|\\s+$", "", input)
    input <- stripWhitespace(input)
    
    if (input == "" | is.na(input)) {
        return("")
    }
    
    input <- unlist(strsplit(input, " "))
    return(input)
    
}

shinyServer(function(input, output) {

    # original sentence
    output$userSentence <- renderText({input$input});
    
    # reactive controls
    observe({
        numPredictions <- input$num
        if (numPredictions == 1) {
            output$prediction1 <- reactive({PredictWord(input$input, 1)}[1])
            output$prediction2 <- NULL
            output$prediction3 <- NULL
            output$prediction4 <- NULL
        } else if (numPredictions == 2) {
            output$prediction1 <- reactive({PredictWord(input$input, 2)}[1])
            output$prediction2 <- reactive({PredictWord(input$input, 2)}[2])
            output$prediction3 <- NULL
            output$prediction4 <- NULL
        } else if (numPredictions == 3) {
            output$prediction1 <- reactive({PredictWord(input$input, 3)}[1])
            output$prediction2 <- reactive({PredictWord(input$input, 3)}[2])
            output$prediction3 <- reactive({PredictWord(input$input, 3)}[3])
            output$prediction4 <- NULL
        } else if (numPredictions == 4) {
            output$prediction1 <- reactive({PredictWord(input$input, 4)}[1])
            output$prediction2 <- reactive({PredictWord(input$input, 4)}[2])
            output$prediction3 <- reactive({PredictWord(input$input, 4)}[3])
            output$prediction4 <- reactive({PredictWord(input$input, 4)}[4])
        }
    })

})
