# Load packages ----
library(psych)
library(tidyverse)
library(DT)
library(shiny)
library(shinythemes)
library(shinycssloaders)


# Define the UI -----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("BabyTB Certification Checklist"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    # Input: Selector for variable to plot against mpg ----
    selectInput("Domain", "Domain:", 
                c("Var1" = "q001",
                  "Var2" = "q002",
                  "Var3" = "q003")),
    
    # Input: Checkbox for whether outliers should be included ----
    # checkboxInput("outliers", "Show outliers", TRUE)
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    h1("Certification Checklist for ADD"),
    helpText("Note: help text isn't a true widget,", 
             "but it provides an easy way to add text to",
             "accompany other widgets."),
    
    h3("Before Beginning"),
    
    fluidRow(
      column(3,
             helpText("X")
             ),
      
      column(3,
           radioButtons("radio", p("Child (C), caregiver & examiner (E) are seated correctly"),
                        choices = list("Yes" = 1, "No" = 2,
                                       "NA" = 3),selected = 3)),
  
      column(3, 
             textInput("text", h3("Notes"), 
                       value = "Enter text..."))   
    ),
    h3("Testing"),
    fluidRow(),
    
    
    fluidRow(
      column(1,
           submitButton("Submit"))
    )
    )
  
  
  
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
}

shinyApp(ui, server)