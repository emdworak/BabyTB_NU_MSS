# Load packages ----
library(psych)
library(tidyverse)
library(DT)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(googlesheets4)
library(shinydashboard)


# # Set up google sheets -------
# shiny_token <- gs4_auth()
# saveRDS(shiny_token, "shiny_app_token.rds")
#
# #set up data sheet in google drive
# Data <- gs4_create("Data")

# Data <- Data %>%
#   sheet_append(ws = "Data", input = cbind("open1", "open2", "consc1", "consc2", "extra1",  "extra2", "agree1", "agree2", "neur1", "neur2", "timestamp"), trim = TRUE)
# #Note: for some reason it wont work if first row is blank so I went into the google sheet and put in some values in the first few rows
# sheetkey <- "XXXX" # you can get your key from Data$sheet_key, don't share your sheet key!
# Data <- gs_key(sheetkey)


# Define the UI -----


library(shinydashboard)

radio_labels <- c("Yes", "No", "NA")
radio_values <- c(1, 0, 1)

ui <- dashboardPage(
  dashboardHeader(title = "BabyTB Training Certification"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),
      menuItem("Looking While Listening", tabName = "tab2", icon = icon("eye"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              
              h2("Certification Information"),
              
              p("Welcome to the NIH BabyTB training certification page."),
              
              p("More details will be added ")
              
      ),
      
      # Second tab content
      tabItem(tabName = "tab2",
              
              h2("Certification Checklist for Looking While Listening  "),
              h3("Before Beginning"),
              
              fluidRow(
                column(6,
                       textInput("text_lwl_person", h4("Person being certified:"), 
                                 value = "")
                ),
                
                column(6,
                       textInput("text_lwl_site", h4("Site:"), 
                                 value = "")
                ),
                
                column(6,
                       textInput("text_lwl_date", h4("Date:"), 
                                 value = "")
                ),
                
                
                column(6,
                       textInput("text_lwl_certifier", h4("Certifier:"), 
                                 value = "")
                ),
                
                column(6,
                       textInput("text_lwl_childAge", h4("Child Age (in months):"), 
                                 value = "")
                )
                
              ),
              
              h3("Before Beginning"),
              
              fluidRow(
                column(6,
                       radioButtons("radio_lwl_001", p("Child (C), caregiver & examiner (E) are seated correctly"),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
                       ),
                
                column(6,
                       textInput("text_lwl_001", h4("Notes"), 
                                 value = "")
                       )
                ),
              
            fluidRow(
                column(6,
                       radioButtons("radio_lwl_002", p("iPad is set up so that C is in the correct placement for gaze."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)),
                
                column(6,
                       textInput("text_lwl_002", h4("Notes"), 
                                 value = ""))
                
      ),
      
      h3("Testing"),
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_003", p("iPad sound is loud enough for C & E to hear"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        ),
        
        column(6,
               textInput("text_lwl_003", h4("Notes"), 
                         value = "")
        )
      ),
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_004", p("E slides purple button to the right"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        ),
        
        column(6,
               textInput("text_lwl_004", h4("Notes"), 
                         value = "")
        )
      ),
      
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_005", p("E reviews instructional screen & slides purple button to the right"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        ),
        
        column(6,
               textInput("text_lwl_005", h4("Notes"), 
                         value = "")
        )
      ),
      
      
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_006", p("E stands behind the C unless they need to redirect the C’s attention to the iPad without touching the iPad itself or blocking the iPad camera"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        ),
        
        column(6,
               textInput("text_lwl_006", h4("Notes"), 
                         value = "")
        )
      ),
      
      
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_007", p("After calibration, the iPad begins to present items one at a time. E stands behind the C unless they need to redirect C’s attention without touching the iPad or blocking the camera"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        ),
        
        column(6,
               textInput("text_lwl_007", h4("Notes"), 
                         value = "")
        )
      ),
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_008", p("Test continues until all items are presented"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        ),
        
        column(6,
               textInput("text_lwl_008", h4("Notes"), 
                         value = "")
        )
      ),
      
      fluidRow(
        column(1,
               actionButton(inputId = "lwl_submit", label = "Submit", 
                            icon = NULL, width = NULL))
      ),
      
      h2("Your Score"), 
      fluidRow(
        column(12,
               verbatimTextOutput("lwl_score"))
      )
    )
  )
)
)


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  lwl_values <- eventReactive(input$lwl_submit, {

    lwl_data <- data.frame(
      "text_lwl_person" = c(input$text_lwl_person),
      "text_lwl_site" = c(input$text_lwl_site),
      "text_lwl_date" = c(input$text_lwl_date),
      "text_lwl_certifier" = c(input$text_lwl_certifier),
      "text_lwl_childAge" = c(input$text_lwl_childAge),
      "radio_lwl_001" = c(input$radio_lwl_001), 
      "radio_lwl_002" = c(input$radio_lwl_002),
      "radio_lwl_003" = c(input$radio_lwl_003), 
      "radio_lwl_004" = c(input$radio_lwl_004), 
      "radio_lwl_005" = c(input$radio_lwl_005),  
      "radio_lwl_006" = c(input$radio_lwl_006), 
      "radio_lwl_007" = c(input$radio_lwl_007),  
      "value_lwl_001" = as.numeric(c(input$radio_lwl_001)),  
      "value_lwl_002" = as.numeric(c(input$radio_lwl_002)),  
      "value_lwl_003" = as.numeric(c(input$radio_lwl_003)),   
      "value_lwl_004" = as.numeric(c(input$radio_lwl_004)),  
      "value_lwl_005" = as.numeric(c(input$radio_lwl_005)),   
      "value_lwl_006" = as.numeric(c(input$radio_lwl_006)),  
      "value_lwl_007" = as.numeric(c(input$radio_lwl_007)),   
      "value_lwl_008" = as.numeric(c(input$radio_lwl_008)),
      "notes_lwl_001" = as.numeric(c(input$text_lwl_001)),  
      "notes_lwl_002" = as.numeric(c(input$text_lwl_002)),  
      "notes_lwl_003" = as.numeric(c(input$text_lwl_003)),   
      "notes_lwl_004" = as.numeric(c(input$text_lwl_004)),  
      "notes_lwl_005" = as.numeric(c(input$text_lwl_005)),   
      "notes_lwl_006" = as.numeric(c(input$text_lwl_006)),  
      "notes_lwl_007" = as.numeric(c(input$text_lwl_007)),   
      "notes_lwl_008" = as.numeric(c(input$text_lwl_008))
      )
    
    lwl_data$sum <- rowSums(lwl_data %>% select(starts_with("value_")), na.rm = TRUE) * NA^!rowSums(!is.na(lwl_data %>% select(starts_with("value_"))))
    
    percent_correct <- round((lwl_data$sum / 8)*100, 2)
    
    paste0(percent_correct, "%")
  
    })
  
  output$lwl_score <- renderText({
    lwl_values()
  })
  

}

shinyApp(ui, server)