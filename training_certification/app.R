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
    width = 300,
    tags$head(
      tags$style("@import url(https://use.fontawesome.com/releases/v6.2.1/css/all.css);")
      ),
    
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),
      menuItem("Gaze", tabName = "tab2", icon = icon("eye")),
      menuItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
      menuItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment")),
      menuItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
      menuItem("Mullen Receptive Language", tabName = "tab6", icon = icon("comment")),
      menuItem("Picture Vocab", tabName = "tab7", icon = icon("comment")),
      menuItem("Social Observational (younger)", tabName = "tab8", icon = icon("cubes-stacked")),
      menuItem("Social Observational (older)", tabName = "tab9", icon = icon("cubes-stacked")),
      menuItem("Who Has More", tabName = "tab10", icon = icon("arrow-up-9-1")),
      menuItem("Subitizing", tabName = "tab11", icon = icon("arrow-up-9-1")),
      menuItem("Object Counting", tabName = "tab12", icon = icon("arrow-up-9-1")),
      menuItem("Verbal Arithmetic", tabName = "tab13", icon = icon("arrow-up-9-1")),
      menuItem("Verbal Counting", tabName = "tab14", icon = icon("arrow-up-9-1")),
      menuItem("Get Up and Go", tabName = "tab15", icon = icon("person-running")),
      menuItem("Reach to Eat", tabName = "tab16", icon = icon("cookie-bite")),
      menuItem("Sit and Stand", tabName = "tab17", icon = icon("child-reaching")),
      menuItem("Mullen Visual Reception", tabName = "tab18", icon = icon("eye")),
      menuItem("EF Learning & Memory", tabName = "tab19", icon = icon("brain"))
      
      
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
      tabItem(tabName = "tab_lwl",
              
              h2("Certification Checklist for Looking While Listening  "),
              h3("Certification Details"),
              
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
                       dateInput("date",
                                 label = "Date (yyyy-mm-dd)",
                                 value = Sys.Date()
                       )
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
                       )
                ),
              
              
            fluidRow(
                column(6,
                       radioButtons("radio_lwl_002", p("iPad is set up so that C is in the correct placement for gaze."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
                       )
                ),
            
                fluidRow(
                  column(6,
                         textInput("text_lwl_001", h4("Notes about setup"), 
                                   value = ""))
      ),
      
      h3("Testing"),
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_003", p("iPad sound is loud enough for C & E to hear"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        )
      ),
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_004", p("E slides purple button to the right"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        )
      ),
      
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_005", p("E reviews instructional screen & slides purple button to the right"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        )
      ),
      
      
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_006", p("E stands behind the C unless they need to redirect the C’s attention to the iPad without touching the iPad itself or blocking the iPad camera"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        )
      ),
      
      
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_007", p("After calibration, the iPad begins to present items one at a time. E stands behind the C unless they need to redirect C’s attention without touching the iPad or blocking the camera"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        )
      ),
      
      fluidRow(
        column(6,
               radioButtons("radio_lwl_008", p("Test continues until all items are presented"),
                            choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
        )
        ),
        
      fluidRow(
        column(6,
               textInput("text_lwl_002", h4("Notes about testing"), 
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
    ),
    
    tabItem(tabName = "tab_melp",
            
            h2("Mullen Expressive Language Prompted"),
            h3("Certification Details"),
            
            fluidRow(
              column(6,
                     textInput("text_melp_person", h4("Person being certified:"), 
                               value = "")
              ),
              
              column(6,
                     textInput("text_melp_site", h4("Site:"), 
                               value = "")
              ),
              
              column(6,
                     dateInput("date",
                               label = "Date (yyyy-mm-dd)",
                               value = Sys.Date()
                     )
              ),
              
              
              column(6,
                     textInput("text_melp_certifier", h4("Certifier:"), 
                               value = "")
              ),
              
              column(6,
                     textInput("text_melp_childAge", h4("Child Age (in months):"), 
                               value = "")
              )
              
            ),
            
            h3("Upload Examiner File"),
            
            fluidRow(
              column(6,
                     fileInput("melp_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                        multiple = FALSE,
                        accept = c("text/csv",
                                   "text/comma-separated-values,text/plain",
                                   ".csv"))
                     ),
            ),
            
            h3("Before Beginning"),
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_001", p("iPad is set up correctly"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              column(6,
                     textInput("text_melp_001", h4("Notes"), 
                               value = "")
              )
            ),
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)),
              
              column(6,
                     textInput("text_melp_002", h4("Notes"), 
                               value = ""))
              
            ),
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              column(6,
                     textInput("text_melp_003", h4("Notes"), 
                               value = "")
              )
            ),
            
            h3("Testing"),
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_004", p("E slides purple button to the right to begin"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              column(6,
                     textInput("text_melp_004", h4("Notes"), 
                               value = "")
              )
            ),
            
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_005", p("E reviews instructions & slides purple button to right"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              column(6,
                     textInput("text_melp_005", h4("Notes"), 
                               value = "")
              )
            ),
            
            
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_006", p("Age 1-23 months: EL7: Voluntary Babbling: Attracts C’s attention with repeated sounds"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              # column(6,
              #        textInput("text_melp_006", h4("Notes"), 
              #                  value = "")
              # ),
              column(6,
                     radioButtons("radio_melp_106", p("EL7: Voluntary Babbling"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              )
            ),
            
            
            
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_007", p("Age 1-23 months: EL10: Plays Gestures / Language Game; asks caregiver which gesture/language game C enjoys (pat-a-cake, peek-a-boo)"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              column(6,
                     textInput("text_melp_007", h4("Notes"), 
                               value = "")
              )
            ),
            
            fluidRow(
              column(6,
                     radioButtons("radio_melp_008", p("E plays game with C; observes C’s enjoyment"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              ),
              
              column(6,
                     radioButtons("radio_melp_107", p("EL10: Plays Gestures/Language Game"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = 3)
              )
            ),

            
            fluidRow(
              column(1,
                     actionButton(inputId = "melp_submit", label = "Submit", 
                                  icon = NULL, width = NULL))
            ),
            
            h2("Your Score"), 
            fluidRow(
              column(12,
                     verbatimTextOutput("melp_score")),
            ),
            
            h4("This will be removed, but it's here to show that the data upload worked"),
            fluidRow(
              column(12,
                     tableOutput("melp_examiner_data"))
            )
    )
  )
)
)


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
  output$melp_examiner_data <- renderTable({
    
    # input$melp_examiner_file will be NULL initially. After the user selects
    # and uploads a file,
    # or all rows if selected, will be shown.
    
    req(input$melp_examiner_file)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        melp_exam_df <- read.csv(input$melp_examiner_file$datapath) %>% 
          select(Key, ItemID, Value) %>% 
          filter(Key == "Score") %>% 
          filter(ItemID %in% c("EL7", "EL10", "EL11", "EL15", "EL16")) %>% 
          pivot_wider(names_from = ItemID, 
                      values_from = Value) %>% 
          rename("exam_EL7" = "EL7", 
                 "exam_EL10" = "EL10", 
                 "exam_EL11" = "EL11", 
                 "exam_EL15" = "EL15", 
                 "exam_EL16" = "EL16") ## Need to confirm what shows up if the test is NA
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    })

  
  
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
      "radio_lwl_008" = c(input$radio_lwl_008),
      "value_lwl_001" = as.numeric(c(input$radio_lwl_001)),  
      "value_lwl_002" = as.numeric(c(input$radio_lwl_002)),  
      "value_lwl_003" = as.numeric(c(input$radio_lwl_003)),   
      "value_lwl_004" = as.numeric(c(input$radio_lwl_004)),  
      "value_lwl_005" = as.numeric(c(input$radio_lwl_005)),   
      "value_lwl_006" = as.numeric(c(input$radio_lwl_006)),  
      "value_lwl_007" = as.numeric(c(input$radio_lwl_007)),   
      "value_lwl_008" = as.numeric(c(input$radio_lwl_008)),
      "notes_lwl_001" = as.numeric(c(input$text_lwl_001)),  
      "notes_lwl_002" = as.numeric(c(input$text_lwl_002))
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