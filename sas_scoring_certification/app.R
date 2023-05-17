# Load packages ----

library(psych)
library(tidyverse)
library(DT)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(googlesheets4)
library(shinydashboard)



# Set up how to write data to Google drive -------

options(
  # whenever there is one account token found, use the cached token
  gargle_oauth_email = TRUE,
  # specify auth tokens should be stored in a hidden directory ".secrets"
  gargle_oauth_cache = "authentication_files/.secrets"
)

sheet_id <- googledrive::drive_get("2023_BBTB_SaS_Cert")$id



# Establish details that will be reused throughout the shiny app-----


#radio_labels <- c("Yes", "No", "NA")
#radio_values <- c(1, 0, NA)
app_values_1or0 <- c(1, 0)
app_values_1_0 <- c(1, 0)
app_values_0_2 <- c(0, 1, 2)
app_values_1_2 <- c(1, 2)
#app_values_0_3 <- c(0, 1, 2, 3)
app_values_1_3 <- c(1, 2, 3)
app_values_0_4 <- c(0, 1, 2, 3, 4)
app_values_1_4 <- c(1, 2, 3, 4)
app_values_1_5 <- c(1, 2, 3, 4, 5)
app_values_0_5 <- c(0, 1, 2, 3, 4, 5)
app_values_1_6 <- c(1, 2, 3, 4, 5, 6)
app_values_1_7 <- c(1, 2, 3, 4, 5, 6, 7)
app_values_0_8 <- c(0, 1, 2, 3, 4, 5, 6, 7, 8)
app_values_1_9 <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
app_values_0_3_neg2 <- c(0, -2, 1, 2, 3)

# Define the UI -----

## Set up the menu / navigation bar -----
ui <- dashboardPage(
  dashboardHeader(title = "NBT SaS Certification"),

  dashboardSidebar(
    width = 300,
    tags$head(
      tags$style("@import url(https://use.fontawesome.com/releases/v5.2.1/css/all.css);")
      ),

    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),


      menuItem("Sit and Stand", tabName = "sas", icon = icon("child-reaching"),
               menuSubItem("Video 5: Sit and Stand", tabName = "tab_sas_v5", icon = icon("child-reaching")),
               menuSubItem("Video 6: Sit and Stand", tabName = "tab_sas_v6", icon = icon("child-reaching")),
               menuSubItem("Video 7: Sit and Stand", tabName = "tab_sas_v7", icon = icon("child-reaching")),
               menuSubItem("Video 8: Sit and Stand", tabName = "tab_sas_v8", icon = icon("child-reaching"))
      )
    )
  ),

## Set up the main page -----

  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",

              h2("Sit and Stand Re-certification Information"),

              p("Welcome to the NIH Infant and Toddler Toolbox (aka the “NIH Baby Toolbox” or “NIH BabyTB”) Sit and Stand re-certification Shiny application!"),

              p("This application is intended to re-certify examiners on the NIH BabyTB Sit and Stand measure."),
              
              p("Please use the menu on the side to enter your scores to the corresponding video.")

      ),


## Sit and Stand page ------


