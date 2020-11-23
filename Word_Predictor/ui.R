#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(markdown)
library(dplyr)
library(tm)


shinyUI(
    navbarPage("Next Word Predictor",
    tabPanel("Home",
        fluidPage(theme = shinytheme("united"),
            titlePanel("Predictor"),
                sidebarLayout(
                    
                    sidebarPanel(
                        textInput("input", "Enter your sentences or words:",
                            value = "",
                            placeholder = "Input your text here"),
                        sliderInput("num", "Number of predictions", min = 1, max = 4, value = 1)
                    ),
    
                    mainPanel(
                        h4("Inputted text"),
                        verbatimTextOutput("userSentence"),
                        br(),
                        h4("Predicted words"),
                        verbatimTextOutput("prediction1"),
                        verbatimTextOutput("prediction2"),
                        verbatimTextOutput("prediction3"),
                        verbatimTextOutput("prediction4"),
                    )
                )
            )
    ),
    tabPanel("How to use",
             h3("Guide"),
             br(),
             div("This is Shiny Web app. The point of this app is to predict next word, based on the inputted text.",
                 br(),
                 br(),
                 "User can input words in special field and after a couple of seconds suggested words will appear.",
                 br(),
                 br(),
                 "The source code for this application can be found
                            on GitHub:",
                 br(),
                 br(),
                 img(src = "github-logo.png"),
                 a(target = "_blank", href = "https://github.com/Shureks-den/Capstone_Project",
                   "Data Science Capstone Project")),
             )
)
)