### Video 5: SaS -----
tabItem(tabName = "tab_sas_v5",
        
        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 5"),
        
        fluidRow(
          column(6,
                 textInput("text_sas_v5_person", h4("Your Name (Last, First):"),
                           value = "")
          ),
          
          column(6,
                 # textInput("text_sas_v5_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v5_site", h4("Site:"),
                             c("Appleton, WI" = "Appleton, WI",
                               "Atlanta, GA" = "Atlanta, GA",
                               "Baltimore, MD" = "Baltimore, MD",
                               "Boston, MA" = "Boston, MA",
                               "Chicago, IL" = "Chicago, IL",
                               "Dallas, TX" = "Dallas, TX",
                               "Houston, TX" = "Houston, TX",
                               "Iselin, NJ" = "Iselin, NJ",
                               "Los Angeles, CA" = "Los Angeles, CA",
                               "Minneapolis, MN" = "Minneapolis, MN",
                               "Nashville, TN" = "Nashville, TN",
                               "Orlando, FL" = "Orlando, FL",
                               "Philadelphia, PA" = "Philadelphia, PA",
                               "Phoenix, AZ" = "Phoenix, AZ",
                               "St Louis, MO" = "St Louis, MO",
                               "Seattle, WA" = "Seattle, WA"
                             )) 
                 
          ),
          
          column(6,
                 dateInput("text_sas_v5_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )
        ),
        
        
        h3("Unsupported Stand: Feet Together"),
        
        fluidRow(
          
          column(6,
                 radioButtons("radio_sas_v5_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet together"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),
        
        fluidRow(
          
          column(6,
                 numericInput("radio_sas_v5_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          
          column(6,
                 numericInput("radio_sas_v5_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        h3("Unsupported Stand: Tandem Stand"),
        
        fluidRow(
          
          column(6,
                 radioButtons("radio_sas_v5_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet tandem"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),
        
        fluidRow(
          
          column(6,
                 numericInput("radio_sas_v5_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          
          column(6,
                 numericInput("radio_sas_v5_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v5_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v5_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("sas_v5_incorrect"))
        )
),

### Video 6: SaS -----
tabItem(tabName = "tab_sas_v6",
        
        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 6"),
        
        fluidRow(
          column(6,
                 textInput("text_sas_v6_person", h4("Your Name (Last, First):"),
                           value = "")
          ),
          
          column(6,
                 # textInput("text_sas_v6_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v6_site", h4("Site:"),
                             c("Appleton, WI" = "Appleton, WI",
                               "Atlanta, GA" = "Atlanta, GA",
                               "Baltimore, MD" = "Baltimore, MD",
                               "Boston, MA" = "Boston, MA",
                               "Chicago, IL" = "Chicago, IL",
                               "Dallas, TX" = "Dallas, TX",
                               "Houston, TX" = "Houston, TX",
                               "Iselin, NJ" = "Iselin, NJ",
                               "Los Angeles, CA" = "Los Angeles, CA",
                               "Minneapolis, MN" = "Minneapolis, MN",
                               "Nashville, TN" = "Nashville, TN",
                               "Orlando, FL" = "Orlando, FL",
                               "Philadelphia, PA" = "Philadelphia, PA",
                               "Phoenix, AZ" = "Phoenix, AZ",
                               "St Louis, MO" = "St Louis, MO",
                               "Seattle, WA" = "Seattle, WA"
                             )) 
          ),
          
          column(6,
                 dateInput("text_sas_v6_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )
          
        ),
        
        h3("Pull to Sit"),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_v6_pts_q1", p("Pull to Sit: head in line with torso?"),
                              choiceNames = c("No", "Yes"), choiceValues = app_values_1_2, selected = "")
          )
        ),
        
        
        h3("Unsupported Sit"),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_v6_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c("Non-compliant", "Fell", "Used hands for support",
                                              "Sat without support", "Shifted to prone"), choiceValues = app_values_1_5, selected = "")
          )
        ),
        
        fluidRow(
          
          column(6,
                 numericInput("radio_sas_v6_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                                  "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 numericInput("radio_sas_v6_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                                "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v6_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v6_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("sas_v6_incorrect"))
        )
),


### Video 7: SaS -----
tabItem(tabName = "tab_sas_v7",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 7"),

        fluidRow(
          column(6,
                 textInput("text_sas_v7_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sas_v7_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v7_site", h4("Site:"),
                             c("Appleton, WI" = "Appleton, WI",
                               "Atlanta, GA" = "Atlanta, GA",
                               "Baltimore, MD" = "Baltimore, MD",
                               "Boston, MA" = "Boston, MA",
                               "Chicago, IL" = "Chicago, IL",
                               "Dallas, TX" = "Dallas, TX",
                               "Houston, TX" = "Houston, TX",
                               "Iselin, NJ" = "Iselin, NJ",
                               "Los Angeles, CA" = "Los Angeles, CA",
                               "Minneapolis, MN" = "Minneapolis, MN",
                               "Nashville, TN" = "Nashville, TN",
                               "Orlando, FL" = "Orlando, FL",
                               "Philadelphia, PA" = "Philadelphia, PA",
                               "Phoenix, AZ" = "Phoenix, AZ",
                               "St Louis, MO" = "St Louis, MO",
                               "Seattle, WA" = "Seattle, WA"
                             )) 
          ),

          column(6,
                 dateInput("text_sas_v7_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),

        

        h3("Unsupported Stand: Feet Together"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v7_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet together"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v7_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v7_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        h3("Unsupported Stand: Tandem Stand"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v7_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet tandem"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v7_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v7_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v7_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

fluidRow(
  column(12,
         verbatimTextOutput("sas_v7_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("sas_v7_incorrect"))
)
),

### Video 8: SaS -----
tabItem(tabName = "tab_sas_v8",
        
        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 8"),
        
        fluidRow(
          column(6,
                 textInput("text_sas_v8_person", h4("Your Name (Last, First):"),
                           value = "")
          ),
          
          column(6,
                 # textInput("text_sas_v8_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v8_site", h4("Site:"),
                             c("Appleton, WI" = "Appleton, WI",
                               "Atlanta, GA" = "Atlanta, GA",
                               "Baltimore, MD" = "Baltimore, MD",
                               "Boston, MA" = "Boston, MA",
                               "Chicago, IL" = "Chicago, IL",
                               "Dallas, TX" = "Dallas, TX",
                               "Houston, TX" = "Houston, TX",
                               "Iselin, NJ" = "Iselin, NJ",
                               "Los Angeles, CA" = "Los Angeles, CA",
                               "Minneapolis, MN" = "Minneapolis, MN",
                               "Nashville, TN" = "Nashville, TN",
                               "Orlando, FL" = "Orlando, FL",
                               "Philadelphia, PA" = "Philadelphia, PA",
                               "Phoenix, AZ" = "Phoenix, AZ",
                               "St Louis, MO" = "St Louis, MO",
                               "Seattle, WA" = "Seattle, WA"
                             )) 
          ),
          
          column(6,
                 dateInput("text_sas_v8_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )
          
        ),
        
        h3("Unsupported Sit"),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_v8_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c("Non-compliant", "Fell", "Used hands for support",
                                              "Sat without support", "Shifted to prone"), choiceValues = app_values_1_5, selected = "")
          )
        ),
        
        fluidRow(
          
          column(6,
                 numericInput("radio_sas_v8_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                                  "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 numericInput("radio_sas_v8_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                                "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v8_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v8_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("sas_v8_incorrect"))
        )
)



## Close to Survey -----
)))


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output, session) {


## Sit and Stand data ------
  
  ### Video 5 ------
  
  sas_v5_values <- eventReactive(input$sas_v5_submit, {
    
    validate(
      need(input$text_sas_v5_person, "Please enter your name."),
      need(input$text_sas_v5_site, "Please select your site."),
      
      need(input$radio_sas_v5_std_q1, "Please select an answer for Feet Together Stand: Unsupported for 30 seconds?"),
      need(input$radio_sas_v5_std_q2_starttime, "Please select an answer for Feet Together Stand Find Timing: When did the child start standing?"),
      need(input$radio_sas_v5_std_q2_endtime, "Please select an answer for Feet Together Stand Find Timing: When did the child stop standing?"),
      
      need(input$radio_sas_v5_std_q3, "Please select an answer for Tandem Stand: Unsupported for 30 seconds?"),
      need(input$radio_sas_v5_std_q4_starttime, "Please select an answer for Tandem Stand Find Timing: When did the child start standing?"),
      need(input$radio_sas_v5_std_q4_endtime, "Please select an answer for Tandem Stand Find Timing: When did the child stop standing?")
    )
    
    sas_v5_data <- data.frame(
      task_id = c("sas_v5"),
      text_sas_v5_person = c(input$text_sas_v5_person),
      text_sas_v5_site = c(input$text_sas_v5_site),
      text_sas_v5_date = Sys.time(),#format(as.Date(input$text_sas_v5_date, origin="2023-01-01")),
      
      sas_v5_std_q1 = c(input$radio_sas_v5_std_q1),
      sas_v5_std_q2_start = as.numeric(c(input$radio_sas_v5_std_q2_starttime)),
      sas_v5_std_q2_end = as.numeric(c(input$radio_sas_v5_std_q2_endtime)),
      
      sas_v5_std_q3 = c(input$radio_sas_v5_std_q3),
      sas_v5_std_q4_start = as.numeric(c(input$radio_sas_v5_std_q4_starttime)),
      sas_v5_std_q4_end = as.numeric(c(input$radio_sas_v5_std_q4_endtime))
    ) %>%
      mutate(
        sas_v5_std_q1 = as.numeric(sas_v5_std_q1),
        sas_v5_std_q3 = as.numeric(sas_v5_std_q3)
      )
    
    sas_key_df <- data.frame(
      K_StD_Q1 = c(5),
      K_StD_Q2_St = c(.22),
      K_StD_Q2_End = c(.50),
      K_StD_Q3 = c(4),
      K_StD_Q4_St = c(1.45),
      K_StD_Q4_End = c(1.45)
    )
    
    sas_v5_combined <- cbind(sas_v5_data, sas_key_df) %>% 
      mutate(Score_sas_v5_std_q1 = ifelse(sas_v5_std_q1 == K_StD_Q1, 
                                          1, 0),
             Score_sas_v5_std_q2_start = ifelse(between(sas_v5_std_q2_start, K_StD_Q2_St - 0.01, K_StD_Q2_St + 0.01), 1, 
                                                ifelse(sas_v5_std_q2_start == K_StD_Q2_St - 0.02, 0.5,
                                                       ifelse(sas_v5_std_q2_start == K_StD_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v5_std_q2_end = ifelse(between(sas_v5_std_q2_end, K_StD_Q2_End - 0.01, K_StD_Q2_End + 0.01), 1, 
                                              ifelse(sas_v5_std_q2_end == K_StD_Q2_End - 0.02, 0.5,
                                                     ifelse(sas_v5_std_q2_end == K_StD_Q2_End + 0.02, 0.5, 0))),
             
             Score_sas_v5_std_q3 = ifelse(sas_v5_std_q3 == K_StD_Q3, 
                                          1, 0),
             Score_sas_v5_std_q4_start = ifelse(between(sas_v5_std_q4_start, K_StD_Q4_St - 0.01, K_StD_Q4_St + 0.01), 1, 
                                                ifelse(sas_v5_std_q4_start == K_StD_Q4_St - 0.02, 0.5,
                                                       ifelse(sas_v5_std_q4_start == K_StD_Q4_St + 0.02, 0.5, 0))),
             Score_sas_v5_std_q4_end = ifelse(between(sas_v5_std_q4_end, K_StD_Q4_End - 0.01, K_StD_Q4_End + 0.01), 1, 
                                              ifelse(sas_v5_std_q4_end == K_StD_Q4_End - 0.02, 0.5,
                                                     ifelse(sas_v5_std_q4_end == K_StD_Q4_End + 0.02, 0.5, 0))),
             
             Score_sas_v5 = sum(Score_sas_v5_std_q1, Score_sas_v5_std_q2_start, Score_sas_v5_std_q2_end,
                                Score_sas_v5_std_q3, Score_sas_v5_std_q4_start, Score_sas_v5_std_q4_end),
             Score_sas_v5 = round(Score_sas_v5 / 6 , 3)
      ) 
    
    sas_v5_upload <- sas_v5_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6), "Overall")
      ) %>% 
      rename(name = text_sas_v5_person,
             site = text_sas_v5_site,
             date = text_sas_v5_date) %>% 
      filter(key != "Answer") 
    
    sas_v5_upload <- as.data.frame(sas_v5_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v5_upload,
                 sheet = "main")
    
    return(sas_v5_combined)
    
  })
  
  output$sas_v5_incorrect <- renderTable({
    sas_v5_data <- sas_v5_values()
    
    return_sas_v5 <- sas_v5_data %>% 
      mutate(sas_v5_std_q1 = factor(sas_v5_std_q1, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet together")),
             K_StD_Q1 = factor(K_StD_Q1, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet together")),
             sas_v5_std_q3 = factor(sas_v5_std_q3, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet tandem")),
             K_StD_Q3 = factor(K_StD_Q3, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet tandem"))
      ) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v5)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Feet Together Stand: Unsupported for 30 seconds?", 
                         "Feet Together Stand Find Timing: When did the child start standing?", 
                         "Feet Together Stand Find Timing: When did the child stop standing?", 
                         "Tandem Stand: Unsupported for 30 seconds?", 
                         "Tandem Stand Find Timing: When did the child start standing?", 
                         "Tandem Stand Find Timing: When did the child stop standing?"), 3)),
             type = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6))
      ) %>% 
      select(-c(task_id:text_sas_v5_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v5) 
  })
  
  output$sas_v5_score <- renderText({
    
    sas_v5_data <- sas_v5_values()
    
    percent_correct <- sas_v5_data$Score_sas_v5 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  ### Video 6 ------
  
  sas_v6_values <- eventReactive(input$sas_v6_submit, {
    
    validate(
      need(input$text_sas_v6_person, "Please enter your name."),
      need(input$text_sas_v6_site, "Please select your site."),
      
      need(input$radio_sas_v6_pts_q1, "Please select an answer for Pull to Sit: head in line with torso?"),
      need(input$radio_sas_v6_usit_q1, "Please select an answer for Unsupported Sit: Did child sit for 30 seconds?"),
      need(input$radio_sas_v6_usit_q2_starttime, "Please select an answer for Find Longest Segment: When did the child start sitting?"),
      need(input$radio_sas_v6_usit_q2_endtime, "Please select an answer for Find Longest Segment: When did the child stop sitting?")
    )
    
    sas_v6_data <- data.frame(
      task_id = c("sas_v6"),
      text_sas_v6_person = c(input$text_sas_v6_person),
      text_sas_v6_site = c(input$text_sas_v6_site),
      text_sas_v6_date = Sys.time(),#format(as.Date(input$text_sas_v6_date, origin="2023-01-01")),
      
      sas_v6_pts_q1 = c(input$radio_sas_v6_pts_q1),
      sas_v6_usit_q1 = c(input$radio_sas_v6_usit_q1),
      sas_v6_usit_q2_start = as.numeric(c(input$radio_sas_v6_usit_q2_starttime)),
      sas_v6_usit_q2_end = as.numeric(c(input$radio_sas_v6_usit_q2_endtime))
    ) %>%
      mutate(
        sas_v6_pts_q1 = as.numeric(sas_v6_pts_q1),
        sas_v6_usit_q1 = as.numeric(sas_v6_usit_q1)
      )
    
    sas_key_df <- data.frame(
      K_PtS_Q1 = c(2),
      K_Usit_Q1 = c(2),
      K_Usit_Q2_St = c(.48),
      K_Usit_Q2_End = c(1.12)
    )
    
    sas_v6_combined <- cbind(sas_v6_data, sas_key_df) %>% 
      mutate(Score_sas_v6_pts_q1 = ifelse(sas_v6_pts_q1 == K_PtS_Q1, 
                                          1, 0),
             Score_sas_v6_usit_q1 = ifelse(sas_v6_usit_q1 == K_Usit_Q1, 
                                           1, 0),
             Score_sas_v6_usit_q2_start = ifelse(between(sas_v6_usit_q2_start, K_Usit_Q2_St - 0.01, K_Usit_Q2_St + 0.01), 1, 
                                                 ifelse(sas_v6_usit_q2_start == K_Usit_Q2_St - 0.02, 0.5,
                                                        ifelse(sas_v6_usit_q2_start == K_Usit_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v6_usit_q2_end = ifelse(between(sas_v6_usit_q2_end, K_Usit_Q2_End - 0.01, K_Usit_Q2_End + 0.01), 1, 
                                               ifelse(sas_v6_usit_q2_end == K_Usit_Q2_End - 0.02, 0.5,
                                                      ifelse(sas_v6_usit_q2_end == K_Usit_Q2_End + 0.02, 0.5, 0))),
             Score_sas_v6 = sum(Score_sas_v6_pts_q1, Score_sas_v6_usit_q1, Score_sas_v6_usit_q2_start, Score_sas_v6_usit_q2_end),
             Score_sas_v6 = round(Score_sas_v6 / 4, 3)
      ) 
    
    sas_v6_upload <- sas_v6_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 4), rep("Answer", 4), rep("Score", 4), "Overall")
      ) %>% 
      rename(name = text_sas_v6_person,
             site = text_sas_v6_site,
             date = text_sas_v6_date) %>% 
      filter(key != "Answer") 
    
    sas_v6_upload <- as.data.frame(sas_v6_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v6_upload,
                 sheet = "main")
    
    return(sas_v6_combined)
    
  })
  
  output$sas_v6_incorrect <- renderTable({
    sas_v6_data <- sas_v6_values()
    
    return_sas_v6 <- sas_v6_data %>% 
      mutate(sas_v6_pts_q1 = factor(sas_v6_pts_q1, app_values_1_2,
                                    c("No", "Yes")),
             sas_v6_usit_q1 = factor(sas_v6_usit_q1, app_values_1_5,
                                     c("Non-compliant", "Fell", "Used hands for support",
                                       "Sat without support", "Shifted to prone")),
             K_Usit_Q1 = factor(K_Usit_Q1, app_values_1_5,
                                c("Non-compliant", "Fell", "Used hands for support",
                                  "Sat without support", "Shifted to prone"))) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v6)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Pull to Sit: head in line with torso?", 
                         "Unsupported Sit: Did child sit for 30 seconds?", 
                         "Find Longest Segment: When did the child start sitting?", 
                         "Find Longest Segment: When did the child stop sitting?"), 3)),
             type = c(rep("Response", 4), rep("Answer", 4), rep("Score", 4))
      ) %>% 
      select(-c(task_id:text_sas_v6_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v6) 
  })
  
  output$sas_v6_score <- renderText({
    
    sas_v6_data <- sas_v6_values()
    
    percent_correct <- sas_v6_data$Score_sas_v6 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  

  
  ### Video 7 ------
  sas_v7_values <- eventReactive(input$sas_v7_submit, {
    
    validate(
      need(input$text_sas_v7_person, "Please enter your name."),
      need(input$text_sas_v7_site, "Please select your site."),
      
      need(input$radio_sas_v7_std_q1, "Please select an answer for Feet Together Stand: Unsupported for 30 seconds?"),
      need(input$radio_sas_v7_std_q2_starttime, "Please select an answer for Feet Together Stand Find Timing: When did the child start standing?"),
      need(input$radio_sas_v7_std_q2_endtime, "Please select an answer for Feet Together Stand Find Timing: When did the child stop standing?"),
      
      need(input$radio_sas_v7_std_q3, "Please select an answer for Tandem Stand: Unsupported for 30 seconds?"),
      need(input$radio_sas_v7_std_q4_starttime, "Please select an answer for Tandem Stand Find Timing: When did the child start standing?"),
      need(input$radio_sas_v7_std_q4_endtime, "Please select an answer for Tandem Stand Find Timing: When did the child stop standing?")
    )
    
    sas_v7_data <- data.frame(
      task_id = c("sas_v7"),
      text_sas_v7_person = c(input$text_sas_v7_person),
      text_sas_v7_site = c(input$text_sas_v7_site),
      text_sas_v7_date = Sys.time(),#format(as.Date(input$text_sas_v7_date, origin="2023-01-01")),
      
      sas_v7_std_q1 = c(input$radio_sas_v7_std_q1),
      sas_v7_std_q2_start = as.numeric(c(input$radio_sas_v7_std_q2_starttime)),
      sas_v7_std_q2_end = as.numeric(c(input$radio_sas_v7_std_q2_endtime)),
      
      sas_v7_std_q3 = c(input$radio_sas_v7_std_q3),
      sas_v7_std_q4_start = as.numeric(c(input$radio_sas_v7_std_q4_starttime)),
      sas_v7_std_q4_end = as.numeric(c(input$radio_sas_v7_std_q4_endtime))
    ) %>%
      mutate(
        sas_v7_std_q1 = as.numeric(sas_v7_std_q1),
        sas_v7_std_q3 = as.numeric(sas_v7_std_q3)
      )
    
    sas_key_df <- data.frame(
      K_StD_Q1 = c(5),
      K_StD_Q2_St = c(1.08),
      K_StD_Q2_End = c(1.40),
      K_StD_Q3 = c(2),
      K_StD_Q4_St = c(2.36), 
      K_StD_Q4_End = c(2.43)
    )
    
    sas_v7_combined <- cbind(sas_v7_data, sas_key_df) %>% 
      mutate(Score_sas_v7_std_q1 = ifelse(sas_v7_std_q1 == K_StD_Q1, 
                                          1, 0),
             Score_sas_v7_std_q2_start = ifelse(between(sas_v7_std_q2_start, K_StD_Q2_St - 0.01, K_StD_Q2_St + 0.01), 1, 
                                                ifelse(sas_v7_std_q2_start == K_StD_Q2_St - 0.02, 0.5,
                                                       ifelse(sas_v7_std_q2_start == K_StD_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v7_std_q2_end = ifelse(between(sas_v7_std_q2_end, K_StD_Q2_End - 0.01, K_StD_Q2_End + 0.01), 1, 
                                              ifelse(sas_v7_std_q2_end == K_StD_Q2_End - 0.02, 0.5,
                                                     ifelse(sas_v7_std_q2_end == K_StD_Q2_End + 0.02, 0.5, 0))),
             
             Score_sas_v7_std_q3 = ifelse(sas_v7_std_q3 == K_StD_Q3, 
                                          1, 0),
             Score_sas_v7_std_q4_start = ifelse(between(sas_v7_std_q4_start, K_StD_Q4_St - 0.01, K_StD_Q4_St + 0.01), 1, 
                                                ifelse(sas_v7_std_q4_start == K_StD_Q4_St - 0.02, 0.5,
                                                       ifelse(sas_v7_std_q4_start == K_StD_Q4_St + 0.02, 0.5, 0))),
             Score_sas_v7_std_q4_end = ifelse(between(sas_v7_std_q4_end, K_StD_Q4_End - 0.01, K_StD_Q4_End + 0.01), 1, 
                                              ifelse(sas_v7_std_q4_end == K_StD_Q4_End - 0.02, 0.5,
                                                     ifelse(sas_v7_std_q4_end == K_StD_Q4_End + 0.02, 0.5, 0))),
             
             Score_sas_v7 = sum(Score_sas_v7_std_q1, Score_sas_v7_std_q2_start, Score_sas_v7_std_q2_end,
                                Score_sas_v7_std_q3, Score_sas_v7_std_q4_start, Score_sas_v7_std_q4_end),
             Score_sas_v7 = round(Score_sas_v7 / 6 , 3)
      ) 
    
    sas_v7_upload <- sas_v7_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6), "Overall")
      ) %>% 
      rename(name = text_sas_v7_person,
             site = text_sas_v7_site,
             date = text_sas_v7_date) %>% 
      filter(key != "Answer") 
    
    sas_v7_upload <- as.data.frame(sas_v7_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v7_upload,
                 sheet = "main")
    
    return(sas_v7_combined)
    
  })
  
  output$sas_v7_incorrect <- renderTable({
    sas_v7_data <- sas_v7_values()
    
    return_sas_v7 <- sas_v7_data %>% 
      mutate(sas_v7_std_q1 = factor(sas_v7_std_q1, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet together")),
             K_StD_Q1 = factor(K_StD_Q1, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet together")),
             sas_v7_std_q3 = factor(sas_v7_std_q3, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet tandem")),
             K_StD_Q3 = factor(K_StD_Q3, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet tandem"))
      ) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v7)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Feet Together Stand: Unsupported for 30 seconds?", 
                         "Feet Together Stand Find Timing: When did the child start standing?", 
                         "Feet Together Stand Find Timing: When did the child stop standing?", 
                         "Tandem Stand: Unsupported for 30 seconds?", 
                         "Tandem Stand Find Timing: When did the child start standing?", 
                         "Tandem Stand Find Timing: When did the child stop standing?"), 3)),
             type = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6))
      ) %>% 
      select(-c(task_id:text_sas_v7_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v7) 
  })
  
  output$sas_v7_score <- renderText({
    
    sas_v7_data <- sas_v7_values()
    
    percent_correct <- sas_v7_data$Score_sas_v7 * 100
    
    return(paste0(percent_correct, "%"))
  })

  ### Video 8 ------
  sas_v8_values <- eventReactive(input$sas_v8_submit, {
    
    validate(
      need(input$text_sas_v8_person, "Please enter your name."),
      need(input$text_sas_v8_site, "Please select your site."),
      
      need(input$radio_sas_v8_usit_q1, "Please select an answer for Unsupported Sit: Did child sit for 30 seconds?"),
      need(input$radio_sas_v8_usit_q2_starttime, "Please select an answer for Find Longest Segment: When did the child start sitting?"),
      need(input$radio_sas_v8_usit_q2_endtime, "Please select an answer for Find Longest Segment: When did the child stop sitting?")
    )
    
    sas_v8_data <- data.frame(
      task_id = c("sas_v8"),
      text_sas_v8_person = c(input$text_sas_v8_person),
      text_sas_v8_site = c(input$text_sas_v8_site),
      text_sas_v8_date = Sys.time(),#format(as.Date(input$text_sas_v8_date, origin="2023-01-01")),
      
      sas_v8_usit_q1 = c(input$radio_sas_v8_usit_q1),
      sas_v8_usit_q2_start = as.numeric(c(input$radio_sas_v8_usit_q2_starttime)),
      sas_v8_usit_q2_end = as.numeric(c(input$radio_sas_v8_usit_q2_endtime))
    ) %>%
      mutate(
        sas_v8_usit_q1 = as.numeric(sas_v8_usit_q1)
      )
    
    sas_key_df <- data.frame(
      K_Usit_Q1 = c(5),
      K_Usit_Q2_St = c(.09),
      K_Usit_Q2_End = c(.23)
    )
    
    sas_v8_combined <- cbind(sas_v8_data, sas_key_df) %>% 
      mutate(Score_sas_v8_usit_q1 = ifelse(sas_v8_usit_q1 == K_Usit_Q1, 
                                           1, 0),
             Score_sas_v8_usit_q2_start = ifelse(between(sas_v8_usit_q2_start, K_Usit_Q2_St - 0.01, K_Usit_Q2_St + 0.01), 1, 
                                                 ifelse(sas_v8_usit_q2_start == K_Usit_Q2_St - 0.02, 0.5,
                                                        ifelse(sas_v8_usit_q2_start == K_Usit_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v8_usit_q2_end = ifelse(between(sas_v8_usit_q2_end, K_Usit_Q2_End - 0.01, K_Usit_Q2_End + 0.01), 1, 
                                               ifelse(sas_v8_usit_q2_end == K_Usit_Q2_End - 0.02, 0.5,
                                                      ifelse(sas_v8_usit_q2_end == K_Usit_Q2_End + 0.02, 0.5, 0))),
             Score_sas_v8 = sum(Score_sas_v8_usit_q1, Score_sas_v8_usit_q2_start, Score_sas_v8_usit_q2_end),
             Score_sas_v8 = round(Score_sas_v8 / 3, 3)
      ) 
    
    sas_v8_upload <- sas_v8_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 3), rep("Answer", 3), rep("Score", 3), "Overall")
      ) %>% 
      rename(name = text_sas_v8_person,
             site = text_sas_v8_site,
             date = text_sas_v8_date) %>% 
      filter(key != "Answer") 
    
    sas_v8_upload <- as.data.frame(sas_v8_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v8_upload,
                 sheet = "main")
    
    return(sas_v8_combined)
    
  })
  
  output$sas_v8_incorrect <- renderTable({
    sas_v8_data <- sas_v8_values()
    
    return_sas_v8 <- sas_v8_data %>% 
      mutate(sas_v8_usit_q1 = factor(sas_v8_usit_q1, app_values_1_5,
                                     c("Non-compliant", "Fell", "Used hands for support",
                                       "Sat without support", "Shifted to prone")),
             K_Usit_Q1 = factor(K_Usit_Q1, app_values_1_5,
                                c("Non-compliant", "Fell", "Used hands for support",
                                  "Sat without support", "Shifted to prone"))) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v8)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Unsupported Sit: Did child sit for 30 seconds?", 
                         "Find Longest Segment: When did the child start sitting?",
                         "Find Longest Segment: When did the child stop sitting?"), 3)),
             type = c(rep("Response", 3), rep("Answer", 3), rep("Score", 3))
      ) %>% 
      select(-c(task_id:text_sas_v8_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v8) 
  })
  
  output$sas_v8_score <- renderText({
    
    sas_v8_data <- sas_v8_values()
    
    percent_correct <- sas_v8_data$Score_sas_v8 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  

### Close the analysis ----
}

shinyApp(ui, server)


# server <- function(input, output) {
#   #data <- read_sheet(ss = key_id, sheet = "Sheet1")
# 
#   output$table <- renderText({
#     22
#   })
# }
# 
# ui <- fluidPage(sidebarLayout(sidebarPanel("Test"),
#                               mainPanel(textOutput('table'))
# )
# )
# 
# shinyApp(ui = ui, server = server)
# 
