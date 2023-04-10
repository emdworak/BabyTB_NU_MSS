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

sheet_id <- googledrive::drive_get("2023_BBTB_Cert")$id
key_id <- googledrive::drive_get("scoring_key")$id



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
  dashboardHeader(title = "NBT Training Scoring Certification"),

  dashboardSidebar(
    width = 300,
    tags$head(
      tags$style("@import url(https://use.fontawesome.com/releases/v6.2.1/css/all.css);")
      ),

    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),

      menuItem("Social Observational (younger)", tabName = "som_younger", icon = icon("cubes-stacked"),
               menuSubItem("Video 1: Social Observational (younger)", tabName = "tab_somY_v1", icon = icon("cubes-stacked")),
               menuSubItem("Video 2: Social Observational (younger)", tabName = "tab_somY_v2", icon = icon("cubes-stacked"))
               ),

      menuItem("Social Observational (older)", tabName = "som_older", icon = icon("cubes-stacked"),
               menuSubItem("Video 1: Social Observational (older)", tabName = "tab_somO_v1", icon = icon("cubes-stacked")),
               menuSubItem("Video 2: Social Observational (older)", tabName = "tab_somO_v2", icon = icon("cubes-stacked"))
      ),

      menuItem("Get Up and Go", tabName = "gug", icon = icon("person-running"),
               menuSubItem("Video 1: Get Up and Go", tabName = "tab_gug_v1", icon = icon("person-running")),
               menuSubItem("Video 2: Get Up and Go", tabName = "tab_gug_v2", icon = icon("person-running"))
      ),

      menuItem("Reach to Eat", tabName = "rte", icon = icon("cookie-bite"),
               menuSubItem("Video 1: Reach to Eat", tabName = "tab_rte_v1", icon = icon("cookie-bite")),
               menuSubItem("Video 2: Reach to Eat", tabName = "tab_rte_v2", icon = icon("cookie-bite"))
      ),

      menuItem("Sit and Stand", tabName = "sas", icon = icon("child-reaching"),
               menuSubItem("Video 1: Sit and Stand", tabName = "tab_sas_v1", icon = icon("child-reaching")),
               menuSubItem("Video 2: Sit and Stand", tabName = "tab_sas_v2", icon = icon("child-reaching")),
               menuSubItem("Video 3: Sit and Stand", tabName = "tab_sas_v3", icon = icon("child-reaching")),
               menuSubItem("Video 4: Sit and Stand", tabName = "tab_sas_v4", icon = icon("child-reaching"))
      )
    )
  ),

## Set up the main page -----

  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",

              h2("Certification Information"),

              p("Welcome to the NIH Infant and Toddler Toolbox (aka the “NIH Baby Toolbox” or “NIH BabyTB”) training certification Shiny application!"),

              p("This application is intended to certify examiners undergoing training in the administration of the NIH BabyTB."),
              
              p("Please use the menu on the side to enter your scores to the corresponding video.")

      ),


## Social Observational (younger) page ------

### Video 1: SOM (younger) -----
tabItem(tabName = "tab_somY_v1",

        h2("Certification Checklist for Social Observational (ages 9-23 months)"),

        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_sobY_v1_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sobY_v1_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sobY_v1_site", h4("Site:"),
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
                 dateInput("text_sobY_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),


        h3("Communicative Temptation 1: Minute One"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_1", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_2", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_3", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_4", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_5", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_6", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_7", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Response to Name & Gaze/Point 1: Minute Two"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_9", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_10", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_11", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_12", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_13", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_14", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_15", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_16", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_17", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


          h3("Communication Temptation 2: Minute Three"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_19", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_20", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_21", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_22", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_23", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_24", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_25", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        h3("Communicative Temptation 3, probe 2: Minute Four"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_27", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_28", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_29", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_30", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_31", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_32", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_33", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_34", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_35", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Sharing Books 1: Minute Five"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_37", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_38", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_39", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_40", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_41", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),
          
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_42", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
          ),
        
        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_43", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Sharing Books 2: Minute Six"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_45", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_46", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_47", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_48", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_49", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_50", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_51", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 1: Minute Seven"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_53", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_54", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_56", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_57", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Parent/Caregiver-Child Play 2: Minute Eight"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_66", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_67", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
         column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_69", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_70", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 3: Minute Nine"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_79", p("Explores features of object"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_80", p("Uses item functionally"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_82", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                   radioButtons("radio_sobY_v1_SO_9_23_83", p("2 Pretend action sequences."),
                                choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
            )
            ),



        h3("Parent/Caregiver-Child Play 4: Minute Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_92", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_93", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_95", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_96", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobY_v1_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
fluidRow(
  column(12,
         verbatimTextOutput("sobY_v1_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("sobY_v1_incorrect"))
)
),


### Video 2: SOM (younger) -----
tabItem(tabName = "tab_somY_v2",

        h2("Certification Checklist for Social Observational (ages 9-23 months)"),

        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_sobY_v2_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sobY_v2_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sobY_v2_site", h4("Site:"),
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
                 dateInput("text_sobY_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),


        h3("Communicative Temptation 1: Minute One"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_1", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_2", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_3", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_4", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_5", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_6", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_7", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Response to Name & Gaze/Point 1: Minute Two"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_9", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_10", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_11", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_12", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_13", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_14", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_15", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_16", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_17", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Communication Temptation 2: Minute Three"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_19", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_20", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_21", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_22", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_23", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_24", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_25", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        h3("Communicative Temptation 3, probe 2: Minute Four"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_27", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_28", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_29", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_30", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_31", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_32", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_33", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_34", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_35", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Sharing Books 1: Minute Five"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_37", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_38", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_39", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_40", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_41", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),
          
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_42", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),
        
        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_43", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Sharing Books 2: Minute Six"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_45", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_46", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_47", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_48", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_49", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_50", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_51", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 1: Minute Seven"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_53", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_54", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_56", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_57", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Parent/Caregiver-Child Play 2: Minute Eight"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_66", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_67", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_69", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_70", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 3: Minute Nine"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_79", p("Explores features of object"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_80", p("Uses item functionally"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_82", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_83", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Parent/Caregiver-Child Play 4: Minute Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_92", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_93", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_95", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_96", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobY_v2_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

h2("Your Score"),
fluidRow(
  column(12,
         verbatimTextOutput("sobY_v2_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("sobY_v2_incorrect"))
)
),

## Social Observational (older) page ------
### Video 1: SOM (older) -----
tabItem(tabName = "tab_somO_v1",

        h2("Certification Checklist for Social Observational (ages 24 months and older)"),

        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_sobO_v1_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sobO_v1_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sobO_v1_site", h4("Site:"),
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
                 dateInput("text_sobO_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),


        h3("Joint Attention: Minute One"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_1", p("Following point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_2", p("Complies with request (pot) spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_3", p("Complies with request after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_4", p("Comments on jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_5", p("Points to jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_6", p("Shows jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Pretend Play: Minutes Two-Three"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_7", p("Child-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_8", p("Substitution."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_9", p("Substitution without object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_10", p("Dolls-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_11", p("Socio-dramatic play."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Prosocial Behavior: Minutes Four-Five"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_12", p("Shares blocks."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_13", p("Takes turns building tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_15", p("Concerned facial expression."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_16", p("Verbal concern/comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_17", p("Physical comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_18", p("Helps clean up spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_19", p("Helps clean up after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),




        h3("Social Communication 1: Minutes Six-Seven"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_21", p("Rebuilds elephant all steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_22", p("Steps in correct order."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_23", p("Asks for help opening container."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Social Communications 2: Minutes Eight-Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_24", p("Initiates/responds to conversation."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_25", p("Takes a conversational turn."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_26", p("Responds to a shift in topic."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_27", p("Corrects mislabeling by protest only."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_29", p("Adapts speech register for doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_30", p("Turns book to face doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_31", p("Attempts to teach doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
          ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobO_v1_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

h2("Your Score"),
fluidRow(
  column(12,
         verbatimTextOutput("sobO_v1_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("sobO_v1_incorrect"))
)

),

### Video 2: SOM (older) -----
tabItem(tabName = "tab_somO_v2",

        h2("Certification Checklist for Social Observational (ages 24 months and older)"),

        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_sobO_v2_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sobO_v2_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sobO_v2_site", h4("Site:"),
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
                 dateInput("text_sobO_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),


        h3("Joint Attention: Minute One"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_1", p("Following point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_2", p("Complies with request (pot) spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_3", p("Complies with request after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_4", p("Comments on jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_5", p("Points to jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_6", p("Shows jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        h3("Pretend Play: Minutes Two-Three"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_7", p("Child-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_8", p("Substitution."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_9", p("Substitution without object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_10", p("Dolls-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_11", p("Socio-dramatic play."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Prosocial Behavior: Minutes Four-Five"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_12", p("Shares blocks."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_13", p("Takes turns building tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_15", p("Concerned facial expression."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_16", p("Verbal concern/comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_17", p("Physical comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_18", p("Helps clean up spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_19", p("Helps clean up after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),




        h3("Social Communication 1: Minutes Six-Seven"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_21", p("Rebuilds elephant all steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_22", p("Steps in correct order."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_23", p("Asks for help opening container."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),



        h3("Social Communications 2: Minutes Eight-Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_24", p("Initiates/responds to conversation."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_25", p("Takes a conversational turn."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_26", p("Responds to a shift in topic."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_27", p("Corrects mislabeling by protest only."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_29", p("Adapts speech register for doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_30", p("Turns book to face doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_31", p("Attempts to teach doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobO_v2_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sobO_v2_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("sobO_v2_incorrect"))
        )
),


## Get Up and Go page ------

### Video 1: GUG -----
tabItem(tabName = "tab_gug_v1",

        h2("Certification Checklist for Get Up and Go"),
        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_gug_v1_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_gug_v1_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_gug_v1_site", h4("Site:"),
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
                 dateInput("text_gug_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_back", p("Did child get off back?"),
                              choiceNames = c("No (didn’t try)", "No (tried but couldn’t)", "Yes"),
                              choiceValues = app_values_0_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_roll", p("How child got off back? "),
                              choiceNames = c("Rolled to belly, hands trapped",
                                              "Rolled to belly, hands out", "Rolled to hands-knees",
                                              "Side lying", "Got up without rolling"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_uppos", p("Most upright postures?"),
                              choiceNames = c("Belly", "Hands-knees or hands-feet",
                                              "Sit or kneel, back vertical", "Stand"),
                              choiceValues = app_values_1_4, selected = "")
          )
        ),

        




        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_turn", p("Child turned to face finish line? "),
                              choiceNames = c("Never faced finish",
                                              "Turned to face finish", "Already facing finish"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_trameth", p("How child traveled?"),
                              choiceNames = c("Did not travel", "Log roll",
                                              "Belly crawl", "Bum shuffle or hitch",
                                              "Hands-knees or hands-feet", "Knee-walk or half-kneel",
                                              "Walk"),
                              choiceValues = app_values_1_7, selected = "")
          )
        ),



        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_tradis", p("How far child traveled?"),
                              choiceNames = c("Took a few steps and fell",
                                              "Took a few steps and stopped", "3 meters, not continuous",
                                              "3 meters, but dawdled", "3 meters, no dawdling"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v1_starttime", p("When did the child cross start line?", br(),
                                                       "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v1_endtime", p("When did the child cross finish line?", br(),
                                                     "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_stairup", p("How did child get up stair?"),
                              choiceNames = c("Didn't try", "Did not pull up",
                                              "Pulled up to knees", "Pulled up to stand",
                                              "Climbed up, stayed prone", "Climbed up, stood up",
                                              "Tried to step & fell", "Stepped up, not integrated",
                                              "Stepped up, gait integrated"),
                              choiceValues = app_values_0_8, selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_stairdo", p("How did child get down stair?"),
                              choiceNames = c("Didn't try to come down",
                                              "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                              "Walked down, fell", "Walked down, not integrated",
                                              "Walked down, integrated", "Jumped or leaped & fell",
                                              "Jumped or leaped no fall"),
                              choiceValues = app_values_0_8, selected = "")
          )
        ),



        fluidRow(
          column(1,
                 actionButton(inputId = "gug_v1_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("gug_v1_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("gug_v1_incorrect"))
        )
),


### Video 2: GUG -----
tabItem(tabName = "tab_gug_v2",

        h2("Certification Checklist for Get Up and Go"),
        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_gug_v2_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_gug_v2_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_gug_v2_site", h4("Site:"),
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
                 dateInput("text_gug_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),




        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_back", p("Did child get off back?"),
                              choiceNames = c("No (didn’t try)", "No (tried but couldn’t)", "Yes"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_roll", p("How child got off back? "),
                              choiceNames = c("Rolled to belly, hands trapped",
                                              "Rolled to belly, hands out", "Rolled to hands-knees",
                                              "Side lying", "Got up without rolling"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_uppos", p("Most upright postures?"),
                              choiceNames = c("Belly", "Hands-knees or hands-feet",
                                              "Sit or kneel, back vertical", "Stand"),
                              choiceValues = app_values_1_4, selected = "")
          )
        ),

        



        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_stand", p("How child got to standing?"),
                              choiceNames = c("Down-dog to stand",
                                              "Half-kneel to stand", "Squat to stand"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_hands", p("How many hands child used?"),
                              choiceNames = c("0",
                                              "1", "2"),
                              choiceValues = app_values_0_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_turn", p("Child turned to face finish line? "),
                              choiceNames = c("Never faced finish",
                                              "Turned to face finish", "Already facing finish"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_trameth", p("How child traveled?"),
                              choiceNames = c("Did not travel", "Log roll",
                                              "Belly crawl", "Bum shuffle or hitch",
                                              "Hands-knees or hands-feet", "Knee-walk or half-kneel",
                                              "Walk"),
                              choiceValues = app_values_1_7, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_toes", p("Child walked on toes?"),
                              choiceNames = c("Can't see heels", "No",
                                              "Right foot", "Left foot",
                                              "Both"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_tradis", p("How far child traveled?"),
                              choiceNames = c("Took a few steps and fell",
                                              "Took a few steps and stopped", "3 meters, not continuous",
                                              "3 meters, but dawdled", "3 meters, no dawdling"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v2_starttime", p("When did the child cross start line?", br(),
                                                       "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v2_endtime", p("When did the child cross finish line?", br(),
                                                     "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_stairup", p("How did child get up stair?"),
                              choiceNames = c("Didn't try", "Did not pull up",
                                              "Pulled up to knees", "Pulled up to stand",
                                              "Climbed up, stayed prone", "Climbed up, stood up",
                                              "Tried to step & fell", "Stepped up, not integrated",
                                              "Stepped up, gait integrated"),
                              choiceValues = app_values_1_9, selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_stairdo", p("How did child get down stair?"),
                              choiceNames = c("Didn't try to come down",
                                              "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                              "Walked down, fell", "Walked down, not integrated",
                                              "Walked down, integrated", "Jumped or leaped & fell",
                                              "Jumped or leaped no fall"),
                              choiceValues = app_values_0_8, selected = "")
          )
        ),



        fluidRow(
          column(1,
                 actionButton(inputId = "gug_v2_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

h2("Your Score"),
fluidRow(
  column(12,
         verbatimTextOutput("gug_v2_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("gug_v2_incorrect"))
)
),

## Reach to Eat page ------

### Video 1: RtE -----
tabItem(tabName = "tab_rte_v1",

        h2("Certification Checklist for Reach to Eat"),
        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_rte_v1_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_rte_v1_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_rte_v1_site", h4("Site:"),
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
                 dateInput("text_rte_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),




        # h3("Block (BT) Task"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtr_success", p("Did child reach block with right hand?"),
        #                       choiceNames = c("Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values_0_5, selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c("Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),
        #
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtl_success", p("Did child reach block with left hand?"),
        #                       choiceNames = c("Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values_0_5, selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtl_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c("Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),


        h3("Cheerio Small Base Task"),
        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c("Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctl_success", p("Did child reach small base with left hand?"),
                              choiceNames = c("Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),



        # h3("Cheerio Large Base Task"),
        # h4("Right Hand"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctr_success", p("Did child reach large base with right hand?"),
        #                       choiceNames = c("Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values_0_5, selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c("Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),
        #
        # h4("Left Hand"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctl_success", p("Did child reach large base with left hand?"),
        #                       choiceNames = c("Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values_0_5, selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lctl_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c("Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),
        #
        #
        h3("Cheerio Spoon Easy & Hard Tasks"),

        h4("Cheerio Spoon Easy (Right Hand)"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnter_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c("Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnter_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c("Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnter_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(
           column(6,
                 radioButtons("radio_rte_v1_spnter_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c("Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnter_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c("Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values_0_3_neg2, selected = "")
          )
        ),


        fluidRow(
          h4("Cheerio Spoon Hard (Right Hand)")
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c("Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c("Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c("Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c("Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values_0_3_neg2, selected = "")
          )
        ),



          h4("Cheerio Spoon Easy (Left Hand)"),




        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c("Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c("Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c("Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c("Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values_0_3_neg2, selected = "")
          )
        ),



          h4("Cheerio Spoon Hard (Left Hand)"),



        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c("Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c("Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnthl_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c("Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c("Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values_0_3_neg2, selected = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "rte_v1_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

h2("Your Score"),
fluidRow(
  column(12,
         verbatimTextOutput("rte_v1_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("rte_v1_incorrect"))
)
),



### Video 2: RtE -----
tabItem(tabName = "tab_rte_v2",

        h2("Certification Checklist for Reach to Eat"),
        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_rte_v2_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_rte_v2_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_rte_v2_site", h4("Site:"),
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
                 dateInput("text_rte_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),
        

        h3("Cheerio Small Base Task"),

        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c("Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctl_success", p("Did child reach small base with left hand?"),
                              choiceNames = c("Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),



        h3("Cheerio Large Base Task"),

        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctr_success", p("Did child reach large base with right hand?"),
                              choiceNames = c("Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctl_success", p("Did child reach large base with left hand?"),
                              choiceNames = c("Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v2_lctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(
          column(1,
                 actionButton(inputId = "rte_v2_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

h2("Your Score"),
fluidRow(
  column(12,
         verbatimTextOutput("rte_v2_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("rte_v2_incorrect"))
)
),


## Sit and Stand page ------

### Video 1: SaS -----
tabItem(tabName = "tab_sas_v1",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_sas_v1_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sas_v1_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v1_site", h4("Site:"),
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
                 dateInput("text_sas_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),

        h3("Unsupported Sit"),


        fluidRow(
         column(6,
                 radioButtons("radio_sas_v1_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c("Non-compliant", "Fell", "Used hands for support",
                                              "Sat without support", "Shifted to prone"), choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v1_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                               "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 numericInput("radio_sas_v1_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                             "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v1_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v1_score"))
        ),

        h3("Incorrect scores and their answers are displayed below."),

        fluidRow(
          column(12, tableOutput("sas_v1_incorrect"))
        )
),


### Video 2: SaS -----
tabItem(tabName = "tab_sas_v2",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_sas_v2_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sas_v2_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v2_site", h4("Site:"),
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
                 dateInput("text_sas_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )
        ),

        
        h3("Unsupported Stand: Feet Together"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v2_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet together"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        h3("Unsupported Stand: Tandem Stand"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v2_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet tandem"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v2_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v2_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("sas_v2_incorrect"))
        )
),

### Video 3: SaS -----
tabItem(tabName = "tab_sas_v3",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 3"),

        fluidRow(
          column(6,
                 textInput("text_sas_v3_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sas_v3_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v3_site", h4("Site:"),
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
                 dateInput("text_sas_v3_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),

        h3("Pull to Sit"),


        fluidRow(
          column(6,
                 radioButtons("radio_sas_v3_pts_q1", p("Pull to Sit: head in line with torso?"),
                              choiceNames = c("No", "Yes"), choiceValues = app_values_1_2, selected = "")
          )
        ),


        h3("Unsupported Sit"),


        fluidRow(
          column(6,
                 radioButtons("radio_sas_v3_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c("Non-compliant", "Fell", "Used hands for support",
                                            "Sat without support", "Shifted to prone"), choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v3_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                                  "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 numericInput("radio_sas_v3_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                                "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v3_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v3_score"))
        ),
        
        h3("Incorrect scores and their answers are displayed below."),
        
        fluidRow(
          column(12, tableOutput("sas_v3_incorrect"))
          )
),

### Video 4: SaS -----
tabItem(tabName = "tab_sas_v4",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 4"),

        fluidRow(
          column(6,
                 textInput("text_sas_v4_person", h4("Your Name (Last, First):"),
                           value = "")
          ),

          column(6,
                 # textInput("text_sas_v4_site", h4("Site:"),
                 #           value = "")
                 selectInput("text_sas_v4_site", h4("Site:"),
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
                 dateInput("text_sas_v4_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          )

        ),

        # h3("Pull to Sit"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v4_pts_q1", p("Pull to Sit: head in line with torso?"),
        #                       choiceNames = c("No", "Yes"), choiceValues = app_values_1_2, selected = "")
        #   )
        # ),
        #
        #
        # h3("Unsupported Sit"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v4_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
        #                       choiceNames = c("No", "Yes"), choiceValues = app_values_1_2, selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v4_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
        #                                                           "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v4_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
        #                                                         "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        #
        # h3("Unsupported Stand: Feet Apart"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v4_ftapt_q1", p("Feet Apart Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c("Non-complaint", "Fell", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values_1_5, selected = "")
        #   )
        # ),
        #
        #
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v4_ftapt_q2_starttime", p("Find Timing: When did the child start standing?", br(),
        #                                                            "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v4_ftapt_q2_endtime", p("Find Timing: When did the child stop standing?", br(),
        #                                                          "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #

        h3("Unsupported Stand: Feet Together"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v4_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet together"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        h3("Unsupported Stand: Tandem Stand"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v4_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                              "Stepped out", "Stood feet tandem"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v4_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

fluidRow(
  column(12,
         verbatimTextOutput("sas_v4_score"))
),

h3("Incorrect scores and their answers are displayed below."),

fluidRow(
  column(12, tableOutput("sas_v4_incorrect"))
)
)

## Close to Survey -----
)))


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output, session) {


## Social Observational (younger) data ------
### Video 1 ------ 
  sobY_v1_values <- eventReactive(input$sobY_v1_submit, {
    
    sobY_v1_data <- data.frame(
      task_id = c("sobY_v1"),
      text_sobY_v1_person = c(input$text_sobY_v1_person),
      text_sobY_v1_site = c(input$text_sobY_v1_site),
      text_sobY_v1_date = Sys.time(),#format(as.Date(input$text_sobY_v1_date, origin="2023-01-01")),
      
      sobY_v1_SO_9_23_1 = c(input$radio_sobY_v1_SO_9_23_1),
      sobY_v1_SO_9_23_2 = c(input$radio_sobY_v1_SO_9_23_2),
      sobY_v1_SO_9_23_3 = c(input$radio_sobY_v1_SO_9_23_3),
      sobY_v1_SO_9_23_4 = c(input$radio_sobY_v1_SO_9_23_4),
      sobY_v1_SO_9_23_5 = c(input$radio_sobY_v1_SO_9_23_5),
      sobY_v1_SO_9_23_6 = c(input$radio_sobY_v1_SO_9_23_6),
      sobY_v1_SO_9_23_7 = c(input$radio_sobY_v1_SO_9_23_7),
      
      sobY_v1_SO_9_23_9 = c(input$radio_sobY_v1_SO_9_23_9),
      sobY_v1_SO_9_23_10 = c(input$radio_sobY_v1_SO_9_23_10),
      sobY_v1_SO_9_23_11 = c(input$radio_sobY_v1_SO_9_23_11),
      sobY_v1_SO_9_23_12 = c(input$radio_sobY_v1_SO_9_23_12),
      sobY_v1_SO_9_23_13 = c(input$radio_sobY_v1_SO_9_23_13),
      sobY_v1_SO_9_23_14 = c(input$radio_sobY_v1_SO_9_23_14),
      sobY_v1_SO_9_23_15 = c(input$radio_sobY_v1_SO_9_23_15),
      sobY_v1_SO_9_23_16 = c(input$radio_sobY_v1_SO_9_23_16),
      sobY_v1_SO_9_23_17 = c(input$radio_sobY_v1_SO_9_23_17),
      
      sobY_v1_SO_9_23_19 = c(input$radio_sobY_v1_SO_9_23_19),
      sobY_v1_SO_9_23_20 = c(input$radio_sobY_v1_SO_9_23_20),
      sobY_v1_SO_9_23_21 = c(input$radio_sobY_v1_SO_9_23_21),
      sobY_v1_SO_9_23_22 = c(input$radio_sobY_v1_SO_9_23_22),
      sobY_v1_SO_9_23_23 = c(input$radio_sobY_v1_SO_9_23_23),
      sobY_v1_SO_9_23_24 = c(input$radio_sobY_v1_SO_9_23_24),
      sobY_v1_SO_9_23_25 = c(input$radio_sobY_v1_SO_9_23_25),
      
      sobY_v1_SO_9_23_27 = c(input$radio_sobY_v1_SO_9_23_27),
      sobY_v1_SO_9_23_28 = c(input$radio_sobY_v1_SO_9_23_28),
      sobY_v1_SO_9_23_29 = c(input$radio_sobY_v1_SO_9_23_29),
      sobY_v1_SO_9_23_30 = c(input$radio_sobY_v1_SO_9_23_30),
      sobY_v1_SO_9_23_31 = c(input$radio_sobY_v1_SO_9_23_31),
      sobY_v1_SO_9_23_32 = c(input$radio_sobY_v1_SO_9_23_32),
      sobY_v1_SO_9_23_33 = c(input$radio_sobY_v1_SO_9_23_33),
      sobY_v1_SO_9_23_34 = c(input$radio_sobY_v1_SO_9_23_34),
      sobY_v1_SO_9_23_35 = c(input$radio_sobY_v1_SO_9_23_35),
      
      sobY_v1_SO_9_23_37 = c(input$radio_sobY_v1_SO_9_23_37),
      sobY_v1_SO_9_23_38 = c(input$radio_sobY_v1_SO_9_23_38),
      sobY_v1_SO_9_23_39 = c(input$radio_sobY_v1_SO_9_23_39),
      sobY_v1_SO_9_23_40 = c(input$radio_sobY_v1_SO_9_23_40),
      sobY_v1_SO_9_23_41 = c(input$radio_sobY_v1_SO_9_23_41),
      sobY_v1_SO_9_23_42 = c(input$radio_sobY_v1_SO_9_23_42),
      sobY_v1_SO_9_23_43 = c(input$radio_sobY_v1_SO_9_23_43),
      
      sobY_v1_SO_9_23_45 = c(input$radio_sobY_v1_SO_9_23_45),
      sobY_v1_SO_9_23_46 = c(input$radio_sobY_v1_SO_9_23_46),
      sobY_v1_SO_9_23_47 = c(input$radio_sobY_v1_SO_9_23_47),
      sobY_v1_SO_9_23_48 = c(input$radio_sobY_v1_SO_9_23_48),
      sobY_v1_SO_9_23_49 = c(input$radio_sobY_v1_SO_9_23_49),
      sobY_v1_SO_9_23_50 = c(input$radio_sobY_v1_SO_9_23_50),
      sobY_v1_SO_9_23_51 = c(input$radio_sobY_v1_SO_9_23_51),
      
      sobY_v1_SO_9_23_53 = c(input$radio_sobY_v1_SO_9_23_53),
      sobY_v1_SO_9_23_54 = c(input$radio_sobY_v1_SO_9_23_54),
      sobY_v1_SO_9_23_55 = c(input$radio_sobY_v1_SO_9_23_55),
      sobY_v1_SO_9_23_56 = c(input$radio_sobY_v1_SO_9_23_56),
      sobY_v1_SO_9_23_57 = c(input$radio_sobY_v1_SO_9_23_57),
      
      sobY_v1_SO_9_23_66 = c(input$radio_sobY_v1_SO_9_23_66),
      sobY_v1_SO_9_23_67 = c(input$radio_sobY_v1_SO_9_23_67),
      sobY_v1_SO_9_23_68 = c(input$radio_sobY_v1_SO_9_23_68),
      sobY_v1_SO_9_23_69 = c(input$radio_sobY_v1_SO_9_23_69),
      sobY_v1_SO_9_23_70 = c(input$radio_sobY_v1_SO_9_23_70),
      
      sobY_v1_SO_9_23_79 = c(input$radio_sobY_v1_SO_9_23_79),
      sobY_v1_SO_9_23_80 = c(input$radio_sobY_v1_SO_9_23_80),
      sobY_v1_SO_9_23_81 = c(input$radio_sobY_v1_SO_9_23_81),
      sobY_v1_SO_9_23_82 = c(input$radio_sobY_v1_SO_9_23_82),
      sobY_v1_SO_9_23_83 = c(input$radio_sobY_v1_SO_9_23_83),
      
      sobY_v1_SO_9_23_92 = c(input$radio_sobY_v1_SO_9_23_92),
      sobY_v1_SO_9_23_93 = c(input$radio_sobY_v1_SO_9_23_93),
      sobY_v1_SO_9_23_94 = c(input$radio_sobY_v1_SO_9_23_94),
      sobY_v1_SO_9_23_95 = c(input$radio_sobY_v1_SO_9_23_95),
      sobY_v1_SO_9_23_96 = c(input$radio_sobY_v1_SO_9_23_96)
      
    ) %>%
      mutate(
        sobY_v1_SO_9_23_1 = as.numeric(sobY_v1_SO_9_23_1),
        sobY_v1_SO_9_23_2 = as.numeric(sobY_v1_SO_9_23_2),
        sobY_v1_SO_9_23_3 = as.numeric(sobY_v1_SO_9_23_3),
        sobY_v1_SO_9_23_4 = as.numeric(sobY_v1_SO_9_23_4),
        sobY_v1_SO_9_23_5 = as.numeric(sobY_v1_SO_9_23_5),
        sobY_v1_SO_9_23_6 = as.numeric(sobY_v1_SO_9_23_6),
        sobY_v1_SO_9_23_7 = as.numeric(sobY_v1_SO_9_23_7),
        
        sobY_v1_SO_9_23_9 = as.numeric(sobY_v1_SO_9_23_9),
        sobY_v1_SO_9_23_10 = as.numeric(sobY_v1_SO_9_23_10),
        sobY_v1_SO_9_23_11 = as.numeric(sobY_v1_SO_9_23_11),
        sobY_v1_SO_9_23_12 = as.numeric(sobY_v1_SO_9_23_12),
        sobY_v1_SO_9_23_13 = as.numeric(sobY_v1_SO_9_23_13),
        sobY_v1_SO_9_23_14 = as.numeric(sobY_v1_SO_9_23_14),
        sobY_v1_SO_9_23_15 = as.numeric(sobY_v1_SO_9_23_15),
        sobY_v1_SO_9_23_16 = as.numeric(sobY_v1_SO_9_23_16),
        sobY_v1_SO_9_23_17 = as.numeric(sobY_v1_SO_9_23_17),
        
        sobY_v1_SO_9_23_19 = as.numeric(sobY_v1_SO_9_23_19),
        sobY_v1_SO_9_23_20 = as.numeric(sobY_v1_SO_9_23_20),
        sobY_v1_SO_9_23_21 = as.numeric(sobY_v1_SO_9_23_21),
        sobY_v1_SO_9_23_22 = as.numeric(sobY_v1_SO_9_23_22),
        sobY_v1_SO_9_23_23 = as.numeric(sobY_v1_SO_9_23_23),
        sobY_v1_SO_9_23_24 = as.numeric(sobY_v1_SO_9_23_24),
        sobY_v1_SO_9_23_25 = as.numeric(sobY_v1_SO_9_23_25),
        
        sobY_v1_SO_9_23_27 = as.numeric(sobY_v1_SO_9_23_27),
        sobY_v1_SO_9_23_28 = as.numeric(sobY_v1_SO_9_23_28),
        sobY_v1_SO_9_23_29 = as.numeric(sobY_v1_SO_9_23_29),
        sobY_v1_SO_9_23_30 = as.numeric(sobY_v1_SO_9_23_30),
        sobY_v1_SO_9_23_31 = as.numeric(sobY_v1_SO_9_23_31),
        sobY_v1_SO_9_23_32 = as.numeric(sobY_v1_SO_9_23_32),
        sobY_v1_SO_9_23_33 = as.numeric(sobY_v1_SO_9_23_33),
        sobY_v1_SO_9_23_34 = as.numeric(sobY_v1_SO_9_23_34),
        sobY_v1_SO_9_23_35 = as.numeric(sobY_v1_SO_9_23_35),
        
        sobY_v1_SO_9_23_37 = as.numeric(sobY_v1_SO_9_23_37),
        sobY_v1_SO_9_23_38 = as.numeric(sobY_v1_SO_9_23_38),
        sobY_v1_SO_9_23_39 = as.numeric(sobY_v1_SO_9_23_39),
        sobY_v1_SO_9_23_40 = as.numeric(sobY_v1_SO_9_23_40),
        sobY_v1_SO_9_23_41 = as.numeric(sobY_v1_SO_9_23_41),
        sobY_v1_SO_9_23_42 = as.numeric(sobY_v1_SO_9_23_42),
        sobY_v1_SO_9_23_43 = as.numeric(sobY_v1_SO_9_23_43),
        
        sobY_v1_SO_9_23_45 = as.numeric(sobY_v1_SO_9_23_45),
        sobY_v1_SO_9_23_46 = as.numeric(sobY_v1_SO_9_23_46),
        sobY_v1_SO_9_23_47 = as.numeric(sobY_v1_SO_9_23_47),
        sobY_v1_SO_9_23_48 = as.numeric(sobY_v1_SO_9_23_48),
        sobY_v1_SO_9_23_49 = as.numeric(sobY_v1_SO_9_23_49),
        sobY_v1_SO_9_23_50 = as.numeric(sobY_v1_SO_9_23_50),
        sobY_v1_SO_9_23_51 = as.numeric(sobY_v1_SO_9_23_51),
        
        sobY_v1_SO_9_23_53 = as.numeric(sobY_v1_SO_9_23_53),
        sobY_v1_SO_9_23_54 = as.numeric(sobY_v1_SO_9_23_54),
        sobY_v1_SO_9_23_55 = as.numeric(sobY_v1_SO_9_23_55),
        sobY_v1_SO_9_23_56 = as.numeric(sobY_v1_SO_9_23_56),
        sobY_v1_SO_9_23_57 = as.numeric(sobY_v1_SO_9_23_57),
        
        sobY_v1_SO_9_23_66 = as.numeric(sobY_v1_SO_9_23_66),
        sobY_v1_SO_9_23_67 = as.numeric(sobY_v1_SO_9_23_67),
        sobY_v1_SO_9_23_68 = as.numeric(sobY_v1_SO_9_23_68),
        sobY_v1_SO_9_23_69 = as.numeric(sobY_v1_SO_9_23_69),
        sobY_v1_SO_9_23_70 = as.numeric(sobY_v1_SO_9_23_70),
        
        sobY_v1_SO_9_23_79 = as.numeric(sobY_v1_SO_9_23_79),
        sobY_v1_SO_9_23_80 = as.numeric(sobY_v1_SO_9_23_80),
        sobY_v1_SO_9_23_81 = as.numeric(sobY_v1_SO_9_23_81),
        sobY_v1_SO_9_23_82 = as.numeric(sobY_v1_SO_9_23_82),
        sobY_v1_SO_9_23_83 = as.numeric(sobY_v1_SO_9_23_83),
        
        sobY_v1_SO_9_23_92 = as.numeric(sobY_v1_SO_9_23_92),
        sobY_v1_SO_9_23_93 = as.numeric(sobY_v1_SO_9_23_93),
        sobY_v1_SO_9_23_94 = as.numeric(sobY_v1_SO_9_23_94),
        sobY_v1_SO_9_23_95 = as.numeric(sobY_v1_SO_9_23_95),
        sobY_v1_SO_9_23_96 = as.numeric(sobY_v1_SO_9_23_96)
        
      )
    
    sobY_key_df <- data.frame(
      K_9_23_1 = c(1),
      K_9_23_2 = c(1),
      K_9_23_3 = c(1),
      K_9_23_4 = c(1),
      K_9_23_5 = c(1),
      K_9_23_6 = c(0),
      K_9_23_7 = c(0),
      K_9_23_9 = c(1),
      K_9_23_10 = c(1),
      K_9_23_11 = c(1),
      K_9_23_12 = c(0),
      K_9_23_13 = c(1),
      K_9_23_14 = c(1),
      K_9_23_15 = c(0),
      K_9_23_16 = c(0),
      K_9_23_17 = c(1),
      K_9_23_19 = c(1),
      K_9_23_20 = c(1),
      K_9_23_21 = c(1),
      K_9_23_22 = c(1),
      K_9_23_23 = c(0),
      K_9_23_24 = c(0),
      K_9_23_25 = c(1),
      K_9_23_27 = c(1),
      K_9_23_28 = c(1),
      K_9_23_29 = c(1),
      K_9_23_30 = c(1),
      K_9_23_31 = c(1),
      K_9_23_32 = c(1),
      K_9_23_33 = c(0),
      K_9_23_34 = c(1),
      K_9_23_35 = c(1),
      K_9_23_37 = c(0),
      K_9_23_38 = c(1),
      K_9_23_39 = c(1),
      K_9_23_40 = c(1),
      K_9_23_41 = c(0),
      K_9_23_42 = c(1),
      K_9_23_43 = c(1),
      K_9_23_45 = c(1),
      K_9_23_46 = c(1),
      K_9_23_47 = c(1),
      K_9_23_48 = c(1),
      K_9_23_49 = c(0),
      K_9_23_50 = c(1),
      K_9_23_51 = c(1),
      K_9_23_53 = c(1),
      K_9_23_54 = c(1),
      K_9_23_55 = c(1),
      K_9_23_56 = c(0),
      K_9_23_57 = c(0),
      K_9_23_66 = c(0),
      K_9_23_67 = c(1),
      K_9_23_68 = c(1),
      K_9_23_69 = c(0),
      K_9_23_70 = c(0),
      K_9_23_79 = c(1),
      K_9_23_80 = c(1),
      K_9_23_81 = c(0),
      K_9_23_82 = c(0),
      K_9_23_83 = c(0),
      K_9_23_92 = c(1),
      K_9_23_93 = c(1),
      K_9_23_94 = c(1),
      K_9_23_95 = c(1),
      K_9_23_96 = c(0)
    )
    
    sobY_v1_combined <- bind_cols(sobY_v1_data, sobY_key_df) %>% 
      mutate(Score_sobY_v1_SO_9_23_1 = ifelse(sobY_v1_SO_9_23_1 == K_9_23_1, 1, 0),
             Score_sobY_v1_SO_9_23_2 = ifelse(sobY_v1_SO_9_23_2 == K_9_23_2, 1, 0),
             Score_sobY_v1_SO_9_23_3 = ifelse(sobY_v1_SO_9_23_3 == K_9_23_3, 1, 0),
             Score_sobY_v1_SO_9_23_4 = ifelse(sobY_v1_SO_9_23_4 == K_9_23_4, 1, 0),
             Score_sobY_v1_SO_9_23_5 = ifelse(sobY_v1_SO_9_23_5 == K_9_23_5, 1, 0),
             Score_sobY_v1_SO_9_23_6 = ifelse(sobY_v1_SO_9_23_6 == K_9_23_6, 1, 0),
             Score_sobY_v1_SO_9_23_7 = ifelse(sobY_v1_SO_9_23_7 == K_9_23_7, 1, 0),
             
             Score_sobY_v1_SO_9_23_9 = ifelse(sobY_v1_SO_9_23_9 == K_9_23_9, 1, 0),
             Score_sobY_v1_SO_9_23_10 = ifelse(sobY_v1_SO_9_23_10 == K_9_23_10, 1, 0),
             Score_sobY_v1_SO_9_23_11 = ifelse(sobY_v1_SO_9_23_11 == K_9_23_11, 1, 0),
             Score_sobY_v1_SO_9_23_12 = ifelse(sobY_v1_SO_9_23_12 == K_9_23_12, 1, 0),
             Score_sobY_v1_SO_9_23_13 = ifelse(sobY_v1_SO_9_23_13 == K_9_23_13, 1, 0),
             Score_sobY_v1_SO_9_23_14 = ifelse(sobY_v1_SO_9_23_14 == K_9_23_14, 1, 0),
             Score_sobY_v1_SO_9_23_15 = ifelse(sobY_v1_SO_9_23_15 == K_9_23_15, 1, 0),
             Score_sobY_v1_SO_9_23_16 = ifelse(sobY_v1_SO_9_23_16 == K_9_23_16, 1, 0),
             Score_sobY_v1_SO_9_23_17 = ifelse(sobY_v1_SO_9_23_17 == K_9_23_17, 1, 0),
             
             Score_sobY_v1_SO_9_23_19 = ifelse(sobY_v1_SO_9_23_19 == K_9_23_19, 1, 0),
             Score_sobY_v1_SO_9_23_20 = ifelse(sobY_v1_SO_9_23_20 == K_9_23_20, 1, 0),
             Score_sobY_v1_SO_9_23_21 = ifelse(sobY_v1_SO_9_23_21 == K_9_23_21, 1, 0),
             Score_sobY_v1_SO_9_23_22 = ifelse(sobY_v1_SO_9_23_22 == K_9_23_22, 1, 0),
             Score_sobY_v1_SO_9_23_23 = ifelse(sobY_v1_SO_9_23_23 == K_9_23_23, 1, 0),
             Score_sobY_v1_SO_9_23_24 = ifelse(sobY_v1_SO_9_23_24 == K_9_23_24, 1, 0),
             Score_sobY_v1_SO_9_23_25 = ifelse(sobY_v1_SO_9_23_25 == K_9_23_25, 1, 0),
             
             Score_sobY_v1_SO_9_23_27 = ifelse(sobY_v1_SO_9_23_27 == K_9_23_27, 1, 0),
             Score_sobY_v1_SO_9_23_28 = ifelse(sobY_v1_SO_9_23_28 == K_9_23_28, 1, 0),
             Score_sobY_v1_SO_9_23_29 = ifelse(sobY_v1_SO_9_23_29 == K_9_23_29, 1, 0),
             Score_sobY_v1_SO_9_23_30 = ifelse(sobY_v1_SO_9_23_30 == K_9_23_30, 1, 0),
             Score_sobY_v1_SO_9_23_31 = ifelse(sobY_v1_SO_9_23_31 == K_9_23_31, 1, 0),
             Score_sobY_v1_SO_9_23_32 = ifelse(sobY_v1_SO_9_23_32 == K_9_23_32, 1, 0),
             Score_sobY_v1_SO_9_23_33 = ifelse(sobY_v1_SO_9_23_33 == K_9_23_33, 1, 0),
             Score_sobY_v1_SO_9_23_34 = ifelse(sobY_v1_SO_9_23_34 == K_9_23_34, 1, 0),
             Score_sobY_v1_SO_9_23_35 = ifelse(sobY_v1_SO_9_23_35 == K_9_23_35, 1, 0),
             
             Score_sobY_v1_SO_9_23_37 = ifelse(sobY_v1_SO_9_23_37 == K_9_23_37, 1, 0),
             Score_sobY_v1_SO_9_23_38 = ifelse(sobY_v1_SO_9_23_38 == K_9_23_38, 1, 0),
             Score_sobY_v1_SO_9_23_39 = ifelse(sobY_v1_SO_9_23_39 == K_9_23_39, 1, 0),
             Score_sobY_v1_SO_9_23_40 = ifelse(sobY_v1_SO_9_23_40 == K_9_23_40, 1, 0),
             Score_sobY_v1_SO_9_23_41 = ifelse(sobY_v1_SO_9_23_41 == K_9_23_41, 1, 0),
             Score_sobY_v1_SO_9_23_42 = ifelse(sobY_v1_SO_9_23_42 == K_9_23_42, 1, 0),
             Score_sobY_v1_SO_9_23_43 = ifelse(sobY_v1_SO_9_23_43 == K_9_23_43, 1, 0),
             
             Score_sobY_v1_SO_9_23_45 = ifelse(sobY_v1_SO_9_23_45 == K_9_23_45, 1, 0),
             Score_sobY_v1_SO_9_23_46 = ifelse(sobY_v1_SO_9_23_46 == K_9_23_46, 1, 0),
             Score_sobY_v1_SO_9_23_47 = ifelse(sobY_v1_SO_9_23_47 == K_9_23_47, 1, 0),
             Score_sobY_v1_SO_9_23_48 = ifelse(sobY_v1_SO_9_23_48 == K_9_23_48, 1, 0),
             Score_sobY_v1_SO_9_23_49 = ifelse(sobY_v1_SO_9_23_49 == K_9_23_49, 1, 0),
             Score_sobY_v1_SO_9_23_50 = ifelse(sobY_v1_SO_9_23_50 == K_9_23_50, 1, 0),
             Score_sobY_v1_SO_9_23_51 = ifelse(sobY_v1_SO_9_23_51 == K_9_23_51, 1, 0),
             
             Score_sobY_v1_SO_9_23_53 = ifelse(sobY_v1_SO_9_23_53 == K_9_23_53, 1, 0),
             Score_sobY_v1_SO_9_23_54 = ifelse(sobY_v1_SO_9_23_54 == K_9_23_54, 1, 0),
             Score_sobY_v1_SO_9_23_55 = ifelse(sobY_v1_SO_9_23_55 == K_9_23_55, 1, 0),
             Score_sobY_v1_SO_9_23_56 = ifelse(sobY_v1_SO_9_23_56 == K_9_23_56, 1, 0),
             Score_sobY_v1_SO_9_23_57 = ifelse(sobY_v1_SO_9_23_57 == K_9_23_57, 1, 0),
             
             Score_sobY_v1_SO_9_23_66 = ifelse(sobY_v1_SO_9_23_66 == K_9_23_66, 1, 0),
             Score_sobY_v1_SO_9_23_67 = ifelse(sobY_v1_SO_9_23_67 == K_9_23_67, 1, 0),
             Score_sobY_v1_SO_9_23_68 = ifelse(sobY_v1_SO_9_23_68 == K_9_23_68, 1, 0),
             Score_sobY_v1_SO_9_23_69 = ifelse(sobY_v1_SO_9_23_69 == K_9_23_69, 1, 0),
             Score_sobY_v1_SO_9_23_70 = ifelse(sobY_v1_SO_9_23_70 == K_9_23_70, 1, 0),
             
             Score_sobY_v1_SO_9_23_79 = ifelse(sobY_v1_SO_9_23_79 == K_9_23_79, 1, 0),
             Score_sobY_v1_SO_9_23_80 = ifelse(sobY_v1_SO_9_23_80 == K_9_23_80, 1, 0),
             Score_sobY_v1_SO_9_23_81 = ifelse(sobY_v1_SO_9_23_81 == K_9_23_81, 1, 0),
             Score_sobY_v1_SO_9_23_82 = ifelse(sobY_v1_SO_9_23_82 == K_9_23_82, 1, 0),
             Score_sobY_v1_SO_9_23_83 = ifelse(sobY_v1_SO_9_23_83 == K_9_23_83, 1, 0),
             
             Score_sobY_v1_SO_9_23_92 = ifelse(sobY_v1_SO_9_23_92 == K_9_23_92, 1, 0),
             Score_sobY_v1_SO_9_23_93 = ifelse(sobY_v1_SO_9_23_93 == K_9_23_93, 1, 0),
             Score_sobY_v1_SO_9_23_94 = ifelse(sobY_v1_SO_9_23_94 == K_9_23_94, 1, 0),
             Score_sobY_v1_SO_9_23_95 = ifelse(sobY_v1_SO_9_23_95 == K_9_23_95, 1, 0),
             Score_sobY_v1_SO_9_23_96 = ifelse(sobY_v1_SO_9_23_96 == K_9_23_96, 1, 0),
             
             Score_sobY_v1 = sum(Score_sobY_v1_SO_9_23_1, Score_sobY_v1_SO_9_23_2,       
                                 Score_sobY_v1_SO_9_23_3,       
                                 Score_sobY_v1_SO_9_23_4,       
                                 Score_sobY_v1_SO_9_23_5,       
                                 Score_sobY_v1_SO_9_23_6, Score_sobY_v1_SO_9_23_7,
                                 
                                 Score_sobY_v1_SO_9_23_9,       
                                 Score_sobY_v1_SO_9_23_10,       
                                 Score_sobY_v1_SO_9_23_11,       
                                 Score_sobY_v1_SO_9_23_12,       
                                 Score_sobY_v1_SO_9_23_13,       
                                 Score_sobY_v1_SO_9_23_14,       
                                 Score_sobY_v1_SO_9_23_15,       
                                 Score_sobY_v1_SO_9_23_16,       
                                 Score_sobY_v1_SO_9_23_17,       
                                 
                                 Score_sobY_v1_SO_9_23_19,       
                                 Score_sobY_v1_SO_9_23_20,       
                                 Score_sobY_v1_SO_9_23_21,       
                                 Score_sobY_v1_SO_9_23_22,       
                                 Score_sobY_v1_SO_9_23_23,       
                                 Score_sobY_v1_SO_9_23_24,       
                                 Score_sobY_v1_SO_9_23_25,       
                                 
                                 Score_sobY_v1_SO_9_23_27,       
                                 Score_sobY_v1_SO_9_23_28,       
                                 Score_sobY_v1_SO_9_23_29,       
                                 Score_sobY_v1_SO_9_23_30,       
                                 Score_sobY_v1_SO_9_23_31,       
                                 Score_sobY_v1_SO_9_23_32,       
                                 Score_sobY_v1_SO_9_23_33,       
                                 Score_sobY_v1_SO_9_23_34,       
                                 Score_sobY_v1_SO_9_23_35,       
                                 
                                 Score_sobY_v1_SO_9_23_37,       
                                 Score_sobY_v1_SO_9_23_38,       
                                 Score_sobY_v1_SO_9_23_39,       
                                 Score_sobY_v1_SO_9_23_40,       
                                 Score_sobY_v1_SO_9_23_41,       
                                 Score_sobY_v1_SO_9_23_42,       
                                 Score_sobY_v1_SO_9_23_43,       
                                 
                                 Score_sobY_v1_SO_9_23_45,       
                                 Score_sobY_v1_SO_9_23_46,       
                                 Score_sobY_v1_SO_9_23_47,       
                                 Score_sobY_v1_SO_9_23_48,       
                                 Score_sobY_v1_SO_9_23_49,       
                                 Score_sobY_v1_SO_9_23_50,       
                                 Score_sobY_v1_SO_9_23_51,       
                                 
                                 Score_sobY_v1_SO_9_23_53,       
                                 Score_sobY_v1_SO_9_23_54,       
                                 Score_sobY_v1_SO_9_23_55,       
                                 Score_sobY_v1_SO_9_23_56,       
                                 Score_sobY_v1_SO_9_23_57,       
                                 
                                 Score_sobY_v1_SO_9_23_66,       
                                 Score_sobY_v1_SO_9_23_67,       
                                 Score_sobY_v1_SO_9_23_68,       
                                 Score_sobY_v1_SO_9_23_69,       
                                 Score_sobY_v1_SO_9_23_70,       
                                 
                                 Score_sobY_v1_SO_9_23_79,       
                                 Score_sobY_v1_SO_9_23_80,       
                                 Score_sobY_v1_SO_9_23_81,       
                                 Score_sobY_v1_SO_9_23_82,       
                                 Score_sobY_v1_SO_9_23_83,       
                                 
                                 Score_sobY_v1_SO_9_23_92, Score_sobY_v1_SO_9_23_93, 
                                 Score_sobY_v1_SO_9_23_94,
                                 Score_sobY_v1_SO_9_23_95, Score_sobY_v1_SO_9_23_96
             ),
             Score_sobY_v1 = round(Score_sobY_v1 / 66, 3)
      ) 
    
    sobY_v1_upload <- sobY_v1_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("sobY_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response", 66), rep("Answer", 66), rep("Score", 66), "Overall")
      ) %>%
      rename(name = text_sobY_v1_person,
             site = text_sobY_v1_site,
             date = text_sobY_v1_date) %>% 
      filter(key != "Answer")
    
    sobY_v1_upload <- as.data.frame(sobY_v1_upload)
    
    sheet_append(ss = sheet_id,
                 data = sobY_v1_upload,
                 sheet = "main")
    
    return(sobY_v1_combined)
    
  })
  
  output$sobY_v1_incorrect <- renderTable({
    sobY_v1_data <- sobY_v1_values()
    
    pull_cols <- sobY_v1_data %>% 
      select(starts_with("sobY_v1_SO_9_23_"), starts_with("K_")) %>% 
      colnames()
    
    sobY_v1_data[ ,pull_cols] <- lapply(sobY_v1_data[ ,pull_cols], factor, levels = c(0, 1), labels = c("No", "Yes"))
    
    return_sobY_v1 <- sobY_v1_data %>%
      mutate_all(as.character) %>%
      select(-c(Score_sobY_v1)) %>%
      pivot_longer(.,
                   cols = c(starts_with("sobY_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "Question",
                   values_to = "Score"
      ) %>%
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13", "Q14", "Q15", "Q16", "Q17", "Q18", 
                         "Q19", "Q20", "Q21", "Q22", "Q23", "Q24", 
                         "Q25", "Q26", "Q27", "Q28", "Q29", "Q30", 
                         "Q31", "Q32", "Q33", "Q34", "Q35", "Q36",
                         "Q37", "Q38", "Q39", "Q40", "Q41", "Q42",
                         "Q43", "Q44", "Q45", "Q46", "Q47", "Q48", 
                         "Q49", "Q50", "Q51", "Q52", "Q53", "Q54", 
                         "Q55", "Q56", "Q57", "Q58", "Q59", "Q60",
                         "Q61", "Q62", "Q63", "Q64", "Q65", "Q66"), 3)),
             type = c(rep("Response", 66), rep("Answer", 66), rep("Score", 66))
      ) %>%
      select(-c(task_id:text_sobY_v1_date, Question)) %>%
      rename(Question = Q) %>%
      pivot_wider(.,
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>%
      select(Question, Response, Answer, Score) %>%
      filter(Score != 1)
    
    return(return_sobY_v1)
  })
  
  output$sobY_v1_score <- renderText({
    
    sobY_v1_data <- sobY_v1_values()
    
    percent_correct <- sobY_v1_data$Score_sobY_v1 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  

### Video 2 ------
  sobY_v2_values <- eventReactive(input$sobY_v2_submit, {
    
    sobY_v2_data <- data.frame(
      task_id = c("sobY_v2"),
      text_sobY_v2_person = c(input$text_sobY_v2_person),
      text_sobY_v2_site = c(input$text_sobY_v2_site),
      text_sobY_v2_date = Sys.time(),#format(as.Date(input$text_sobY_v2_date, origin="2023-01-01")),
      
      sobY_v2_SO_9_23_1 = c(input$radio_sobY_v2_SO_9_23_1),
      sobY_v2_SO_9_23_2 = c(input$radio_sobY_v2_SO_9_23_2),
      sobY_v2_SO_9_23_3 = c(input$radio_sobY_v2_SO_9_23_3),
      sobY_v2_SO_9_23_4 = c(input$radio_sobY_v2_SO_9_23_4),
      sobY_v2_SO_9_23_5 = c(input$radio_sobY_v2_SO_9_23_5),
      sobY_v2_SO_9_23_6 = c(input$radio_sobY_v2_SO_9_23_6),
      sobY_v2_SO_9_23_7 = c(input$radio_sobY_v2_SO_9_23_7),
      
      sobY_v2_SO_9_23_9 = c(input$radio_sobY_v2_SO_9_23_9),
      sobY_v2_SO_9_23_10 = c(input$radio_sobY_v2_SO_9_23_10),
      sobY_v2_SO_9_23_11 = c(input$radio_sobY_v2_SO_9_23_11),
      sobY_v2_SO_9_23_12 = c(input$radio_sobY_v2_SO_9_23_12),
      sobY_v2_SO_9_23_13 = c(input$radio_sobY_v2_SO_9_23_13),
      sobY_v2_SO_9_23_14 = c(input$radio_sobY_v2_SO_9_23_14),
      sobY_v2_SO_9_23_15 = c(input$radio_sobY_v2_SO_9_23_15),
      sobY_v2_SO_9_23_16 = c(input$radio_sobY_v2_SO_9_23_16),
      sobY_v2_SO_9_23_17 = c(input$radio_sobY_v2_SO_9_23_17),
      
      sobY_v2_SO_9_23_19 = c(input$radio_sobY_v2_SO_9_23_19),
      sobY_v2_SO_9_23_20 = c(input$radio_sobY_v2_SO_9_23_20),
      sobY_v2_SO_9_23_21 = c(input$radio_sobY_v2_SO_9_23_21),
      sobY_v2_SO_9_23_22 = c(input$radio_sobY_v2_SO_9_23_22),
      sobY_v2_SO_9_23_23 = c(input$radio_sobY_v2_SO_9_23_23),
      sobY_v2_SO_9_23_24 = c(input$radio_sobY_v2_SO_9_23_24),
      sobY_v2_SO_9_23_25 = c(input$radio_sobY_v2_SO_9_23_25),
      
      sobY_v2_SO_9_23_27 = c(input$radio_sobY_v2_SO_9_23_27),
      sobY_v2_SO_9_23_28 = c(input$radio_sobY_v2_SO_9_23_28),
      sobY_v2_SO_9_23_29 = c(input$radio_sobY_v2_SO_9_23_29),
      sobY_v2_SO_9_23_30 = c(input$radio_sobY_v2_SO_9_23_30),
      sobY_v2_SO_9_23_31 = c(input$radio_sobY_v2_SO_9_23_31),
      sobY_v2_SO_9_23_32 = c(input$radio_sobY_v2_SO_9_23_32),
      sobY_v2_SO_9_23_33 = c(input$radio_sobY_v2_SO_9_23_33),
      sobY_v2_SO_9_23_34 = c(input$radio_sobY_v2_SO_9_23_34),
      sobY_v2_SO_9_23_35 = c(input$radio_sobY_v2_SO_9_23_35),
      
      sobY_v2_SO_9_23_37 = c(input$radio_sobY_v2_SO_9_23_37),
      sobY_v2_SO_9_23_38 = c(input$radio_sobY_v2_SO_9_23_38),
      sobY_v2_SO_9_23_39 = c(input$radio_sobY_v2_SO_9_23_39),
      sobY_v2_SO_9_23_40 = c(input$radio_sobY_v2_SO_9_23_40),
      sobY_v2_SO_9_23_41 = c(input$radio_sobY_v2_SO_9_23_41),
      sobY_v2_SO_9_23_42 = c(input$radio_sobY_v2_SO_9_23_42),
      sobY_v2_SO_9_23_43 = c(input$radio_sobY_v2_SO_9_23_43),
      
      sobY_v2_SO_9_23_45 = c(input$radio_sobY_v2_SO_9_23_45),
      sobY_v2_SO_9_23_46 = c(input$radio_sobY_v2_SO_9_23_46),
      sobY_v2_SO_9_23_47 = c(input$radio_sobY_v2_SO_9_23_47),
      sobY_v2_SO_9_23_48 = c(input$radio_sobY_v2_SO_9_23_48),
      sobY_v2_SO_9_23_49 = c(input$radio_sobY_v2_SO_9_23_49),
      sobY_v2_SO_9_23_50 = c(input$radio_sobY_v2_SO_9_23_50),
      sobY_v2_SO_9_23_51 = c(input$radio_sobY_v2_SO_9_23_51),
      
      sobY_v2_SO_9_23_53 = c(input$radio_sobY_v2_SO_9_23_53),
      sobY_v2_SO_9_23_54 = c(input$radio_sobY_v2_SO_9_23_54),
      sobY_v2_SO_9_23_55 = c(input$radio_sobY_v2_SO_9_23_55),
      sobY_v2_SO_9_23_56 = c(input$radio_sobY_v2_SO_9_23_56),
      sobY_v2_SO_9_23_57 = c(input$radio_sobY_v2_SO_9_23_57),
      
      sobY_v2_SO_9_23_66 = c(input$radio_sobY_v2_SO_9_23_66),
      sobY_v2_SO_9_23_67 = c(input$radio_sobY_v2_SO_9_23_67),
      sobY_v2_SO_9_23_68 = c(input$radio_sobY_v2_SO_9_23_68),
      sobY_v2_SO_9_23_69 = c(input$radio_sobY_v2_SO_9_23_69),
      sobY_v2_SO_9_23_70 = c(input$radio_sobY_v2_SO_9_23_70),
      
      sobY_v2_SO_9_23_79 = c(input$radio_sobY_v2_SO_9_23_79),
      sobY_v2_SO_9_23_80 = c(input$radio_sobY_v2_SO_9_23_80),
      sobY_v2_SO_9_23_81 = c(input$radio_sobY_v2_SO_9_23_81),
      sobY_v2_SO_9_23_82 = c(input$radio_sobY_v2_SO_9_23_82),
      sobY_v2_SO_9_23_83 = c(input$radio_sobY_v2_SO_9_23_83),
      
      sobY_v2_SO_9_23_92 = c(input$radio_sobY_v2_SO_9_23_92),
      sobY_v2_SO_9_23_93 = c(input$radio_sobY_v2_SO_9_23_93),
      sobY_v2_SO_9_23_94 = c(input$radio_sobY_v2_SO_9_23_94),
      sobY_v2_SO_9_23_95 = c(input$radio_sobY_v2_SO_9_23_95),
      sobY_v2_SO_9_23_96 = c(input$radio_sobY_v2_SO_9_23_96)
      
    ) %>%
      mutate(
        sobY_v2_SO_9_23_1 = as.numeric(sobY_v2_SO_9_23_1),
        sobY_v2_SO_9_23_2 = as.numeric(sobY_v2_SO_9_23_2),
        sobY_v2_SO_9_23_3 = as.numeric(sobY_v2_SO_9_23_3),
        sobY_v2_SO_9_23_4 = as.numeric(sobY_v2_SO_9_23_4),
        sobY_v2_SO_9_23_5 = as.numeric(sobY_v2_SO_9_23_5),
        sobY_v2_SO_9_23_6 = as.numeric(sobY_v2_SO_9_23_6),
        sobY_v2_SO_9_23_7 = as.numeric(sobY_v2_SO_9_23_7),
        
        sobY_v2_SO_9_23_9 = as.numeric(sobY_v2_SO_9_23_9),
        sobY_v2_SO_9_23_10 = as.numeric(sobY_v2_SO_9_23_10),
        sobY_v2_SO_9_23_11 = as.numeric(sobY_v2_SO_9_23_11),
        sobY_v2_SO_9_23_12 = as.numeric(sobY_v2_SO_9_23_12),
        sobY_v2_SO_9_23_13 = as.numeric(sobY_v2_SO_9_23_13),
        sobY_v2_SO_9_23_14 = as.numeric(sobY_v2_SO_9_23_14),
        sobY_v2_SO_9_23_15 = as.numeric(sobY_v2_SO_9_23_15),
        sobY_v2_SO_9_23_16 = as.numeric(sobY_v2_SO_9_23_16),
        sobY_v2_SO_9_23_17 = as.numeric(sobY_v2_SO_9_23_17),
        
        sobY_v2_SO_9_23_19 = as.numeric(sobY_v2_SO_9_23_19),
        sobY_v2_SO_9_23_20 = as.numeric(sobY_v2_SO_9_23_20),
        sobY_v2_SO_9_23_21 = as.numeric(sobY_v2_SO_9_23_21),
        sobY_v2_SO_9_23_22 = as.numeric(sobY_v2_SO_9_23_22),
        sobY_v2_SO_9_23_23 = as.numeric(sobY_v2_SO_9_23_23),
        sobY_v2_SO_9_23_24 = as.numeric(sobY_v2_SO_9_23_24),
        sobY_v2_SO_9_23_25 = as.numeric(sobY_v2_SO_9_23_25),
        
        sobY_v2_SO_9_23_27 = as.numeric(sobY_v2_SO_9_23_27),
        sobY_v2_SO_9_23_28 = as.numeric(sobY_v2_SO_9_23_28),
        sobY_v2_SO_9_23_29 = as.numeric(sobY_v2_SO_9_23_29),
        sobY_v2_SO_9_23_30 = as.numeric(sobY_v2_SO_9_23_30),
        sobY_v2_SO_9_23_31 = as.numeric(sobY_v2_SO_9_23_31),
        sobY_v2_SO_9_23_32 = as.numeric(sobY_v2_SO_9_23_32),
        sobY_v2_SO_9_23_33 = as.numeric(sobY_v2_SO_9_23_33),
        sobY_v2_SO_9_23_34 = as.numeric(sobY_v2_SO_9_23_34),
        sobY_v2_SO_9_23_35 = as.numeric(sobY_v2_SO_9_23_35),
        
        sobY_v2_SO_9_23_37 = as.numeric(sobY_v2_SO_9_23_37),
        sobY_v2_SO_9_23_38 = as.numeric(sobY_v2_SO_9_23_38),
        sobY_v2_SO_9_23_39 = as.numeric(sobY_v2_SO_9_23_39),
        sobY_v2_SO_9_23_40 = as.numeric(sobY_v2_SO_9_23_40),
        sobY_v2_SO_9_23_41 = as.numeric(sobY_v2_SO_9_23_41),
        sobY_v2_SO_9_23_42 = as.numeric(sobY_v2_SO_9_23_42),
        sobY_v2_SO_9_23_43 = as.numeric(sobY_v2_SO_9_23_43),
        
        sobY_v2_SO_9_23_45 = as.numeric(sobY_v2_SO_9_23_45),
        sobY_v2_SO_9_23_46 = as.numeric(sobY_v2_SO_9_23_46),
        sobY_v2_SO_9_23_47 = as.numeric(sobY_v2_SO_9_23_47),
        sobY_v2_SO_9_23_48 = as.numeric(sobY_v2_SO_9_23_48),
        sobY_v2_SO_9_23_49 = as.numeric(sobY_v2_SO_9_23_49),
        sobY_v2_SO_9_23_50 = as.numeric(sobY_v2_SO_9_23_50),
        sobY_v2_SO_9_23_51 = as.numeric(sobY_v2_SO_9_23_51),
        
        sobY_v2_SO_9_23_53 = as.numeric(sobY_v2_SO_9_23_53),
        sobY_v2_SO_9_23_54 = as.numeric(sobY_v2_SO_9_23_54),
        sobY_v2_SO_9_23_55 = as.numeric(sobY_v2_SO_9_23_55),
        sobY_v2_SO_9_23_56 = as.numeric(sobY_v2_SO_9_23_56),
        sobY_v2_SO_9_23_57 = as.numeric(sobY_v2_SO_9_23_57),
        
        sobY_v2_SO_9_23_66 = as.numeric(sobY_v2_SO_9_23_66),
        sobY_v2_SO_9_23_67 = as.numeric(sobY_v2_SO_9_23_67),
        sobY_v2_SO_9_23_68 = as.numeric(sobY_v2_SO_9_23_68),
        sobY_v2_SO_9_23_69 = as.numeric(sobY_v2_SO_9_23_69),
        sobY_v2_SO_9_23_70 = as.numeric(sobY_v2_SO_9_23_70),
        
        sobY_v2_SO_9_23_79 = as.numeric(sobY_v2_SO_9_23_79),
        sobY_v2_SO_9_23_80 = as.numeric(sobY_v2_SO_9_23_80),
        sobY_v2_SO_9_23_81 = as.numeric(sobY_v2_SO_9_23_81),
        sobY_v2_SO_9_23_82 = as.numeric(sobY_v2_SO_9_23_82),
        sobY_v2_SO_9_23_83 = as.numeric(sobY_v2_SO_9_23_83),
        
        sobY_v2_SO_9_23_92 = as.numeric(sobY_v2_SO_9_23_92),
        sobY_v2_SO_9_23_93 = as.numeric(sobY_v2_SO_9_23_93),
        sobY_v2_SO_9_23_94 = as.numeric(sobY_v2_SO_9_23_94),
        sobY_v2_SO_9_23_95 = as.numeric(sobY_v2_SO_9_23_95),
        sobY_v2_SO_9_23_96 = as.numeric(sobY_v2_SO_9_23_96)
        
      )
    
    sobY_key_df <- data.frame(
      K_9_23_1 = c(1),
      K_9_23_2 = c(1),
      K_9_23_3 = c(1),
      K_9_23_4 = c(1),
      K_9_23_5 = c(0),
      K_9_23_6 = c(0),
      K_9_23_7 = c(0),
      K_9_23_9 = c(1),
      K_9_23_10 = c(1),
      K_9_23_11 = c(1),
      K_9_23_12 = c(0),
      K_9_23_13 = c(1),
      K_9_23_14 = c(1),
      K_9_23_15 = c(0),
      K_9_23_16 = c(0),
      K_9_23_17 = c(1),
      K_9_23_19 = c(1),
      K_9_23_20 = c(1),
      K_9_23_21 = c(1),
      K_9_23_22 = c(1),
      K_9_23_23 = c(0),
      K_9_23_24 = c(0),
      K_9_23_25 = c(1),
      K_9_23_27 = c(1),
      K_9_23_28 = c(1),
      K_9_23_29 = c(1),
      K_9_23_30 = c(1),
      K_9_23_31 = c(0),
      K_9_23_32 = c(1),
      K_9_23_33 = c(1),
      K_9_23_34 = c(0),
      K_9_23_35 = c(1),
      K_9_23_37 = c(1),
      K_9_23_38 = c(1),
      K_9_23_39 = c(1),
      K_9_23_40 = c(1),
      K_9_23_41 = c(0),
      K_9_23_42 = c(0),
      K_9_23_43 = c(1),
      K_9_23_45 = c(1),
      K_9_23_46 = c(1),
      K_9_23_47 = c(1),
      K_9_23_48 = c(1),
      K_9_23_49 = c(0),
      K_9_23_50 = c(1),
      K_9_23_51 = c(1),
      K_9_23_53 = c(0),
      K_9_23_54 = c(0),
      K_9_23_55 = c(0),
      K_9_23_56 = c(1),
      K_9_23_57 = c(0),
      K_9_23_66 = c(0),
      K_9_23_67 = c(1),
      K_9_23_68 = c(1),
      K_9_23_69 = c(1),
      K_9_23_70 = c(0),
      K_9_23_79 = c(0),
      K_9_23_80 = c(1),
      K_9_23_81 = c(1),
      K_9_23_82 = c(1),
      K_9_23_83 = c(0),
      K_9_23_92 = c(1),
      K_9_23_93 = c(1),
      K_9_23_94 = c(0),
      K_9_23_95 = c(0),
      K_9_23_96 = c(0)
    )
    
    sobY_v2_combined <- bind_cols(sobY_v2_data, sobY_key_df) %>% 
      mutate(Score_sobY_v2_SO_9_23_1 = ifelse(sobY_v2_SO_9_23_1 == K_9_23_1, 1, 0),
             Score_sobY_v2_SO_9_23_2 = ifelse(sobY_v2_SO_9_23_2 == K_9_23_2, 1, 0),
             Score_sobY_v2_SO_9_23_3 = ifelse(sobY_v2_SO_9_23_3 == K_9_23_3, 1, 0),
             Score_sobY_v2_SO_9_23_4 = ifelse(sobY_v2_SO_9_23_4 == K_9_23_4, 1, 0),
             Score_sobY_v2_SO_9_23_5 = ifelse(sobY_v2_SO_9_23_5 == K_9_23_5, 1, 0),
             Score_sobY_v2_SO_9_23_6 = ifelse(sobY_v2_SO_9_23_6 == K_9_23_6, 1, 0),
             Score_sobY_v2_SO_9_23_7 = ifelse(sobY_v2_SO_9_23_7 == K_9_23_7, 1, 0),
             
             Score_sobY_v2_SO_9_23_9 = ifelse(sobY_v2_SO_9_23_9 == K_9_23_9, 1, 0),
             Score_sobY_v2_SO_9_23_10 = ifelse(sobY_v2_SO_9_23_10 == K_9_23_10, 1, 0),
             Score_sobY_v2_SO_9_23_11 = ifelse(sobY_v2_SO_9_23_11 == K_9_23_11, 1, 0),
             Score_sobY_v2_SO_9_23_12 = ifelse(sobY_v2_SO_9_23_12 == K_9_23_12, 1, 0),
             Score_sobY_v2_SO_9_23_13 = ifelse(sobY_v2_SO_9_23_13 == K_9_23_13, 1, 0),
             Score_sobY_v2_SO_9_23_14 = ifelse(sobY_v2_SO_9_23_14 == K_9_23_14, 1, 0),
             Score_sobY_v2_SO_9_23_15 = ifelse(sobY_v2_SO_9_23_15 == K_9_23_15, 1, 0),
             Score_sobY_v2_SO_9_23_16 = ifelse(sobY_v2_SO_9_23_16 == K_9_23_16, 1, 0),
             Score_sobY_v2_SO_9_23_17 = ifelse(sobY_v2_SO_9_23_17 == K_9_23_17, 1, 0),
             
             Score_sobY_v2_SO_9_23_19 = ifelse(sobY_v2_SO_9_23_19 == K_9_23_19, 1, 0),
             Score_sobY_v2_SO_9_23_20 = ifelse(sobY_v2_SO_9_23_20 == K_9_23_20, 1, 0),
             Score_sobY_v2_SO_9_23_21 = ifelse(sobY_v2_SO_9_23_21 == K_9_23_21, 1, 0),
             Score_sobY_v2_SO_9_23_22 = ifelse(sobY_v2_SO_9_23_22 == K_9_23_22, 1, 0),
             Score_sobY_v2_SO_9_23_23 = ifelse(sobY_v2_SO_9_23_23 == K_9_23_23, 1, 0),
             Score_sobY_v2_SO_9_23_24 = ifelse(sobY_v2_SO_9_23_24 == K_9_23_24, 1, 0),
             Score_sobY_v2_SO_9_23_25 = ifelse(sobY_v2_SO_9_23_25 == K_9_23_25, 1, 0),
             
             Score_sobY_v2_SO_9_23_27 = ifelse(sobY_v2_SO_9_23_27 == K_9_23_27, 1, 0),
             Score_sobY_v2_SO_9_23_28 = ifelse(sobY_v2_SO_9_23_28 == K_9_23_28, 1, 0),
             Score_sobY_v2_SO_9_23_29 = ifelse(sobY_v2_SO_9_23_29 == K_9_23_29, 1, 0),
             Score_sobY_v2_SO_9_23_30 = ifelse(sobY_v2_SO_9_23_30 == K_9_23_30, 1, 0),
             Score_sobY_v2_SO_9_23_31 = ifelse(sobY_v2_SO_9_23_31 == K_9_23_31, 1, 0),
             Score_sobY_v2_SO_9_23_32 = ifelse(sobY_v2_SO_9_23_32 == K_9_23_32, 1, 0),
             Score_sobY_v2_SO_9_23_33 = ifelse(sobY_v2_SO_9_23_33 == K_9_23_33, 1, 0),
             Score_sobY_v2_SO_9_23_34 = ifelse(sobY_v2_SO_9_23_34 == K_9_23_34, 1, 0),
             Score_sobY_v2_SO_9_23_35 = ifelse(sobY_v2_SO_9_23_35 == K_9_23_35, 1, 0),
             
             Score_sobY_v2_SO_9_23_37 = ifelse(sobY_v2_SO_9_23_37 == K_9_23_37, 1, 0),
             Score_sobY_v2_SO_9_23_38 = ifelse(sobY_v2_SO_9_23_38 == K_9_23_38, 1, 0),
             Score_sobY_v2_SO_9_23_39 = ifelse(sobY_v2_SO_9_23_39 == K_9_23_39, 1, 0),
             Score_sobY_v2_SO_9_23_40 = ifelse(sobY_v2_SO_9_23_40 == K_9_23_40, 1, 0),
             Score_sobY_v2_SO_9_23_41 = ifelse(sobY_v2_SO_9_23_41 == K_9_23_41, 1, 0),
             Score_sobY_v2_SO_9_23_42 = ifelse(sobY_v2_SO_9_23_42 == K_9_23_42, 1, 0),
             Score_sobY_v2_SO_9_23_43 = ifelse(sobY_v2_SO_9_23_43 == K_9_23_43, 1, 0),
             
             Score_sobY_v2_SO_9_23_45 = ifelse(sobY_v2_SO_9_23_45 == K_9_23_45, 1, 0),
             Score_sobY_v2_SO_9_23_46 = ifelse(sobY_v2_SO_9_23_46 == K_9_23_46, 1, 0),
             Score_sobY_v2_SO_9_23_47 = ifelse(sobY_v2_SO_9_23_47 == K_9_23_47, 1, 0),
             Score_sobY_v2_SO_9_23_48 = ifelse(sobY_v2_SO_9_23_48 == K_9_23_48, 1, 0),
             Score_sobY_v2_SO_9_23_49 = ifelse(sobY_v2_SO_9_23_49 == K_9_23_49, 1, 0),
             Score_sobY_v2_SO_9_23_50 = ifelse(sobY_v2_SO_9_23_50 == K_9_23_50, 1, 0),
             Score_sobY_v2_SO_9_23_51 = ifelse(sobY_v2_SO_9_23_51 == K_9_23_51, 1, 0),
             
             Score_sobY_v2_SO_9_23_53 = ifelse(sobY_v2_SO_9_23_53 == K_9_23_53, 1, 0),
             Score_sobY_v2_SO_9_23_54 = ifelse(sobY_v2_SO_9_23_54 == K_9_23_54, 1, 0),
             Score_sobY_v2_SO_9_23_55 = ifelse(sobY_v2_SO_9_23_55 == K_9_23_55, 1, 0),
             Score_sobY_v2_SO_9_23_56 = ifelse(sobY_v2_SO_9_23_56 == K_9_23_56, 1, 0),
             Score_sobY_v2_SO_9_23_57 = ifelse(sobY_v2_SO_9_23_57 == K_9_23_57, 1, 0),
             
             Score_sobY_v2_SO_9_23_66 = ifelse(sobY_v2_SO_9_23_66 == K_9_23_66, 1, 0),
             Score_sobY_v2_SO_9_23_67 = ifelse(sobY_v2_SO_9_23_67 == K_9_23_67, 1, 0),
             Score_sobY_v2_SO_9_23_68 = ifelse(sobY_v2_SO_9_23_68 == K_9_23_68, 1, 0),
             Score_sobY_v2_SO_9_23_69 = ifelse(sobY_v2_SO_9_23_69 == K_9_23_69, 1, 0),
             Score_sobY_v2_SO_9_23_70 = ifelse(sobY_v2_SO_9_23_70 == K_9_23_70, 1, 0),
             
             Score_sobY_v2_SO_9_23_79 = ifelse(sobY_v2_SO_9_23_79 == K_9_23_79, 1, 0),
             Score_sobY_v2_SO_9_23_80 = ifelse(sobY_v2_SO_9_23_80 == K_9_23_80, 1, 0),
             Score_sobY_v2_SO_9_23_81 = ifelse(sobY_v2_SO_9_23_81 == K_9_23_81, 1, 0),
             Score_sobY_v2_SO_9_23_82 = ifelse(sobY_v2_SO_9_23_82 == K_9_23_82, 1, 0),
             Score_sobY_v2_SO_9_23_83 = ifelse(sobY_v2_SO_9_23_83 == K_9_23_83, 1, 0),
             
             Score_sobY_v2_SO_9_23_92 = ifelse(sobY_v2_SO_9_23_92 == K_9_23_92, 1, 0),
             Score_sobY_v2_SO_9_23_93 = ifelse(sobY_v2_SO_9_23_93 == K_9_23_93, 1, 0),
             Score_sobY_v2_SO_9_23_94 = ifelse(sobY_v2_SO_9_23_94 == K_9_23_94, 1, 0),
             Score_sobY_v2_SO_9_23_95 = ifelse(sobY_v2_SO_9_23_95 == K_9_23_95, 1, 0),
             Score_sobY_v2_SO_9_23_96 = ifelse(sobY_v2_SO_9_23_96 == K_9_23_96, 1, 0),
             
             Score_sobY_v2 = sum(Score_sobY_v2_SO_9_23_1, Score_sobY_v2_SO_9_23_2,       
                                 Score_sobY_v2_SO_9_23_3,       
                                 Score_sobY_v2_SO_9_23_4,       
                                 Score_sobY_v2_SO_9_23_5,       
                                 Score_sobY_v2_SO_9_23_6, Score_sobY_v2_SO_9_23_7,
                                 
                                 Score_sobY_v2_SO_9_23_9,       
                                 Score_sobY_v2_SO_9_23_10,       
                                 Score_sobY_v2_SO_9_23_11,       
                                 Score_sobY_v2_SO_9_23_12,       
                                 Score_sobY_v2_SO_9_23_13,       
                                 Score_sobY_v2_SO_9_23_14,       
                                 Score_sobY_v2_SO_9_23_15,       
                                 Score_sobY_v2_SO_9_23_16,       
                                 Score_sobY_v2_SO_9_23_17,       
                                 
                                 Score_sobY_v2_SO_9_23_19,       
                                 Score_sobY_v2_SO_9_23_20,       
                                 Score_sobY_v2_SO_9_23_21,       
                                 Score_sobY_v2_SO_9_23_22,       
                                 Score_sobY_v2_SO_9_23_23,       
                                 Score_sobY_v2_SO_9_23_24,       
                                 Score_sobY_v2_SO_9_23_25,       
                                 
                                 Score_sobY_v2_SO_9_23_27,       
                                 Score_sobY_v2_SO_9_23_28,       
                                 Score_sobY_v2_SO_9_23_29,       
                                 Score_sobY_v2_SO_9_23_30,       
                                 Score_sobY_v2_SO_9_23_31,       
                                 Score_sobY_v2_SO_9_23_32,       
                                 Score_sobY_v2_SO_9_23_33,       
                                 Score_sobY_v2_SO_9_23_34,       
                                 Score_sobY_v2_SO_9_23_35,       
                                 
                                 Score_sobY_v2_SO_9_23_37,       
                                 Score_sobY_v2_SO_9_23_38,       
                                 Score_sobY_v2_SO_9_23_39,       
                                 Score_sobY_v2_SO_9_23_40,       
                                 Score_sobY_v2_SO_9_23_41,       
                                 Score_sobY_v2_SO_9_23_42,       
                                 Score_sobY_v2_SO_9_23_43,       
                                 
                                 Score_sobY_v2_SO_9_23_45,       
                                 Score_sobY_v2_SO_9_23_46,       
                                 Score_sobY_v2_SO_9_23_47,       
                                 Score_sobY_v2_SO_9_23_48,       
                                 Score_sobY_v2_SO_9_23_49,       
                                 Score_sobY_v2_SO_9_23_50,       
                                 Score_sobY_v2_SO_9_23_51,       
                                 
                                 Score_sobY_v2_SO_9_23_53,       
                                 Score_sobY_v2_SO_9_23_54,       
                                 Score_sobY_v2_SO_9_23_55,       
                                 Score_sobY_v2_SO_9_23_56,       
                                 Score_sobY_v2_SO_9_23_57,       
                                 
                                 Score_sobY_v2_SO_9_23_66,       
                                 Score_sobY_v2_SO_9_23_67,       
                                 Score_sobY_v2_SO_9_23_68,       
                                 Score_sobY_v2_SO_9_23_69,       
                                 Score_sobY_v2_SO_9_23_70,       
                                 
                                 Score_sobY_v2_SO_9_23_79,       
                                 Score_sobY_v2_SO_9_23_80,       
                                 Score_sobY_v2_SO_9_23_81,       
                                 Score_sobY_v2_SO_9_23_82,       
                                 Score_sobY_v2_SO_9_23_83,       
                                 
                                 Score_sobY_v2_SO_9_23_92, Score_sobY_v2_SO_9_23_93, 
                                 Score_sobY_v2_SO_9_23_94,
                                 Score_sobY_v2_SO_9_23_95, Score_sobY_v2_SO_9_23_96
             ),
             Score_sobY_v2 = round(Score_sobY_v2 / 66, 3)
      ) 
    
    sobY_v2_upload <- sobY_v2_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("sobY_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response", 66), rep("Answer", 66), rep("Score", 66), "Overall")
      ) %>%
      rename(name = text_sobY_v2_person,
             site = text_sobY_v2_site,
             date = text_sobY_v2_date) %>% 
      filter(key != "Answer")
    
    sobY_v2_upload <- as.data.frame(sobY_v2_upload)
    
    sheet_append(ss = sheet_id,
                 data = sobY_v2_upload,
                 sheet = "main")
    
    return(sobY_v2_combined)
    
  })
  
  output$sobY_v2_incorrect <- renderTable({
    sobY_v2_data <- sobY_v2_values()
    
    pull_cols <- sobY_v2_data %>% 
      select(starts_with("sobY_v2_SO_9_23_"), starts_with("K_")) %>% 
      colnames()
    
    sobY_v2_data[ ,pull_cols] <- lapply(sobY_v2_data[ ,pull_cols], factor, levels = c(0, 1), labels = c("No", "Yes"))
    
    return_sobY_v2 <- sobY_v2_data %>%
      mutate_all(as.character) %>%
      select(-c(Score_sobY_v2)) %>%
      pivot_longer(.,
                   cols = c(starts_with("sobY_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "Question",
                   values_to = "Score"
      ) %>%
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13", "Q14", "Q15", "Q16", "Q17", "Q18", 
                         "Q19", "Q20", "Q21", "Q22", "Q23", "Q24", 
                         "Q25", "Q26", "Q27", "Q28", "Q29", "Q30", 
                         "Q31", "Q32", "Q33", "Q34", "Q35", "Q36",
                         "Q37", "Q38", "Q39", "Q40", "Q41", "Q42",
                         "Q43", "Q44", "Q45", "Q46", "Q47", "Q48", 
                         "Q49", "Q50", "Q51", "Q52", "Q53", "Q54", 
                         "Q55", "Q56", "Q57", "Q58", "Q59", "Q60",
                         "Q61", "Q62", "Q63", "Q64", "Q65", "Q66"), 3)),
             type = c(rep("Response", 66), rep("Answer", 66), rep("Score", 66))
      ) %>%
      select(-c(task_id:text_sobY_v2_date, Question)) %>%
      rename(Question = Q) %>%
      pivot_wider(.,
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>%
      select(Question, Response, Answer, Score) %>%
      filter(Score != 1)
    
    return(return_sobY_v2)
  })
  
  output$sobY_v2_score <- renderText({
    
    sobY_v2_data <- sobY_v2_values()
    
    percent_correct <- sobY_v2_data$Score_sobY_v2 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  
  

## Social Observational (older) data ------
  ### Video 1 ------
  sobO_v1_values <- eventReactive(input$sobO_v1_submit, {
    
    sobO_v1_data <- data.frame(
      task_id = c("sobO_v1"),
      text_sobO_v1_person = c(input$text_sobO_v1_person),
      text_sobO_v1_site = c(input$text_sobO_v1_site),
      text_sobO_v1_date = Sys.time(),#format(as.Date(input$text_sobO_v1_date, origin="2023-01-01")),

      sobO_v1_SO_24_48_1 = c(input$radio_sobO_v1_SO_24_48_1),
      sobO_v1_SO_24_48_2 = c(input$radio_sobO_v1_SO_24_48_2),
      sobO_v1_SO_24_48_3 = c(input$radio_sobO_v1_SO_24_48_3),
      sobO_v1_SO_24_48_4 = c(input$radio_sobO_v1_SO_24_48_4),
      sobO_v1_SO_24_48_5 = c(input$radio_sobO_v1_SO_24_48_5),
      sobO_v1_SO_24_48_6 = c(input$radio_sobO_v1_SO_24_48_6),
      
      sobO_v1_SO_24_48_7 = c(input$radio_sobO_v1_SO_24_48_7),
      sobO_v1_SO_24_48_8 = c(input$radio_sobO_v1_SO_24_48_8),
      sobO_v1_SO_24_48_9 = c(input$radio_sobO_v1_SO_24_48_9),
      sobO_v1_SO_24_48_10 = c(input$radio_sobO_v1_SO_24_48_10),
      sobO_v1_SO_24_48_11 = c(input$radio_sobO_v1_SO_24_48_11),
      
      sobO_v1_SO_24_48_12 = c(input$radio_sobO_v1_SO_24_48_12),
      sobO_v1_SO_24_48_13 = c(input$radio_sobO_v1_SO_24_48_13),
      sobO_v1_SO_24_48_14 = c(input$radio_sobO_v1_SO_24_48_14),
      sobO_v1_SO_24_48_15 = c(input$radio_sobO_v1_SO_24_48_15),
      sobO_v1_SO_24_48_16 = c(input$radio_sobO_v1_SO_24_48_16),
      sobO_v1_SO_24_48_17 = c(input$radio_sobO_v1_SO_24_48_17),
      sobO_v1_SO_24_48_18 = c(input$radio_sobO_v1_SO_24_48_18),
      sobO_v1_SO_24_48_19 = c(input$radio_sobO_v1_SO_24_48_19),
      
      sobO_v1_SO_24_48_20 = c(input$radio_sobO_v1_SO_24_48_20),
      sobO_v1_SO_24_48_21 = c(input$radio_sobO_v1_SO_24_48_21),
      sobO_v1_SO_24_48_22 = c(input$radio_sobO_v1_SO_24_48_22),
      sobO_v1_SO_24_48_23 = c(input$radio_sobO_v1_SO_24_48_23),
      
      sobO_v1_SO_24_48_24 = c(input$radio_sobO_v1_SO_24_48_24),
      sobO_v1_SO_24_48_25 = c(input$radio_sobO_v1_SO_24_48_25),
      sobO_v1_SO_24_48_26 = c(input$radio_sobO_v1_SO_24_48_26),
      sobO_v1_SO_24_48_27 = c(input$radio_sobO_v1_SO_24_48_27),
      sobO_v1_SO_24_48_28 = c(input$radio_sobO_v1_SO_24_48_28),
      sobO_v1_SO_24_48_29 = c(input$radio_sobO_v1_SO_24_48_29),
      sobO_v1_SO_24_48_30 = c(input$radio_sobO_v1_SO_24_48_30),
      sobO_v1_SO_24_48_31 = c(input$radio_sobO_v1_SO_24_48_31)
      
    ) %>%
      mutate(
        sobO_v1_SO_24_48_1 = as.numeric(sobO_v1_SO_24_48_1),
        sobO_v1_SO_24_48_2 = as.numeric(sobO_v1_SO_24_48_2),
        sobO_v1_SO_24_48_3 = as.numeric(sobO_v1_SO_24_48_3),
        sobO_v1_SO_24_48_4 = as.numeric(sobO_v1_SO_24_48_4),
        sobO_v1_SO_24_48_5 = as.numeric(sobO_v1_SO_24_48_5),
        sobO_v1_SO_24_48_6 = as.numeric(sobO_v1_SO_24_48_6),
        
        sobO_v1_SO_24_48_7 = as.numeric(sobO_v1_SO_24_48_7),
        sobO_v1_SO_24_48_8 = as.numeric(sobO_v1_SO_24_48_8),
        sobO_v1_SO_24_48_9 = as.numeric(sobO_v1_SO_24_48_9),
        sobO_v1_SO_24_48_10 = as.numeric(sobO_v1_SO_24_48_10),
        sobO_v1_SO_24_48_11 = as.numeric(sobO_v1_SO_24_48_11),
        
        sobO_v1_SO_24_48_12 = as.numeric(sobO_v1_SO_24_48_12),
        sobO_v1_SO_24_48_13 = as.numeric(sobO_v1_SO_24_48_13),
        sobO_v1_SO_24_48_14 = as.numeric(sobO_v1_SO_24_48_14),
        sobO_v1_SO_24_48_15 = as.numeric(sobO_v1_SO_24_48_15),
        sobO_v1_SO_24_48_16 = as.numeric(sobO_v1_SO_24_48_16),
        sobO_v1_SO_24_48_17 = as.numeric(sobO_v1_SO_24_48_17),
        sobO_v1_SO_24_48_18 = as.numeric(sobO_v1_SO_24_48_18),
        sobO_v1_SO_24_48_19 = as.numeric(sobO_v1_SO_24_48_19),
        
        sobO_v1_SO_24_48_20 = as.numeric(sobO_v1_SO_24_48_20),
        sobO_v1_SO_24_48_21 = as.numeric(sobO_v1_SO_24_48_21),
        sobO_v1_SO_24_48_22 = as.numeric(sobO_v1_SO_24_48_22),
        sobO_v1_SO_24_48_23 = as.numeric(sobO_v1_SO_24_48_23),
        
        sobO_v1_SO_24_48_24 = as.numeric(sobO_v1_SO_24_48_24),
        sobO_v1_SO_24_48_25 = as.numeric(sobO_v1_SO_24_48_25),
        sobO_v1_SO_24_48_26 = as.numeric(sobO_v1_SO_24_48_26),
        sobO_v1_SO_24_48_27 = as.numeric(sobO_v1_SO_24_48_27),
        sobO_v1_SO_24_48_28 = as.numeric(sobO_v1_SO_24_48_28),
        sobO_v1_SO_24_48_29 = as.numeric(sobO_v1_SO_24_48_29),
        sobO_v1_SO_24_48_30 = as.numeric(sobO_v1_SO_24_48_30),
        sobO_v1_SO_24_48_31 = as.numeric(sobO_v1_SO_24_48_31)
      )
    
    sobO_key_df <- data.frame(
      K_24_48_1 = c(1),
      K_24_48_2 = c(1),
      K_24_48_3 = c(0),
      K_24_48_4 = c(1),
      K_24_48_5 = c(0),
      K_24_48_6 = c(1),
      K_24_48_7 = c(1),
      K_24_48_8 = c(1),
      K_24_48_9 = c(0),
      K_24_48_10 = c(0),
      K_24_48_11 = c(1),
      K_24_48_12 = c(0),
      K_24_48_13 = c(0),
      K_24_48_14 = c(0),
      K_24_48_15 = c(0),
      K_24_48_16 = c(0),
      K_24_48_17 = c(0),
      K_24_48_18 = c(0),
      K_24_48_19 = c(0),
      K_24_48_20 = c(1),
      K_24_48_21 = c(0),
      K_24_48_22 = c(0),
      K_24_48_23 = c(1),
      K_24_48_24 = c(1),
      K_24_48_25 = c(1),
      K_24_48_26 = c(1),
      K_24_48_27 = c(1),
      K_24_48_28 = c(0),
      K_24_48_29 = c(0),
      K_24_48_30 = c(1),
      K_24_48_31 = c(1)
    )
    
    sobO_v1_combined <- bind_cols(sobO_v1_data, sobO_key_df) %>% 
      mutate(Score_sobO_v1_SO_24_48_1 = ifelse(sobO_v1_SO_24_48_1 == K_24_48_1, 1, 0),
             Score_sobO_v1_SO_24_48_2 = ifelse(sobO_v1_SO_24_48_2 == K_24_48_2, 1, 0),
             Score_sobO_v1_SO_24_48_3 = ifelse(sobO_v1_SO_24_48_3 == K_24_48_3, 1, 0),
             Score_sobO_v1_SO_24_48_4 = ifelse(sobO_v1_SO_24_48_4 == K_24_48_4, 1, 0),
             Score_sobO_v1_SO_24_48_5 = ifelse(sobO_v1_SO_24_48_5 == K_24_48_5, 1, 0),
             Score_sobO_v1_SO_24_48_6 = ifelse(sobO_v1_SO_24_48_6 == K_24_48_6, 1, 0),
             Score_sobO_v1_SO_24_48_7 = ifelse(sobO_v1_SO_24_48_7 == K_24_48_7, 1, 0),
             Score_sobO_v1_SO_24_48_8 = ifelse(sobO_v1_SO_24_48_8 == K_24_48_8, 1, 0),
             Score_sobO_v1_SO_24_48_9 = ifelse(sobO_v1_SO_24_48_9 == K_24_48_9, 1, 0),
             Score_sobO_v1_SO_24_48_10 = ifelse(sobO_v1_SO_24_48_10 == K_24_48_10, 1, 0),
             Score_sobO_v1_SO_24_48_11 = ifelse(sobO_v1_SO_24_48_11 == K_24_48_11, 1, 0),
             Score_sobO_v1_SO_24_48_12 = ifelse(sobO_v1_SO_24_48_12 == K_24_48_12, 1, 0),
             Score_sobO_v1_SO_24_48_13 = ifelse(sobO_v1_SO_24_48_13 == K_24_48_13, 1, 0),
             Score_sobO_v1_SO_24_48_14 = ifelse(sobO_v1_SO_24_48_14 == K_24_48_14, 1, 0),
             Score_sobO_v1_SO_24_48_15 = ifelse(sobO_v1_SO_24_48_15 == K_24_48_15, 1, 0),
             Score_sobO_v1_SO_24_48_16 = ifelse(sobO_v1_SO_24_48_16 == K_24_48_16, 1, 0),
             Score_sobO_v1_SO_24_48_17 = ifelse(sobO_v1_SO_24_48_17 == K_24_48_17, 1, 0),
             Score_sobO_v1_SO_24_48_18 = ifelse(sobO_v1_SO_24_48_18 == K_24_48_18, 1, 0),
             Score_sobO_v1_SO_24_48_19 = ifelse(sobO_v1_SO_24_48_19 == K_24_48_19, 1, 0),
             
             Score_sobO_v1_SO_24_48_20 = ifelse(sobO_v1_SO_24_48_20 == K_24_48_20, 1, 0),
             Score_sobO_v1_SO_24_48_21 = ifelse(sobO_v1_SO_24_48_21 == K_24_48_21, 1, 0),
             Score_sobO_v1_SO_24_48_22 = ifelse(sobO_v1_SO_24_48_22 == K_24_48_22, 1, 0),
             Score_sobO_v1_SO_24_48_23 = ifelse(sobO_v1_SO_24_48_23 == K_24_48_23, 1, 0),
             Score_sobO_v1_SO_24_48_24 = ifelse(sobO_v1_SO_24_48_24 == K_24_48_24, 1, 0),
             Score_sobO_v1_SO_24_48_25 = ifelse(sobO_v1_SO_24_48_25 == K_24_48_25, 1, 0),
             Score_sobO_v1_SO_24_48_26 = ifelse(sobO_v1_SO_24_48_26 == K_24_48_26, 1, 0),
             Score_sobO_v1_SO_24_48_27 = ifelse(sobO_v1_SO_24_48_27 == K_24_48_27, 1, 0),
             Score_sobO_v1_SO_24_48_28 = ifelse(sobO_v1_SO_24_48_28 == K_24_48_28, 1, 0),
             Score_sobO_v1_SO_24_48_29 = ifelse(sobO_v1_SO_24_48_29 == K_24_48_29, 1, 0),
             Score_sobO_v1_SO_24_48_30 = ifelse(sobO_v1_SO_24_48_30 == K_24_48_30, 1, 0),
             Score_sobO_v1_SO_24_48_31 = ifelse(sobO_v1_SO_24_48_31 == K_24_48_31, 1, 0),
             
             Score_sobO_v1 = sum(Score_sobO_v1_SO_24_48_1, Score_sobO_v1_SO_24_48_2, 
                                 Score_sobO_v1_SO_24_48_3, Score_sobO_v1_SO_24_48_4,
                                 Score_sobO_v1_SO_24_48_5, Score_sobO_v1_SO_24_48_6,
                                 Score_sobO_v1_SO_24_48_7, Score_sobO_v1_SO_24_48_8,
                                 Score_sobO_v1_SO_24_48_9, Score_sobO_v1_SO_24_48_10,
                                 Score_sobO_v1_SO_24_48_11, Score_sobO_v1_SO_24_48_12,
                                 Score_sobO_v1_SO_24_48_13, Score_sobO_v1_SO_24_48_14,
                                 Score_sobO_v1_SO_24_48_15, Score_sobO_v1_SO_24_48_16,
                                 Score_sobO_v1_SO_24_48_17, Score_sobO_v1_SO_24_48_18,
                                 Score_sobO_v1_SO_24_48_19, Score_sobO_v1_SO_24_48_20,
                                 Score_sobO_v1_SO_24_48_21, Score_sobO_v1_SO_24_48_22,
                                 Score_sobO_v1_SO_24_48_23, Score_sobO_v1_SO_24_48_24,
                                 Score_sobO_v1_SO_24_48_25, Score_sobO_v1_SO_24_48_26,
                                 Score_sobO_v1_SO_24_48_27, Score_sobO_v1_SO_24_48_28,
                                 Score_sobO_v1_SO_24_48_29, Score_sobO_v1_SO_24_48_30,
                                 Score_sobO_v1_SO_24_48_31
             ),
             Score_sobO_v1 = round(Score_sobO_v1 / 31, 3)
      ) 
    
    sobO_v1_upload <- sobO_v1_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("sobO_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response", 31), rep("Answer", 31), rep("Score", 31), "Overall")
      ) %>%
      rename(name = text_sobO_v1_person,
             site = text_sobO_v1_site,
             date = text_sobO_v1_date) %>% 
      filter(key != "Answer")
    
    sobO_v1_upload <- as.data.frame(sobO_v1_upload)
    
    sheet_append(ss = sheet_id,
                 data = sobO_v1_upload,
                 sheet = "main")
    
    return(sobO_v1_combined)
    
  })
  
  output$sobO_v1_incorrect <- renderTable({
    sobO_v1_data <- sobO_v1_values()
    
    pull_cols <- sobO_v1_data %>% 
      select(starts_with("sobO_v1_SO_24_48_"), starts_with("K_")) %>% 
      colnames()
    
    sobO_v1_data[ ,pull_cols] <- lapply(sobO_v1_data[ ,pull_cols], factor, levels = c(0, 1), labels = c("No", "Yes"))
    
    return_sobO_v1 <- sobO_v1_data %>%
      mutate_all(as.character) %>%
      select(-c(Score_sobO_v1)) %>%
      pivot_longer(.,
                   cols = c(starts_with("sobO_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "Question",
                   values_to = "Score"
      ) %>%
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13", "Q14", "Q15", "Q16", "Q17", "Q18", 
                         "Q19", "Q20", "Q21", "Q22", "Q23", "Q24", 
                         "Q25", "Q26", "Q27", "Q28", "Q29", "Q30", 
                         "Q31"), 3)),
             type = c(rep("Response", 31), rep("Answer", 31), rep("Score", 31))
      ) %>%
      select(-c(task_id:text_sobO_v1_date, Question)) %>%
      rename(Question = Q) %>%
      pivot_wider(.,
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>%
      select(Question, Response, Answer, Score) %>%
      filter(Score != 1)
    
    return(return_sobO_v1)
  })
  
  output$sobO_v1_score <- renderText({
    
    sobO_v1_data <- sobO_v1_values()
    
    percent_correct <- sobO_v1_data$Score_sobO_v1 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  ### Video 2 ------
  sobO_v2_values <- eventReactive(input$sobO_v2_submit, {
    
    sobO_v2_data <- data.frame(
      task_id = c("sobO_v2"),
      text_sobO_v2_person = c(input$text_sobO_v2_person),
      text_sobO_v2_site = c(input$text_sobO_v2_site),
      text_sobO_v2_date = Sys.time(),#format(as.Date(input$text_sobO_v2_date, origin="2023-01-01")),
      
      sobO_v2_SO_24_48_1 = c(input$radio_sobO_v2_SO_24_48_1),
      sobO_v2_SO_24_48_2 = c(input$radio_sobO_v2_SO_24_48_2),
      sobO_v2_SO_24_48_3 = c(input$radio_sobO_v2_SO_24_48_3),
      sobO_v2_SO_24_48_4 = c(input$radio_sobO_v2_SO_24_48_4),
      sobO_v2_SO_24_48_5 = c(input$radio_sobO_v2_SO_24_48_5),
      sobO_v2_SO_24_48_6 = c(input$radio_sobO_v2_SO_24_48_6),
      
      sobO_v2_SO_24_48_7 = c(input$radio_sobO_v2_SO_24_48_7),
      sobO_v2_SO_24_48_8 = c(input$radio_sobO_v2_SO_24_48_8),
      sobO_v2_SO_24_48_9 = c(input$radio_sobO_v2_SO_24_48_9),
      sobO_v2_SO_24_48_10 = c(input$radio_sobO_v2_SO_24_48_10),
      sobO_v2_SO_24_48_11 = c(input$radio_sobO_v2_SO_24_48_11),
      
      sobO_v2_SO_24_48_12 = c(input$radio_sobO_v2_SO_24_48_12),
      sobO_v2_SO_24_48_13 = c(input$radio_sobO_v2_SO_24_48_13),
      sobO_v2_SO_24_48_14 = c(input$radio_sobO_v2_SO_24_48_14),
      sobO_v2_SO_24_48_15 = c(input$radio_sobO_v2_SO_24_48_15),
      sobO_v2_SO_24_48_16 = c(input$radio_sobO_v2_SO_24_48_16),
      sobO_v2_SO_24_48_17 = c(input$radio_sobO_v2_SO_24_48_17),
      sobO_v2_SO_24_48_18 = c(input$radio_sobO_v2_SO_24_48_18),
      sobO_v2_SO_24_48_19 = c(input$radio_sobO_v2_SO_24_48_19),
      
      sobO_v2_SO_24_48_20 = c(input$radio_sobO_v2_SO_24_48_20),
      sobO_v2_SO_24_48_21 = c(input$radio_sobO_v2_SO_24_48_21),
      sobO_v2_SO_24_48_22 = c(input$radio_sobO_v2_SO_24_48_22),
      sobO_v2_SO_24_48_23 = c(input$radio_sobO_v2_SO_24_48_23),
      
      sobO_v2_SO_24_48_24 = c(input$radio_sobO_v2_SO_24_48_24),
      sobO_v2_SO_24_48_25 = c(input$radio_sobO_v2_SO_24_48_25),
      sobO_v2_SO_24_48_26 = c(input$radio_sobO_v2_SO_24_48_26),
      sobO_v2_SO_24_48_27 = c(input$radio_sobO_v2_SO_24_48_27),
      sobO_v2_SO_24_48_28 = c(input$radio_sobO_v2_SO_24_48_28),
      sobO_v2_SO_24_48_29 = c(input$radio_sobO_v2_SO_24_48_29),
      sobO_v2_SO_24_48_30 = c(input$radio_sobO_v2_SO_24_48_30),
      sobO_v2_SO_24_48_31 = c(input$radio_sobO_v2_SO_24_48_31)
      
    ) %>%
      mutate(
        sobO_v2_SO_24_48_1 = as.numeric(sobO_v2_SO_24_48_1),
        sobO_v2_SO_24_48_2 = as.numeric(sobO_v2_SO_24_48_2),
        sobO_v2_SO_24_48_3 = as.numeric(sobO_v2_SO_24_48_3),
        sobO_v2_SO_24_48_4 = as.numeric(sobO_v2_SO_24_48_4),
        sobO_v2_SO_24_48_5 = as.numeric(sobO_v2_SO_24_48_5),
        sobO_v2_SO_24_48_6 = as.numeric(sobO_v2_SO_24_48_6),
        
        sobO_v2_SO_24_48_7 = as.numeric(sobO_v2_SO_24_48_7),
        sobO_v2_SO_24_48_8 = as.numeric(sobO_v2_SO_24_48_8),
        sobO_v2_SO_24_48_9 = as.numeric(sobO_v2_SO_24_48_9),
        sobO_v2_SO_24_48_10 = as.numeric(sobO_v2_SO_24_48_10),
        sobO_v2_SO_24_48_11 = as.numeric(sobO_v2_SO_24_48_11),
        
        sobO_v2_SO_24_48_12 = as.numeric(sobO_v2_SO_24_48_12),
        sobO_v2_SO_24_48_13 = as.numeric(sobO_v2_SO_24_48_13),
        sobO_v2_SO_24_48_14 = as.numeric(sobO_v2_SO_24_48_14),
        sobO_v2_SO_24_48_15 = as.numeric(sobO_v2_SO_24_48_15),
        sobO_v2_SO_24_48_16 = as.numeric(sobO_v2_SO_24_48_16),
        sobO_v2_SO_24_48_17 = as.numeric(sobO_v2_SO_24_48_17),
        sobO_v2_SO_24_48_18 = as.numeric(sobO_v2_SO_24_48_18),
        sobO_v2_SO_24_48_19 = as.numeric(sobO_v2_SO_24_48_19),
        
        sobO_v2_SO_24_48_20 = as.numeric(sobO_v2_SO_24_48_20),
        sobO_v2_SO_24_48_21 = as.numeric(sobO_v2_SO_24_48_21),
        sobO_v2_SO_24_48_22 = as.numeric(sobO_v2_SO_24_48_22),
        sobO_v2_SO_24_48_23 = as.numeric(sobO_v2_SO_24_48_23),
        
        sobO_v2_SO_24_48_24 = as.numeric(sobO_v2_SO_24_48_24),
        sobO_v2_SO_24_48_25 = as.numeric(sobO_v2_SO_24_48_25),
        sobO_v2_SO_24_48_26 = as.numeric(sobO_v2_SO_24_48_26),
        sobO_v2_SO_24_48_27 = as.numeric(sobO_v2_SO_24_48_27),
        sobO_v2_SO_24_48_28 = as.numeric(sobO_v2_SO_24_48_28),
        sobO_v2_SO_24_48_29 = as.numeric(sobO_v2_SO_24_48_29),
        sobO_v2_SO_24_48_30 = as.numeric(sobO_v2_SO_24_48_30),
        sobO_v2_SO_24_48_31 = as.numeric(sobO_v2_SO_24_48_31)
      )
    
    sobO_key_df <- data.frame(
      K_24_48_1 = c(1),
      K_24_48_2 = c(1),
      K_24_48_3 = c(0),
      K_24_48_4 = c(1),
      K_24_48_5 = c(0),
      K_24_48_6 = c(0),
      K_24_48_7 = c(1),
      K_24_48_8 = c(0),
      K_24_48_9 = c(0),
      K_24_48_10 = c(1),
      K_24_48_11 = c(0),
      K_24_48_12 = c(0),
      K_24_48_13 = c(0),
      K_24_48_14 = c(1),
      K_24_48_15 = c(0),
      K_24_48_16 = c(0),
      K_24_48_17 = c(0),
      K_24_48_18 = c(1),
      K_24_48_19 = c(0),
      K_24_48_20 = c(0),
      K_24_48_21 = c(0),
      K_24_48_22 = c(0),
      K_24_48_23 = c(0),
      K_24_48_24 = c(1),
      K_24_48_25 = c(1),
      K_24_48_26 = c(1),
      K_24_48_27 = c(0),
      K_24_48_28 = c(0),
      K_24_48_29 = c(0),
      K_24_48_30 = c(1),
      K_24_48_31 = c(0)
    )
    
    sobO_v2_combined <- bind_cols(sobO_v2_data, sobO_key_df) %>% 
      mutate(Score_sobO_v2_SO_24_48_1 = ifelse(sobO_v2_SO_24_48_1 == K_24_48_1, 1, 0),
             Score_sobO_v2_SO_24_48_2 = ifelse(sobO_v2_SO_24_48_2 == K_24_48_2, 1, 0),
             Score_sobO_v2_SO_24_48_3 = ifelse(sobO_v2_SO_24_48_3 == K_24_48_3, 1, 0),
             Score_sobO_v2_SO_24_48_4 = ifelse(sobO_v2_SO_24_48_4 == K_24_48_4, 1, 0),
             Score_sobO_v2_SO_24_48_5 = ifelse(sobO_v2_SO_24_48_5 == K_24_48_5, 1, 0),
             Score_sobO_v2_SO_24_48_6 = ifelse(sobO_v2_SO_24_48_6 == K_24_48_6, 1, 0),
             Score_sobO_v2_SO_24_48_7 = ifelse(sobO_v2_SO_24_48_7 == K_24_48_7, 1, 0),
             Score_sobO_v2_SO_24_48_8 = ifelse(sobO_v2_SO_24_48_8 == K_24_48_8, 1, 0),
             Score_sobO_v2_SO_24_48_9 = ifelse(sobO_v2_SO_24_48_9 == K_24_48_9, 1, 0),
             Score_sobO_v2_SO_24_48_10 = ifelse(sobO_v2_SO_24_48_10 == K_24_48_10, 1, 0),
             Score_sobO_v2_SO_24_48_11 = ifelse(sobO_v2_SO_24_48_11 == K_24_48_11, 1, 0),
             Score_sobO_v2_SO_24_48_12 = ifelse(sobO_v2_SO_24_48_12 == K_24_48_12, 1, 0),
             Score_sobO_v2_SO_24_48_13 = ifelse(sobO_v2_SO_24_48_13 == K_24_48_13, 1, 0),
             Score_sobO_v2_SO_24_48_14 = ifelse(sobO_v2_SO_24_48_14 == K_24_48_14, 1, 0),
             Score_sobO_v2_SO_24_48_15 = ifelse(sobO_v2_SO_24_48_15 == K_24_48_15, 1, 0),
             Score_sobO_v2_SO_24_48_16 = ifelse(sobO_v2_SO_24_48_16 == K_24_48_16, 1, 0),
             Score_sobO_v2_SO_24_48_17 = ifelse(sobO_v2_SO_24_48_17 == K_24_48_17, 1, 0),
             Score_sobO_v2_SO_24_48_18 = ifelse(sobO_v2_SO_24_48_18 == K_24_48_18, 1, 0),
             Score_sobO_v2_SO_24_48_19 = ifelse(sobO_v2_SO_24_48_19 == K_24_48_19, 1, 0),
             
             Score_sobO_v2_SO_24_48_20 = ifelse(sobO_v2_SO_24_48_20 == K_24_48_20, 1, 0),
             Score_sobO_v2_SO_24_48_21 = ifelse(sobO_v2_SO_24_48_21 == K_24_48_21, 1, 0),
             Score_sobO_v2_SO_24_48_22 = ifelse(sobO_v2_SO_24_48_22 == K_24_48_22, 1, 0),
             Score_sobO_v2_SO_24_48_23 = ifelse(sobO_v2_SO_24_48_23 == K_24_48_23, 1, 0),
             Score_sobO_v2_SO_24_48_24 = ifelse(sobO_v2_SO_24_48_24 == K_24_48_24, 1, 0),
             Score_sobO_v2_SO_24_48_25 = ifelse(sobO_v2_SO_24_48_25 == K_24_48_25, 1, 0),
             Score_sobO_v2_SO_24_48_26 = ifelse(sobO_v2_SO_24_48_26 == K_24_48_26, 1, 0),
             Score_sobO_v2_SO_24_48_27 = ifelse(sobO_v2_SO_24_48_27 == K_24_48_27, 1, 0),
             Score_sobO_v2_SO_24_48_28 = ifelse(sobO_v2_SO_24_48_28 == K_24_48_28, 1, 0),
             Score_sobO_v2_SO_24_48_29 = ifelse(sobO_v2_SO_24_48_29 == K_24_48_29, 1, 0),
             Score_sobO_v2_SO_24_48_30 = ifelse(sobO_v2_SO_24_48_30 == K_24_48_30, 1, 0),
             Score_sobO_v2_SO_24_48_31 = ifelse(sobO_v2_SO_24_48_31 == K_24_48_31, 1, 0),
             
             Score_sobO_v2 = sum(Score_sobO_v2_SO_24_48_1, Score_sobO_v2_SO_24_48_2, 
                                 Score_sobO_v2_SO_24_48_3, Score_sobO_v2_SO_24_48_4,
                                 Score_sobO_v2_SO_24_48_5, Score_sobO_v2_SO_24_48_6,
                                 Score_sobO_v2_SO_24_48_7, Score_sobO_v2_SO_24_48_8,
                                 Score_sobO_v2_SO_24_48_9, Score_sobO_v2_SO_24_48_10,
                                 Score_sobO_v2_SO_24_48_11, Score_sobO_v2_SO_24_48_12,
                                 Score_sobO_v2_SO_24_48_13, Score_sobO_v2_SO_24_48_14,
                                 Score_sobO_v2_SO_24_48_15, Score_sobO_v2_SO_24_48_16,
                                 Score_sobO_v2_SO_24_48_17, Score_sobO_v2_SO_24_48_18,
                                 Score_sobO_v2_SO_24_48_19, Score_sobO_v2_SO_24_48_20,
                                 Score_sobO_v2_SO_24_48_21, Score_sobO_v2_SO_24_48_22,
                                 Score_sobO_v2_SO_24_48_23, Score_sobO_v2_SO_24_48_24,
                                 Score_sobO_v2_SO_24_48_25, Score_sobO_v2_SO_24_48_26,
                                 Score_sobO_v2_SO_24_48_27, Score_sobO_v2_SO_24_48_28,
                                 Score_sobO_v2_SO_24_48_29, Score_sobO_v2_SO_24_48_30,
                                 Score_sobO_v2_SO_24_48_31
             ),
             Score_sobO_v2 = round(Score_sobO_v2 / 31, 3)
      ) 
    
    sobO_v2_upload <- sobO_v2_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("sobO_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response", 31), rep("Answer", 31), rep("Score", 31), "Overall")
      ) %>%
      rename(name = text_sobO_v2_person,
             site = text_sobO_v2_site,
             date = text_sobO_v2_date) %>% 
      filter(key != "Answer")
    
    sobO_v2_upload <- as.data.frame(sobO_v2_upload)
    
    sheet_append(ss = sheet_id,
                 data = sobO_v2_upload,
                 sheet = "main")
    
    return(sobO_v2_combined)
    
  })
  
  output$sobO_v2_incorrect <- renderTable({
    sobO_v2_data <- sobO_v2_values()
    
    pull_cols <- sobO_v2_data %>% 
      select(starts_with("sobO_v2_SO_24_48_"), starts_with("K_")) %>% 
      colnames()
    
    sobO_v2_data[ ,pull_cols] <- lapply(sobO_v2_data[ ,pull_cols], factor, levels = c(0, 1), labels = c("No", "Yes"))
    
    return_sobO_v2 <- sobO_v2_data %>%
      mutate_all(as.character) %>%
      select(-c(Score_sobO_v2)) %>%
      pivot_longer(.,
                   cols = c(starts_with("sobO_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "Question",
                   values_to = "Score"
      ) %>%
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13", "Q14", "Q15", "Q16", "Q17", "Q18", 
                         "Q19", "Q20", "Q21", "Q22", "Q23", "Q24", 
                         "Q25", "Q26", "Q27", "Q28", "Q29", "Q30", 
                         "Q31"), 3)),
             type = c(rep("Response", 31), rep("Answer", 31), rep("Score", 31))
      ) %>%
      select(-c(task_id:text_sobO_v2_date, Question)) %>%
      rename(Question = Q) %>%
      pivot_wider(.,
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>%
      select(Question, Response, Answer, Score) %>%
      filter(Score != 1)
    
    return(return_sobO_v2)
  })
  
  output$sobO_v2_score <- renderText({
    
    sobO_v2_data <- sobO_v2_values()
    
    percent_correct <- sobO_v2_data$Score_sobO_v2 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  

## Get Up and Go data ------
  ### Video 1 ------
  gug_v1_values <- eventReactive(input$gug_v1_submit, {
    
    gug_v1_data <- data.frame(
      task_id = c("gug_v1"),
      text_gug_v1_person = c(input$text_gug_v1_person),
      text_gug_v1_site = c(input$text_gug_v1_site),
      text_gug_v1_date = Sys.time(),#format(as.Date(input$text_gug_v1_date, origin="2023-01-01")),
      
      gug_v1_back = c(input$radio_gug_v1_back),
      gug_v1_roll = c(input$radio_gug_v1_roll),
      gug_v1_uppos = c(input$radio_gug_v1_uppos),
      
      gug_v1_turn = c(input$radio_gug_v1_turn),
      
      gug_v1_trameth = c(input$radio_gug_v1_trameth),
      gug_v1_tradis = c(input$radio_gug_v1_tradis),
      
      gug_v1_start = c(input$radio_gug_v1_starttime),
      gug_v1_end = c(input$radio_gug_v1_endtime),
      
      gug_v1_stairup = c(input$radio_gug_v1_stairup),
      gug_v1_stairdo = c(input$radio_gug_v1_stairdo)
      
    ) %>%
      mutate(
        gug_v1_back = as.numeric(gug_v1_back),
        gug_v1_roll = as.numeric(gug_v1_roll),
        gug_v1_uppos = as.numeric(gug_v1_uppos),
        gug_v1_turn = as.numeric(gug_v1_turn),
        gug_v1_trameth = as.numeric(gug_v1_trameth),
        gug_v1_tradis = as.numeric(gug_v1_tradis),
        gug_v1_start = as.numeric(gug_v1_start),
        gug_v1_end = as.numeric(gug_v1_end),
        gug_v1_stairup = as.numeric(gug_v1_stairup),
        gug_v1_stairdo = as.numeric(gug_v1_stairdo)
      )
    
    gug_key_df <- data.frame(
      K_Back = c(2),
      K_Roll = c(2),
      K_UpPos = c(2),
      K_Turn = c(2),
      K_TraMeth = c(5),
      K_TraDis = c(5),
      K_Start = c(.27),
      K_End = c(.38),
      K_StairUp = c(4),
      K_StairDo = c(2)
    )
    
    gug_v1_combined <- bind_cols(gug_v1_data, gug_key_df) %>% 
      mutate(Score_gug_v1_back = ifelse(gug_v1_back == K_Back, 1, 0),
             Score_gug_v1_roll = ifelse(gug_v1_roll == K_Roll, 1, 0),
             Score_gug_v1_uppos = ifelse(gug_v1_uppos == K_UpPos, 1, 0),
             Score_gug_v1_turn = ifelse(gug_v1_turn == K_Turn, 1, 0),
             Score_gug_v1_trameth = ifelse(gug_v1_trameth == K_TraMeth, 1, 0),
             Score_gug_v1_tradis = ifelse(gug_v1_tradis == K_TraDis, 1, 0),
             Score_gug_v1_start = ifelse(between(gug_v1_start, K_Start - 0.01, K_Start + 0.01), 1,
                                         ifelse(gug_v1_start == K_Start - 0.02, 0.5,
                                                ifelse(gug_v1_start == K_Start + 0.02, 0.5, 0))),
             Score_gug_v1_end = ifelse(between(gug_v1_end, K_End - 0.01, K_End + 0.01), 1,
                                       ifelse(gug_v1_end == K_End - 0.02, 0.5,
                                              ifelse(gug_v1_end == K_End + 0.02, 0.5, 0))),
             Score_gug_v1_stairup = ifelse(gug_v1_stairup == K_StairUp, 1, 0),
             Score_gug_v1_stairdo = ifelse(gug_v1_stairdo == K_StairDo, 1, 0),
             
             Score_gug_v1 = sum(Score_gug_v1_back, 
                                Score_gug_v1_roll, Score_gug_v1_uppos,
                                Score_gug_v1_turn, Score_gug_v1_trameth, 
                                Score_gug_v1_tradis, Score_gug_v1_start,
                                Score_gug_v1_end, Score_gug_v1_stairup,
                                Score_gug_v1_stairdo
             ),
             Score_gug_v1 = round(Score_gug_v1 / 10, 3)
      ) 
    
    gug_v1_upload <- gug_v1_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("gug_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response", 10), rep("Answer", 10), rep("Score", 10), "Overall")
      ) %>%
      rename(name = text_gug_v1_person,
             site = text_gug_v1_site,
             date = text_gug_v1_date) %>% 
      filter(key != "Answer")
    
    gug_v1_upload <- as.data.frame(gug_v1_upload)
    
    sheet_append(ss = sheet_id,
                 data = gug_v1_upload,
                 sheet = "main")
    
    return(gug_v1_combined)
    
  })
  
  output$gug_v1_incorrect <- renderTable({
    gug_v1_data <- gug_v1_values()
    
    return_gug_v1 <- gug_v1_data %>%
      mutate(gug_v1_back = factor(gug_v1_back, app_values_0_2, c("No (didn’t try)", "No (tried but couldn’t)", "Yes")),
             K_Back = factor(K_Back, app_values_0_2, c("No (didn’t try)", "No (tried but couldn’t)", "Yes")),
             
             gug_v1_roll = factor(gug_v1_roll, app_values_1_5, c("Rolled to belly, hands trapped",
                                                                 "Rolled to belly, hands out", "Rolled to hands-knees",
                                                                 "Side lying", "Got up without rolling")),
             K_Roll = factor(K_Roll, app_values_1_5, c("Rolled to belly, hands trapped",
                                                       "Rolled to belly, hands out", "Rolled to hands-knees",
                                                       "Side lying", "Got up without rolling")),
             
             gug_v1_uppos = factor(gug_v1_uppos, app_values_1_4, c("Belly", "Hands-knees or hands-feet",
                                                                   "Sit or kneel, back vertical", "Stand")),
             K_UpPos = factor(K_UpPos, app_values_1_4, c("Belly", "Hands-knees or hands-feet",
                                                         "Sit or kneel, back vertical", "Stand")),
             
             
             
             gug_v1_turn = factor(gug_v1_turn, app_values_1_3, c("Never faced finish", "Turned to face finish", "Already facing finish")),
             K_Turn = factor(K_Turn, app_values_1_3, c("Never faced finish", "Turned to face finish", "Already facing finish")),
             
             gug_v1_trameth = factor(gug_v1_trameth, app_values_1_7, c("Did not travel", "Log roll",
                                                                       "Belly crawl", "Bum shuffle or hitch",
                                                                       "Hands-knees or hands-feet", "Knee-walk or half-kneel",
                                                                       "Walk")),
             K_TraMeth = factor(K_TraMeth, app_values_1_7, c("Did not travel", "Log roll",
                                                             "Belly crawl", "Bum shuffle or hitch",
                                                             "Hands-knees or hands-feet", "Knee-walk or half-kneel",
                                                             "Walk")),
             
             
             
             gug_v1_tradis = factor(gug_v1_tradis, app_values_1_5, c("Took a few steps and fell",
                                                                     "Took a few steps and stopped", "3 meters, not continuous",
                                                                     "3 meters, but dawdled", "3 meters, no dawdling")),
             K_TraDis = factor(K_TraDis, app_values_1_5, c("Took a few steps and fell",
                                                           "Took a few steps and stopped", "3 meters, not continuous",
                                                           "3 meters, but dawdled", "3 meters, no dawdling")),
             
             
             
             gug_v1_stairup = factor(gug_v1_stairup, app_values_0_8, c("Didn't try", "Did not pull up",
                                                                       "Pulled up to knees", "Pulled up to stand",
                                                                       "Climbed up, stayed prone", "Climbed up, stood up",
                                                                       "Tried to step & fell", "Stepped up, not integrated",
                                                                       "Stepped up, gait integrated")),
             K_StairUp = factor(K_StairUp, app_values_0_8, c("Didn't try", "Did not pull up",
                                                             "Pulled up to knees", "Pulled up to stand",
                                                             "Climbed up, stayed prone", "Climbed up, stood up",
                                                             "Tried to step & fell", "Stepped up, not integrated",
                                                             "Stepped up, gait integrated")),
             
             
             gug_v1_stairdo = factor(gug_v1_stairdo, app_values_0_8, c("Didn't try to come down",
                                                                       "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                                                       "Walked down, fell", "Walked down, not integrated",
                                                                       "Walked down, integrated", "Jumped or leaped & fell",
                                                                       "Jumped or leaped no fall")),
             K_StairDo = factor(K_StairDo, app_values_0_8, c("Didn't try to come down",
                                                             "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                                             "Walked down, fell", "Walked down, not integrated",
                                                             "Walked down, integrated", "Jumped or leaped & fell",
                                                             "Jumped or leaped no fall"))
             
      ) %>%
      mutate_all(as.character) %>%
      select(-c(Score_gug_v1)) %>%
      pivot_longer(.,
                   cols = c(starts_with("gug_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "Question",
                   values_to = "Score"
      ) %>%
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10"), 3)),
             type = c(rep("Response", 10), rep("Answer", 10), rep("Score", 10))
      ) %>%
      select(-c(task_id:text_gug_v1_date, Question)) %>%
      rename(Question = Q) %>%
      pivot_wider(.,
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>%
      select(Question, Response, Answer, Score) %>%
      filter(Score != 1)
    
    return(return_gug_v1)
  })
  
  output$gug_v1_score <- renderText({
    
    gug_v1_data <- gug_v1_values()
    
    percent_correct <- gug_v1_data$Score_gug_v1 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  ### Video 2 ------
  gug_v2_values <- eventReactive(input$gug_v2_submit, {
    
    gug_v2_data <- data.frame(
      task_id = c("gug_v2"),
      text_gug_v2_person = c(input$text_gug_v2_person),
      text_gug_v2_site = c(input$text_gug_v2_site),
      text_gug_v2_date = Sys.time(),#format(as.Date(input$text_gug_v2_date, origin="2023-01-01")),

      
      gug_v2_back = c(input$radio_gug_v2_back),
      gug_v2_roll = c(input$radio_gug_v2_roll),
      gug_v2_uppos = c(input$radio_gug_v2_uppos),
      
      
      gug_v2_stand = c(input$radio_gug_v2_stand),
      gug_v2_hands = c(input$radio_gug_v2_hands),
      gug_v2_turn = c(input$radio_gug_v2_turn),
      
      gug_v2_trameth = c(input$radio_gug_v2_trameth),
      gug_v2_toes = c(input$radio_gug_v2_toes),
      gug_v2_tradis = c(input$radio_gug_v2_tradis),
      
      gug_v2_start = c(input$radio_gug_v2_starttime),
      gug_v2_end = c(input$radio_gug_v2_endtime),
      
      gug_v2_stairup = c(input$radio_gug_v2_stairup),
      gug_v2_stairdo = c(input$radio_gug_v2_stairdo)
      
    ) %>%
      mutate(
        gug_v2_back = as.numeric(gug_v2_back),
        gug_v2_roll = as.numeric(gug_v2_roll),
        gug_v2_uppos = as.numeric(gug_v2_uppos),
        
        gug_v2_stand = as.numeric(gug_v2_stand),
        gug_v2_hands = as.numeric(gug_v2_hands),
        gug_v2_turn = as.numeric(gug_v2_turn),
        gug_v2_trameth = as.numeric(gug_v2_trameth),
        gug_v2_toes = as.numeric(gug_v2_toes),
        gug_v2_tradis = as.numeric(gug_v2_tradis),
        gug_v2_start = as.numeric(gug_v2_start),
        gug_v2_end = as.numeric(gug_v2_end),
        gug_v2_stairup = as.numeric(gug_v2_stairup),
        gug_v2_stairdo = as.numeric(gug_v2_stairdo)
      )
    
    gug_key_df <- data.frame(
      K_Back = c(2),
      K_Roll = c(5),
      K_UpPos = c(4),
      K_Stand = c(2),
      K_Hands = c(1),
      K_Turn = c(3),
      K_TraMeth = c(7),
      K_Toes = c(2),
      K_TraDis = c(5),
      K_Start = c(.08),
      K_End = c(.09),
      K_StairUp = c(8),
      K_StairDo = c(8)
    )
    
    gug_v2_combined <- bind_cols(gug_v2_data, gug_key_df) %>% 
      mutate(Score_gug_v2_back = ifelse(gug_v2_back == K_Back, 1, 0),
             Score_gug_v2_roll = ifelse(gug_v2_roll == K_Roll, 1, 0),
             Score_gug_v2_uppos = ifelse(gug_v2_uppos == K_UpPos, 1, 0),
             
             Score_gug_v2_stand = ifelse(gug_v2_stand == K_Stand, 1, 0),
             Score_gug_v2_hands = ifelse(gug_v2_hands == K_Hands, 1, 0),
             Score_gug_v2_turn = ifelse(gug_v2_turn == K_Turn, 1, 0),
             Score_gug_v2_trameth = ifelse(gug_v2_trameth == K_TraMeth, 1, 0),
             Score_gug_v2_toes = ifelse(gug_v2_toes == K_Toes, 1, 0),
             Score_gug_v2_tradis = ifelse(gug_v2_tradis == K_TraDis, 1, 0),
             Score_gug_v2_start = ifelse(between(gug_v2_start, K_Start - 0.01, K_Start + 0.01), 1,
                                         ifelse(gug_v2_start == K_Start - 0.02, 0.5,
                                                ifelse(gug_v2_start == K_Start + 0.02, 0.5, 0))),
             Score_gug_v2_end = ifelse(between(gug_v2_end, K_End - 0.01, K_End + 0.01), 1,
                                       ifelse(gug_v2_end == K_End - 0.02, 0.5,
                                              ifelse(gug_v2_end == K_End + 0.02, 0.5, 0))),
             Score_gug_v2_stairup = ifelse(gug_v2_stairup == K_StairUp, 1, 0),
             Score_gug_v2_stairdo = ifelse(gug_v2_stairdo == K_StairDo, 1, 0),
             
             Score_gug_v2 = sum(Score_gug_v2_back, 
                                Score_gug_v2_roll, Score_gug_v2_uppos,
                                Score_gug_v2_stand,
                                Score_gug_v2_hands, Score_gug_v2_turn,
                                Score_gug_v2_trameth, Score_gug_v2_toes,
                                Score_gug_v2_tradis, Score_gug_v2_start,
                                Score_gug_v2_end, Score_gug_v2_stairup,
                                Score_gug_v2_stairdo
             ),
             Score_gug_v2 = round(Score_gug_v2 / 13, 3)
      ) 
    
    gug_v2_upload <- gug_v2_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("gug_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response",  13), rep("Answer",  13), rep("Score",  13), "Overall")
      ) %>%
      rename(name = text_gug_v2_person,
             site = text_gug_v2_site,
             date = text_gug_v2_date) %>% 
      filter(key != "Answer")
    
    gug_v2_upload <- as.data.frame(gug_v2_upload)
    
    sheet_append(ss = sheet_id,
                 data = gug_v2_upload,
                 sheet = "main")
    
    return(gug_v2_combined)
    
  })
  
  output$gug_v2_incorrect <- renderTable({
    gug_v2_data <- gug_v2_values()
    
    return_gug_v2 <- gug_v2_data %>%
      mutate(gug_v2_back = factor(gug_v2_back, app_values_0_2, c("No (didn’t try)", "No (tried but couldn’t)", "Yes")),
             K_Back = factor(K_Back, app_values_0_2, c("No (didn’t try)", "No (tried but couldn’t)", "Yes")),
             
             
             
             gug_v2_roll = factor(gug_v2_roll, app_values_1_5, c("Rolled to belly, hands trapped",
                                                                 "Rolled to belly, hands out", "Rolled to hands-knees",
                                                                 "Side lying", "Got up without rolling")),
             K_Roll = factor(K_Roll, app_values_1_5, c("Rolled to belly, hands trapped",
                                                       "Rolled to belly, hands out", "Rolled to hands-knees",
                                                       "Side lying", "Got up without rolling")),
             
             gug_v2_uppos = factor(gug_v2_uppos, app_values_1_4, c("Belly", "Hands-knees or hands-feet",
                                                                   "Sit or kneel, back vertical", "Stand")),
             K_UpPos = factor(K_UpPos, app_values_1_4, c("Belly", "Hands-knees or hands-feet",
                                                         "Sit or kneel, back vertical", "Stand")),
             
             
             gug_v2_stand = factor(gug_v2_stand, app_values_1_3, c("Down-dog to stand",
                                                                   "Half-kneel to stand", "Squat to stand")),
             K_Stand = factor(K_Stand, app_values_1_3, c("Down-dog to stand",
                                                         "Half-kneel to stand", "Squat to stand")),
             
             gug_v2_hands = factor(gug_v2_hands, app_values_0_2, c("0", "1", "2")),
             K_Hands = factor(K_Hands, app_values_0_2, c("0", "1", "2")),
             
             gug_v2_turn = factor(gug_v2_turn, app_values_1_3, c("Never faced finish", "Turned to face finish", "Already facing finish")),
             K_Turn = factor(K_Turn, app_values_1_3, c("Never faced finish", "Turned to face finish", "Already facing finish")),
             
             gug_v2_trameth = factor(gug_v2_trameth, app_values_1_7, c("Did not travel", "Log roll",
                                                                       "Belly crawl", "Bum shuffle or hitch",
                                                                       "Hands-knees or hands-feet", "Knee-walk or half-kneel",
                                                                       "Walk")),
             K_TraMeth = factor(K_TraMeth, app_values_1_7, c("Did not travel", "Log roll",
                                                             "Belly crawl", "Bum shuffle or hitch",
                                                             "Hands-knees or hands-feet", "Knee-walk or half-kneel",
                                                             "Walk")),
             
             gug_v2_toes = factor(gug_v2_toes, app_values_1_5, c("Can't see heels", "No",
                                                                 "Right foot", "Left foot",
                                                                 "Both")),
             K_Toes = factor(K_Toes, app_values_1_5, c("Can't see heels", "No",
                                                       "Right foot", "Left foot",
                                                       "Both")),
             
             gug_v2_tradis = factor(gug_v2_tradis, app_values_1_5, c("Took a few steps and fell",
                                                                     "Took a few steps and stopped", "3 meters, not continuous",
                                                                     "3 meters, but dawdled", "3 meters, no dawdling")),
             K_TraDis = factor(K_TraDis, app_values_1_5, c("Took a few steps and fell",
                                                           "Took a few steps and stopped", "3 meters, not continuous",
                                                           "3 meters, but dawdled", "3 meters, no dawdling")),
             
             
             
             gug_v2_stairup = factor(gug_v2_stairup, app_values_0_8, c("Didn't try", "Did not pull up",
                                                                       "Pulled up to knees", "Pulled up to stand",
                                                                       "Climbed up, stayed prone", "Climbed up, stood up",
                                                                       "Tried to step & fell", "Stepped up, not integrated",
                                                                       "Stepped up, gait integrated")),
             K_StairUp = factor(K_StairUp, app_values_0_8, c("Didn't try", "Did not pull up",
                                                             "Pulled up to knees", "Pulled up to stand",
                                                             "Climbed up, stayed prone", "Climbed up, stood up",
                                                             "Tried to step & fell", "Stepped up, not integrated",
                                                             "Stepped up, gait integrated")),
             
             
             gug_v2_stairdo = factor(gug_v2_stairdo, app_values_0_8, c("Didn't try to come down",
                                                                       "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                                                       "Walked down, fell", "Walked down, not integrated",
                                                                       "Walked down, integrated", "Jumped or leaped & fell",
                                                                       "Jumped or leaped no fall")),
             K_StairDo = factor(K_StairDo, app_values_0_8, c("Didn't try to come down",
                                                             "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                                             "Walked down, fell", "Walked down, not integrated",
                                                             "Walked down, integrated", "Jumped or leaped & fell",
                                                             "Jumped or leaped no fall"))
             
      ) %>%
      mutate_all(as.character) %>%
      select(-c(Score_gug_v2)) %>%
      pivot_longer(.,
                   cols = c(starts_with("gug_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "Question",
                   values_to = "Score"
      ) %>%
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13"), 3)),
             type = c(rep("Response", 13), rep("Answer", 13), rep("Score", 13))
      ) %>%
      select(-c(task_id:text_gug_v2_date, Question)) %>%
      rename(Question = Q) %>%
      pivot_wider(.,
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>%
      select(Question, Response, Answer, Score) %>%
      filter(Score != 1)
    
    return(return_gug_v2)
  })
  
  output$gug_v2_score <- renderText({
    
    gug_v2_data <- gug_v2_values()
    
    percent_correct <- gug_v2_data$Score_gug_v2 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
## Reach to Eat data ------
  ### Video 1 ------
  rte_v1_values <- eventReactive(input$rte_v1_submit, {
    
    rte_v1_data <- data.frame(
      task_id = c("rte_v1"),
      text_rte_v1_person = c(input$text_rte_v1_person),
      text_rte_v1_site = c(input$text_rte_v1_site),
      text_rte_v1_date = Sys.time(),#format(as.Date(input$text_rte_v1_date, origin="2023-01-01")),
      
      rte_v1_sctr_success = c(input$radio_rte_v1_sctr_success),
      rte_v1_sctr_grasp = c(input$radio_rte_v1_sctr_grasp),
      rte_v1_sctl_success = c(input$radio_rte_v1_sctl_success),
      rte_v1_sctl_grasp = c(input$radio_rte_v1_sctl_grasp),
      
      rte_v1_spnter_purpose = c(input$radio_rte_v1_spnter_purpose),
      rte_v1_spnter_move = c(input$radio_rte_v1_spnter_move),
      rte_v1_spnter_grasp = c(input$radio_rte_v1_spnter_grasp),
      rte_v1_spnter_thumb = c(input$radio_rte_v1_spnter_thumb),
      rte_v1_spnter_success = c(input$radio_rte_v1_spnter_success),
      rte_v1_spnthr_purpose = c(input$radio_rte_v1_spnthr_purpose),
      rte_v1_spnthr_move = c(input$radio_rte_v1_spnthr_move),
      rte_v1_spnthr_grasp = c(input$radio_rte_v1_spnthr_grasp),
      rte_v1_spnthr_thumb = c(input$radio_rte_v1_spnthr_thumb),
      rte_v1_spnthr_success = c(input$radio_rte_v1_spnthr_success),
      
      rte_v1_spntel_purpose = c(input$radio_rte_v1_spntel_purpose),
      rte_v1_spntel_move = c(input$radio_rte_v1_spntel_move),
      rte_v1_spntel_grasp = c(input$radio_rte_v1_spntel_grasp),
      rte_v1_spntel_thumb = c(input$radio_rte_v1_spntel_thumb),
      rte_v1_spntel_success = c(input$radio_rte_v1_spntel_success),
      rte_v1_spnthl_purpose = c(input$radio_rte_v1_spnthl_purpose),
      rte_v1_spnthl_move = c(input$radio_rte_v1_spnthl_move),
      rte_v1_spnthl_grasp = c(input$radio_rte_v1_spnthl_grasp),
      rte_v1_spnthl_thumb = c(input$radio_rte_v1_spnthl_thumb),
      rte_v1_spnthl_success = c(input$radio_rte_v1_spnthl_success)
      
    ) %>%
      mutate(
        rte_v1_sctr_success = as.numeric(rte_v1_sctr_success),
        rte_v1_sctr_grasp = as.numeric(rte_v1_sctr_grasp),
        rte_v1_sctl_success = as.numeric(rte_v1_sctl_success),
        rte_v1_sctl_grasp = as.numeric(rte_v1_sctl_grasp),
        
        rte_v1_spnter_purpose = as.numeric(rte_v1_spnter_purpose),
        rte_v1_spnter_move = as.numeric(rte_v1_spnter_move),
        rte_v1_spnter_grasp = as.numeric(rte_v1_spnter_grasp),
        rte_v1_spnter_thumb = as.numeric(rte_v1_spnter_thumb),
        rte_v1_spnter_success = as.numeric(rte_v1_spnter_success),
        rte_v1_spnthr_purpose = as.numeric(rte_v1_spnthr_purpose),
        rte_v1_spnthr_move = as.numeric(rte_v1_spnthr_move),
        rte_v1_spnthr_grasp = as.numeric(rte_v1_spnthr_grasp),
        rte_v1_spnthr_thumb = as.numeric(rte_v1_spnthr_thumb),
        rte_v1_spnthr_success = as.numeric(rte_v1_spnthr_success),
        
        rte_v1_spntel_purpose = as.numeric(rte_v1_spntel_purpose),
        rte_v1_spntel_move = as.numeric(rte_v1_spntel_move),
        rte_v1_spntel_grasp = as.numeric(rte_v1_spntel_grasp),
        rte_v1_spntel_thumb = as.numeric(rte_v1_spntel_thumb),
        rte_v1_spntel_success = as.numeric(rte_v1_spntel_success),
        rte_v1_spnthl_purpose = as.numeric(rte_v1_spnthl_purpose),
        rte_v1_spnthl_move = as.numeric(rte_v1_spnthl_move),
        rte_v1_spnthl_grasp = as.numeric(rte_v1_spnthl_grasp),
        rte_v1_spnthl_thumb = as.numeric(rte_v1_spnthl_thumb),
        rte_v1_spnthl_success = as.numeric(rte_v1_spnthl_success)
      )
    
    rte_key_df <- data.frame(
      K_SCTR_Success = c(5),
      K_SCTR_Grasp = c(3),
      K_SCTL_Success = c(5),
      K_SCTL_Grasp = c(3),
      
      K_SpnTer_Purpose = c(4),
      K_SpnTer_Move = c(1),
      K_SpnTer_Grasp = c(2),
      K_SpnTer_Thumb = c(2),
      K_SpnTer_Success = c(3),
      K_SpnThr_Purpose = c(4),
      K_SpnThr_Move = c(2),
      K_SpnThr_Grasp = c(1),
      K_SpnThr_Thumb = c(1),
      K_SpnThr_Success = c(2),
      
      K_SpnTel_Purpose = c(4),
      K_SpnTel_Move = c(1),
      K_SpnTel_Grasp = c(2),
      K_SpnTel_Thumb = c(2),
      K_SpnTel_Success = c(2),
      K_SpnThl_Purpose = c(4),
      K_SpnThl_Move = c(2),
      K_SpnThl_Grasp = c(2),
      K_SpnThl_Thumb = c(2),
      K_SpnThl_Success = c(2)
    )
    
    rte_v1_combined <- cbind(rte_v1_data, rte_key_df) %>% 
      mutate(Score_rte_v1_sctr_success = ifelse(rte_v1_sctr_success == K_SCTR_Success, 1, 0),
             Score_rte_v1_sctr_grasp = ifelse(rte_v1_sctr_grasp == K_SCTR_Grasp, 1, 0),
             Score_rte_v1_sctl_success = ifelse(rte_v1_sctl_success == K_SCTL_Success, 1, 0),
             Score_rte_v1_sctl_grasp = ifelse(rte_v1_sctl_grasp == K_SCTL_Grasp, 1, 0),
             
             Score_rte_v1_spnter_purpose = ifelse(rte_v1_spnter_purpose == K_SpnTer_Purpose, 1, 0),
             Score_rte_v1_spnter_move = ifelse(rte_v1_spnter_move == K_SpnTer_Move, 1, 0),
             Score_rte_v1_spnter_grasp = ifelse(rte_v1_spnter_grasp == K_SpnTer_Grasp, 1, 0),
             Score_rte_v1_spnter_thumb = ifelse(rte_v1_spnter_thumb == K_SpnTer_Thumb, 1, 0),
             Score_rte_v1_spnter_success = ifelse(rte_v1_spnter_success == K_SpnTer_Success, 1, 0),
             Score_rte_v1_spnthr_purpose = ifelse(rte_v1_spnthr_purpose == K_SpnThr_Purpose, 1, 0),
             Score_rte_v1_spnthr_move = ifelse(rte_v1_spnthr_move == K_SpnThr_Move, 1, 0),
             Score_rte_v1_spnthr_grasp = ifelse(rte_v1_spnthr_grasp == K_SpnThr_Grasp, 1, 0),
             Score_rte_v1_spnthr_thumb = ifelse(rte_v1_spnthr_thumb == K_SpnThr_Thumb, 1, 0),
             Score_rte_v1_spnthr_success = ifelse(rte_v1_spnthr_success == K_SpnThr_Success, 1, 0),
             
             Score_rte_v1_spntel_purpose = ifelse(rte_v1_spntel_purpose == K_SpnTel_Purpose, 1, 0),
             Score_rte_v1_spntel_move = ifelse(rte_v1_spntel_move == K_SpnTel_Move, 1, 0),
             Score_rte_v1_spntel_grasp = ifelse(rte_v1_spntel_grasp == K_SpnTel_Grasp, 1, 0),
             Score_rte_v1_spntel_thumb = ifelse(rte_v1_spntel_thumb == K_SpnTel_Thumb, 1, 0),
             Score_rte_v1_spntel_success = ifelse(rte_v1_spntel_success == K_SpnTel_Success, 1, 0),
             Score_rte_v1_spnthl_purpose = ifelse(rte_v1_spnthl_purpose == K_SpnThl_Purpose, 1, 0),
             Score_rte_v1_spnthl_move = ifelse(rte_v1_spnthl_move == K_SpnThl_Move, 1, 0),
             Score_rte_v1_spnthl_grasp = ifelse(rte_v1_spnthl_grasp == K_SpnThl_Grasp, 1, 0),
             Score_rte_v1_spnthl_thumb = ifelse(rte_v1_spnthl_thumb == K_SpnThl_Thumb, 1, 0),
             Score_rte_v1_spnthl_success = ifelse(rte_v1_spnthl_success == K_SpnThl_Success, 1, 0),
             
             Score_rte_v1 = sum(Score_rte_v1_sctr_success, Score_rte_v1_sctr_grasp, 
                                Score_rte_v1_sctl_success, Score_rte_v1_sctl_grasp, 
                                
                                Score_rte_v1_spnter_purpose, Score_rte_v1_spnter_move, 
                                Score_rte_v1_spnter_grasp, Score_rte_v1_spnter_thumb, 
                                Score_rte_v1_spnter_success, Score_rte_v1_spnthr_purpose, 
                                Score_rte_v1_spnthr_move, Score_rte_v1_spnthr_grasp, 
                                Score_rte_v1_spnthr_thumb, Score_rte_v1_spnthr_success, 
                                
                                Score_rte_v1_spntel_purpose, Score_rte_v1_spntel_move, 
                                Score_rte_v1_spntel_grasp, Score_rte_v1_spntel_thumb, 
                                Score_rte_v1_spntel_success, Score_rte_v1_spnthl_purpose, 
                                Score_rte_v1_spnthl_move, Score_rte_v1_spnthl_grasp,
                                Score_rte_v1_spnthl_thumb, Score_rte_v1_spnthl_success),
             Score_rte_v1 = round(Score_rte_v1 / 24 , 3)
      ) 
    
    rte_v1_upload <- rte_v1_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("rte_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 24), rep("Answer", 24), rep("Score", 24), "Overall")
      ) %>% 
      rename(name = text_rte_v1_person,
             site = text_rte_v1_site,
             date = text_rte_v1_date) %>% 
      filter(key != "Answer")
    
    rte_v1_upload <- as.data.frame(rte_v1_upload)
    
    sheet_append(ss = sheet_id,
                 data = rte_v1_upload,
                 sheet = "main")
    
    return(rte_v1_combined)
    
  })
  
  output$rte_v1_incorrect <- renderTable({
    rte_v1_data <- rte_v1_values()
    
    return_rte_v1 <- rte_v1_data %>% 
      mutate(rte_v1_sctr_success = factor(rte_v1_sctr_success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTR_Success = factor(K_SCTR_Success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v1_sctr_grasp = factor(rte_v1_sctr_grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTR_Grasp = factor(K_SCTR_Grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v1_sctl_success = factor(rte_v1_sctl_success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTL_Success = factor(K_SCTL_Success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v1_sctl_grasp = factor(rte_v1_sctl_grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTL_Grasp = factor(K_SCTL_Grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v1_spnter_purpose = factor(rte_v1_spnter_purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnTer_Purpose = factor(K_SpnTer_Purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spnter_move = factor(rte_v1_spnter_move, app_values_1_2, c("Grasped handle", "Moved handle")),
             K_SpnTer_Move = factor(K_SpnTer_Move, app_values_1_2, c("Grasped handle", "Moved handle")),
             rte_v1_spnter_grasp = factor(rte_v1_spnter_grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnTer_Grasp = factor(K_SpnTer_Grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spnter_thumb = factor(rte_v1_spnter_thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             K_SpnTer_Thumb = factor(K_SpnTer_Thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             rte_v1_spnter_success = factor(rte_v1_spnter_success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnTer_Success = factor(K_SpnTer_Success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt")),
             
             rte_v1_spnthr_purpose = factor(rte_v1_spnthr_purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnThr_Purpose = factor(K_SpnThr_Purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spnthr_move = factor(rte_v1_spnthr_move, app_values_1_2, c("Grasped handle", "Moved handle")),
             K_SpnThr_Move = factor(K_SpnThr_Move, app_values_1_2, c("Grasped handle", "Moved handle")),
             rte_v1_spnthr_grasp = factor(rte_v1_spnthr_grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnThr_Grasp = factor(K_SpnThr_Grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spnthr_thumb = factor(rte_v1_spnthr_thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             K_SpnThr_Thumb = factor(K_SpnThr_Thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             rte_v1_spnthr_success = factor(rte_v1_spnthr_success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnThr_Success = factor(K_SpnThr_Success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt")),
             
             
             rte_v1_spntel_purpose = factor(rte_v1_spntel_purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnTel_Purpose = factor(K_SpnTel_Purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spntel_move = factor(rte_v1_spntel_move, app_values_1_2, c("Grasped handle", "Moved handle")),
             K_SpnTel_Move = factor(K_SpnTel_Move, app_values_1_2, c("Grasped handle", "Moved handle")),
             rte_v1_spntel_grasp = factor(rte_v1_spntel_grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnTel_Grasp = factor(K_SpnTel_Grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spntel_thumb = factor(rte_v1_spntel_thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             K_SpnTel_Thumb = factor(K_SpnTel_Thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             rte_v1_spntel_success = factor(rte_v1_spntel_success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnTel_Success = factor(K_SpnTel_Success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt")),
             
             rte_v1_spnthl_purpose = factor(rte_v1_spnthl_purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnThl_Purpose = factor(K_SpnThl_Purpose, app_values_0_4, c("Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spnthl_move = factor(rte_v1_spnthl_move, app_values_1_2, c("Grasped handle", "Moved handle")),
             K_SpnThl_Move = factor(K_SpnThl_Move, app_values_1_2, c("Grasped handle", "Moved handle")),
             rte_v1_spnthl_grasp = factor(rte_v1_spnthl_grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnThl_Grasp = factor(K_SpnThl_Grasp, app_values_1_3, c("Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spnthl_thumb = factor(rte_v1_spnthl_thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             K_SpnThl_Thumb = factor(K_SpnThl_Thumb, app_values_1_2, c("Away from bowl", "Toward bowl")),
             rte_v1_spnthl_success = factor(rte_v1_spnthl_success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnThl_Success = factor(K_SpnThl_Success, app_values_0_3_neg2, c("Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt"))
             
      ) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_rte_v1)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("rte_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13", "Q14", "Q15", "Q16", "Q17", "Q18",
                         "Q19", "Q20", "Q21", "Q22", "Q23", "Q24"), 3)),
             type = c(rep("Response", 24), rep("Answer", 24), rep("Score", 24))
      ) %>% 
      select(-c(task_id:text_rte_v1_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_rte_v1) 
  })
  
  output$rte_v1_score <- renderText({
    
    rte_v1_data <- rte_v1_values()
    
    percent_correct <- rte_v1_data$Score_rte_v1 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  ### Video 2 ------
  rte_v2_values <- eventReactive(input$rte_v2_submit, {
    
    rte_v2_data <- data.frame(
      task_id = c("rte_v2"),
      text_rte_v2_person = c(input$text_rte_v2_person),
      text_rte_v2_site = c(input$text_rte_v2_site),
      text_rte_v2_date = Sys.time(),#format(as.Date(input$text_rte_v2_date, origin="2023-01-01")),
      
      rte_v2_sctr_success = c(input$radio_rte_v2_sctr_success),
      rte_v2_sctr_grasp = c(input$radio_rte_v2_sctr_grasp),
      rte_v2_sctl_success = c(input$radio_rte_v2_sctl_success),
      rte_v2_sctl_grasp = c(input$radio_rte_v2_sctl_grasp),
      
      rte_v2_lctr_success = c(input$radio_rte_v2_lctr_success),
      rte_v2_lctr_grasp = c(input$radio_rte_v2_lctr_grasp),
      rte_v2_lctl_success = c(input$radio_rte_v2_lctl_success),
      rte_v2_lctl_grasp = c(input$radio_rte_v2_lctl_grasp)
      
      
    ) %>%
      mutate(
        rte_v2_sctr_success = as.numeric(rte_v2_sctr_success),
        rte_v2_sctr_grasp = as.numeric(rte_v2_sctr_grasp),
        rte_v2_sctl_success = as.numeric(rte_v2_sctl_success),
        rte_v2_sctl_grasp = as.numeric(rte_v2_sctl_grasp),
        
        rte_v2_lctr_success = as.numeric(rte_v2_lctr_success),
        rte_v2_lctr_grasp = as.numeric(rte_v2_lctr_grasp),
        rte_v2_lctl_success = as.numeric(rte_v2_lctl_success),
        rte_v2_lctl_grasp = as.numeric(rte_v2_lctl_grasp)
        
      )
    
    rte_key_df <- data.frame(
      K_SCTR_Success = c(4),
      K_SCTR_Grasp = c(2),
      K_SCTL_Success = c(4),
      K_SCTL_Grasp = c(3),
      
      K_LCTR_Success = c(5),
      K_LCTR_Grasp = c(3),
      K_LCTL_Success = c(5),
      K_LCTL_Grasp = c(2)
    )
    
    rte_v2_combined <- cbind(rte_v2_data, rte_key_df) %>% 
      mutate(Score_rte_v2_sctr_success = ifelse(rte_v2_sctr_success == K_SCTR_Success, 1, 0),
             Score_rte_v2_sctr_grasp = ifelse(rte_v2_sctr_grasp == K_SCTR_Grasp, 1, 0),
             Score_rte_v2_sctl_success = ifelse(rte_v2_sctl_success == K_SCTL_Success, 1, 0),
             Score_rte_v2_sctl_grasp = ifelse(rte_v2_sctl_grasp == K_SCTL_Grasp, 1, 0),
             
             Score_rte_v2_lctr_success = ifelse(rte_v2_lctr_success == K_LCTR_Success, 1, 0),
             Score_rte_v2_lctr_grasp = ifelse(rte_v2_lctr_grasp == K_LCTR_Grasp, 1, 0),
             Score_rte_v2_lctl_success = ifelse(rte_v2_lctl_success == K_LCTL_Success, 1, 0),
             Score_rte_v2_lctl_grasp = ifelse(rte_v2_lctl_grasp == K_LCTL_Grasp, 1, 0),
             
             Score_rte_v2 = sum(Score_rte_v2_sctr_success, Score_rte_v2_sctr_grasp, 
                                Score_rte_v2_sctl_success, Score_rte_v2_sctl_grasp, 
                                Score_rte_v2_lctr_success, Score_rte_v2_lctr_grasp, 
                                Score_rte_v2_lctl_success, Score_rte_v2_lctl_grasp 
             ),
             Score_rte_v2 = round(Score_rte_v2 / 8 , 3)
      ) 
    
    rte_v2_upload <- rte_v2_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("rte_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 8), rep("Answer", 8), rep("Score", 8), "Overall")
      ) %>% 
      rename(name = text_rte_v2_person,
             site = text_rte_v2_site,
             date = text_rte_v2_date) %>% 
      filter(key != "Answer") 
    
    rte_v2_upload <- as.data.frame(rte_v2_upload)
    
    sheet_append(ss = sheet_id,
                 data = rte_v2_upload,
                 sheet = "main")
    
    return(rte_v2_combined)
    
  })
  
  output$rte_v2_incorrect <- renderTable({
    rte_v2_data <- rte_v2_values()
    
    return_rte_v2 <- rte_v2_data %>% 
      mutate(rte_v2_sctr_success = factor(rte_v2_sctr_success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTR_Success = factor(K_SCTR_Success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_sctr_grasp = factor(rte_v2_sctr_grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTR_Grasp = factor(K_SCTR_Grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v2_sctl_success = factor(rte_v2_sctl_success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTL_Success = factor(K_SCTL_Success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_sctl_grasp = factor(rte_v2_sctl_grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTL_Grasp = factor(K_SCTL_Grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v2_lctr_success = factor(rte_v2_lctr_success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_LCTR_Success = factor(K_LCTR_Success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_lctr_grasp = factor(rte_v2_lctr_grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_LCTR_Grasp = factor(K_LCTR_Grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v2_lctl_success = factor(rte_v2_lctl_success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_LCTL_Success = factor(K_LCTL_Success, app_values_0_5, c("Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_lctl_grasp = factor(rte_v2_lctl_grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_LCTL_Grasp = factor(K_LCTL_Grasp, app_values_1_3, c("Palmer grip", "Multi-finger grip", "Thumb & finger grip"))
      ) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_rte_v2)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("rte_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6",
                         "Q7", "Q8"), 3)),
             type = c(rep("Response", 8), rep("Answer", 8), rep("Score", 8))
      ) %>% 
      select(-c(task_id:text_rte_v2_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_rte_v2) 
  })
  
  output$rte_v2_score <- renderText({
    
    rte_v2_data <- rte_v2_values()
    
    percent_correct <- rte_v2_data$Score_rte_v2 * 100
    
    return(paste0(percent_correct, "%"))
  })
  

## Sit and Stand data ------
  ### Video 1 ------
  sas_v1_values <- eventReactive(input$sas_v1_submit, {

    sas_v1_data <- data.frame(
      task_id = c("sas_v1"),
      text_sas_v1_person = c(input$text_sas_v1_person),
      text_sas_v1_site = c(input$text_sas_v1_site),
      text_sas_v1_date = Sys.time(),#format(as.Date(input$text_sas_v1_date, origin="2023-01-01")),

      sas_v1_usit_q1 = c(input$radio_sas_v1_usit_q1),
      sas_v1_usit_q2_start = as.numeric(c(input$radio_sas_v1_usit_q2_starttime)),
      sas_v1_usit_q2_end = as.numeric(c(input$radio_sas_v1_usit_q2_endtime))
      ) %>%
      mutate(
        sas_v1_usit_q1 = as.numeric(sas_v1_usit_q1)
      )

    sas_key_df <- data.frame(
      K_Usit_Q1 = c(3),
      K_Usit_Q2_St = c(.40),
      K_Usit_Q2_End = c(.44)
    )

    sas_v1_combined <- cbind(sas_v1_data, sas_key_df) %>% 
      mutate(Score_sas_v1_usit_q1 = ifelse(sas_v1_usit_q1 == K_Usit_Q1, 
                                           1, 0),
             Score_sas_v1_usit_q2_start = ifelse(between(sas_v1_usit_q2_start, K_Usit_Q2_St - 0.01, K_Usit_Q2_St + 0.01), 1, 
                                                 ifelse(sas_v1_usit_q2_start == K_Usit_Q2_St - 0.02, 0.5,
                                                        ifelse(sas_v1_usit_q2_start == K_Usit_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v1_usit_q2_end = ifelse(between(sas_v1_usit_q2_end, K_Usit_Q2_End - 0.01, K_Usit_Q2_End + 0.01), 1, 
                                               ifelse(sas_v1_usit_q2_end == K_Usit_Q2_End - 0.02, 0.5,
                                                      ifelse(sas_v1_usit_q2_end == K_Usit_Q2_End + 0.02, 0.5, 0))),
             Score_sas_v1 = sum(Score_sas_v1_usit_q1, Score_sas_v1_usit_q2_start, Score_sas_v1_usit_q2_end),
             Score_sas_v1 = round(Score_sas_v1 / 3, 3)
      ) 

    sas_v1_upload <- sas_v1_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 3), rep("Answer", 3), rep("Score", 3), "Overall")
      ) %>% 
      rename(name = text_sas_v1_person,
             site = text_sas_v1_site,
             date = text_sas_v1_date) %>% 
      filter(key != "Answer") 
    
    sas_v1_upload <- as.data.frame(sas_v1_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v1_upload,
                 sheet = "main")
    
    return(sas_v1_combined)

  })

  output$sas_v1_incorrect <- renderTable({
    sas_v1_data <- sas_v1_values()
    
    return_sas_v1 <- sas_v1_data %>% 
      mutate(sas_v1_usit_q1 = factor(sas_v1_usit_q1, app_values_1_5,
                                     c("Non-compliant", "Fell", "Used hands for support",
                                       "Sat without support", "Shifted to prone")),
             K_Usit_Q1 = factor(K_Usit_Q1, app_values_1_5,
                                c("Non-compliant", "Fell", "Used hands for support",
                                  "Sat without support", "Shifted to prone"))) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v1)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Q1", "Q2", "Q3"), 3)),
             type = c(rep("Response", 3), rep("Answer", 3), rep("Score", 3))
      ) %>% 
      select(-c(task_id:text_sas_v1_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v1) 
  })

  output$sas_v1_score <- renderText({

    sas_v1_data <- sas_v1_values()

        percent_correct <- sas_v1_data$Score_sas_v1 * 100

        return(paste0(percent_correct, "%"))
  })

  
  
  

  ### Video 2 ------
  
  sas_v2_values <- eventReactive(input$sas_v2_submit, {
    
    sas_v2_data <- data.frame(
      task_id = c("sas_v2"),
      text_sas_v2_person = c(input$text_sas_v2_person),
      text_sas_v2_site = c(input$text_sas_v2_site),
      text_sas_v2_date = Sys.time(),#format(as.Date(input$text_sas_v2_date, origin="2023-01-01")),
      
      sas_v2_std_q1 = c(input$radio_sas_v2_std_q1),
      sas_v2_std_q2_start = as.numeric(c(input$radio_sas_v2_std_q2_starttime)),
      sas_v2_std_q2_end = as.numeric(c(input$radio_sas_v2_std_q2_endtime)),
      
      sas_v2_std_q3 = c(input$radio_sas_v2_std_q3),
      sas_v2_std_q4_start = as.numeric(c(input$radio_sas_v2_std_q4_starttime)),
      sas_v2_std_q4_end = as.numeric(c(input$radio_sas_v2_std_q4_endtime))
    ) %>%
      mutate(
        sas_v2_std_q1 = as.numeric(sas_v2_std_q1),
        sas_v2_std_q3 = as.numeric(sas_v2_std_q3)
      )
    
    sas_key_df <- data.frame(
      K_StD_Q1 = c(4),
      K_StD_Q2_St = c(.15),
      K_StD_Q2_End = c(.25),
      K_StD_Q3 = c(4),
      K_StD_Q4_St = c(.32),
      K_StD_Q4_End = c(.34)
    )
    
    sas_v2_combined <- cbind(sas_v2_data, sas_key_df) %>% 
      mutate(Score_sas_v2_std_q1 = ifelse(sas_v2_std_q1 == K_StD_Q1, 
                                          1, 0),
             Score_sas_v2_std_q2_start = ifelse(between(sas_v2_std_q2_start, K_StD_Q2_St - 0.01, K_StD_Q2_St + 0.01), 1, 
                                                ifelse(sas_v2_std_q2_start == K_StD_Q2_St - 0.02, 0.5,
                                                       ifelse(sas_v2_std_q2_start == K_StD_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v2_std_q2_end = ifelse(between(sas_v2_std_q2_end, K_StD_Q2_End - 0.01, K_StD_Q2_End + 0.01), 1, 
                                              ifelse(sas_v2_std_q2_end == K_StD_Q2_End - 0.02, 0.5,
                                                     ifelse(sas_v2_std_q2_end == K_StD_Q2_End + 0.02, 0.5, 0))),
             
             Score_sas_v2_std_q3 = ifelse(sas_v2_std_q3 == K_StD_Q3, 
                                          1, 0),
             Score_sas_v2_std_q4_start = ifelse(between(sas_v2_std_q4_start, K_StD_Q4_St - 0.01, K_StD_Q4_St + 0.01), 1, 
                                                ifelse(sas_v2_std_q4_start == K_StD_Q4_St - 0.02, 0.5,
                                                       ifelse(sas_v2_std_q4_start == K_StD_Q4_St + 0.02, 0.5, 0))),
             Score_sas_v2_std_q4_end = ifelse(between(sas_v2_std_q4_end, K_StD_Q4_End - 0.01, K_StD_Q4_End + 0.01), 1, 
                                              ifelse(sas_v2_std_q4_end == K_StD_Q4_End - 0.02, 0.5,
                                                     ifelse(sas_v2_std_q4_end == K_StD_Q4_End + 0.02, 0.5, 0))),
             
             Score_sas_v2 = sum(Score_sas_v2_std_q1, Score_sas_v2_std_q2_start, Score_sas_v2_std_q2_end,
                                      Score_sas_v2_std_q3, Score_sas_v2_std_q4_start, Score_sas_v2_std_q4_end),
             Score_sas_v2 = round(Score_sas_v2 / 6 , 3)
      ) 
    
    sas_v2_upload <- sas_v2_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6), "Overall")
      ) %>% 
      rename(name = text_sas_v2_person,
             site = text_sas_v2_site,
             date = text_sas_v2_date) %>% 
      filter(key != "Answer") 
    
    sas_v2_upload <- as.data.frame(sas_v2_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v2_upload,
                 sheet = "main")
    
    return(sas_v2_combined)
    
  })
  
  output$sas_v2_incorrect <- renderTable({
    sas_v2_data <- sas_v2_values()
    
    return_sas_v2 <- sas_v2_data %>% 
      mutate(sas_v2_std_q1 = factor(sas_v2_std_q1, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet together")),
             K_StD_Q1 = factor(K_StD_Q1, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet together")),
             sas_v2_std_q3 = factor(sas_v2_std_q3, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet tandem")),
             K_StD_Q3 = factor(K_StD_Q3, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet tandem"))
      ) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v2)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6"), 3)),
             type = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6))
      ) %>% 
      select(-c(task_id:text_sas_v2_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v2) 
  })
  
  output$sas_v2_score <- renderText({
    
    sas_v2_data <- sas_v2_values()
    
    percent_correct <- sas_v2_data$Score_sas_v2 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  ### Video 3 ------
  
  sas_v3_values <- eventReactive(input$sas_v3_submit, {
    
    sas_v3_data <- data.frame(
      task_id = c("sas_v3"),
      text_sas_v3_person = c(input$text_sas_v3_person),
      text_sas_v3_site = c(input$text_sas_v3_site),
      text_sas_v3_date = Sys.time(),#format(as.Date(input$text_sas_v3_date, origin="2023-01-01")),
      
      sas_v3_pts_q1 = c(input$radio_sas_v3_pts_q1),
      sas_v3_usit_q1 = c(input$radio_sas_v3_usit_q1),
      sas_v3_usit_q2_start = as.numeric(c(input$radio_sas_v3_usit_q2_starttime)),
      sas_v3_usit_q2_end = as.numeric(c(input$radio_sas_v3_usit_q2_endtime))
    ) %>%
      mutate(
        sas_v3_pts_q1 = as.numeric(sas_v3_pts_q1),
        sas_v3_usit_q1 = as.numeric(sas_v3_usit_q1)
      )
    
    sas_key_df <- data.frame(
      K_PtS_Q1 = c(2),
      K_Usit_Q1 = c(2),
      K_Usit_Q2_St = c(.39),
      K_Usit_Q2_End = c(.39)
    )
    
    sas_v3_combined <- cbind(sas_v3_data, sas_key_df) %>% 
      mutate(Score_sas_v3_pts_q1 = ifelse(sas_v3_pts_q1 == K_PtS_Q1, 
                                          1, 0),
             Score_sas_v3_usit_q1 = ifelse(sas_v3_usit_q1 == K_Usit_Q1, 
                                           1, 0),
             Score_sas_v3_usit_q2_start = ifelse(between(sas_v3_usit_q2_start, K_Usit_Q2_St - 0.01, K_Usit_Q2_St + 0.01), 1, 
                                                 ifelse(sas_v3_usit_q2_start == K_Usit_Q2_St - 0.02, 0.5,
                                                        ifelse(sas_v3_usit_q2_start == K_Usit_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v3_usit_q2_end = ifelse(between(sas_v3_usit_q2_end, K_Usit_Q2_End - 0.01, K_Usit_Q2_End + 0.01), 1, 
                                               ifelse(sas_v3_usit_q2_end == K_Usit_Q2_End - 0.02, 0.5,
                                                      ifelse(sas_v3_usit_q2_end == K_Usit_Q2_End + 0.02, 0.5, 0))),
             Score_sas_v3 = sum(Score_sas_v3_pts_q1, Score_sas_v3_usit_q1, Score_sas_v3_usit_q2_start, Score_sas_v3_usit_q2_end),
             Score_sas_v3 = round(Score_sas_v3 / 4, 3)
      ) 
    
    sas_v3_upload <- sas_v3_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 4), rep("Answer", 4), rep("Score", 4), "Overall")
      ) %>% 
      rename(name = text_sas_v3_person,
             site = text_sas_v3_site,
             date = text_sas_v3_date) %>% 
      filter(key != "Answer") 
    
    sas_v3_upload <- as.data.frame(sas_v3_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v3_upload,
                 sheet = "main")
    
    return(sas_v3_combined)
    
  })
  
  output$sas_v3_incorrect <- renderTable({
    sas_v3_data <- sas_v3_values()
    
    return_sas_v3 <- sas_v3_data %>% 
      mutate(sas_v3_pts_q1 = factor(sas_v3_pts_q1, app_values_1_2,
                                    c("No", "Yes")),
             sas_v3_usit_q1 = factor(sas_v3_usit_q1, app_values_1_5,
                                     c("Non-compliant", "Fell", "Used hands for support",
                                       "Sat without support", "Shifted to prone")),
             K_Usit_Q1 = factor(K_Usit_Q1, app_values_1_5,
                                c("Non-compliant", "Fell", "Used hands for support",
                                  "Sat without support", "Shifted to prone"))) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v3)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4"), 3)),
             type = c(rep("Response", 4), rep("Answer", 4), rep("Score", 4))
      ) %>% 
      select(-c(task_id:text_sas_v3_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v3) 
  })
  
  output$sas_v3_score <- renderText({
    
    sas_v3_data <- sas_v3_values()
    
    percent_correct <- sas_v3_data$Score_sas_v3 * 100
    
    return(paste0(percent_correct, "%"))
  })
  
  
  ### Video 4 ------
  sas_v4_values <- eventReactive(input$sas_v4_submit, {
    
    sas_v4_data <- data.frame(
      task_id = c("sas_v4"),
      text_sas_v4_person = c(input$text_sas_v4_person),
      text_sas_v4_site = c(input$text_sas_v4_site),
      text_sas_v4_date = Sys.time(),#format(as.Date(input$text_sas_v4_date, origin="2023-01-01")),
      
      sas_v4_std_q1 = c(input$radio_sas_v4_std_q1),
      sas_v4_std_q2_start = as.numeric(c(input$radio_sas_v4_std_q2_starttime)),
      sas_v4_std_q2_end = as.numeric(c(input$radio_sas_v4_std_q2_endtime)),
      
      sas_v4_std_q3 = c(input$radio_sas_v4_std_q3),
      sas_v4_std_q4_start = as.numeric(c(input$radio_sas_v4_std_q4_starttime)),
      sas_v4_std_q4_end = as.numeric(c(input$radio_sas_v4_std_q4_endtime))
    ) %>%
      mutate(
        sas_v4_std_q1 = as.numeric(sas_v4_std_q1),
        sas_v4_std_q3 = as.numeric(sas_v4_std_q3)
      )
    
    sas_key_df <- data.frame(
      K_StD_Q1 = c(5),
      K_StD_Q2_St = c(.21),
      K_StD_Q2_End = c(.51),
      K_StD_Q3 = c(5),
      K_StD_Q4_St = c(1.36),
      K_StD_Q4_End = c(2.34)
    )
    
    sas_v4_combined <- cbind(sas_v4_data, sas_key_df) %>% 
      mutate(Score_sas_v4_std_q1 = ifelse(sas_v4_std_q1 == K_StD_Q1, 
                                          1, 0),
             Score_sas_v4_std_q2_start = ifelse(between(sas_v4_std_q2_start, K_StD_Q2_St - 0.01, K_StD_Q2_St + 0.01), 1, 
                                                ifelse(sas_v4_std_q2_start == K_StD_Q2_St - 0.02, 0.5,
                                                       ifelse(sas_v4_std_q2_start == K_StD_Q2_St + 0.02, 0.5, 0))),
             Score_sas_v4_std_q2_end = ifelse(between(sas_v4_std_q2_end, K_StD_Q2_End - 0.01, K_StD_Q2_End + 0.01), 1, 
                                              ifelse(sas_v4_std_q2_end == K_StD_Q2_End - 0.02, 0.5,
                                                     ifelse(sas_v4_std_q2_end == K_StD_Q2_End + 0.02, 0.5, 0))),
             
             Score_sas_v4_std_q3 = ifelse(sas_v4_std_q3 == K_StD_Q3, 
                                          1, 0),
             Score_sas_v4_std_q4_start = ifelse(between(sas_v4_std_q4_start, K_StD_Q4_St - 0.01, K_StD_Q4_St + 0.01), 1, 
                                                ifelse(sas_v4_std_q4_start == K_StD_Q4_St - 0.02, 0.5,
                                                       ifelse(sas_v4_std_q4_start == K_StD_Q4_St + 0.02, 0.5, 0))),
             Score_sas_v4_std_q4_end = ifelse(between(sas_v4_std_q4_end, K_StD_Q4_End - 0.01, K_StD_Q4_End + 0.01), 1, 
                                              ifelse(sas_v4_std_q4_end == K_StD_Q4_End - 0.02, 0.5,
                                                     ifelse(sas_v4_std_q4_end == K_StD_Q4_End + 0.02, 0.5, 0))),
             
             Score_sas_v4 = sum(Score_sas_v4_std_q1, Score_sas_v4_std_q2_start, Score_sas_v4_std_q2_end,
                                Score_sas_v4_std_q3, Score_sas_v4_std_q4_start, Score_sas_v4_std_q4_end),
             Score_sas_v4 = round(Score_sas_v4 / 6 , 3)
      ) 
    
    sas_v4_upload <- sas_v4_combined %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "item_id",
                   values_to = "value"
      ) %>% 
      mutate(key = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6), "Overall")
      ) %>% 
      rename(name = text_sas_v4_person,
             site = text_sas_v4_site,
             date = text_sas_v4_date) %>% 
      filter(key != "Answer") 
    
    sas_v4_upload <- as.data.frame(sas_v4_upload)
    
    sheet_append(ss = sheet_id,
                 data = sas_v4_upload,
                 sheet = "main")
    
    return(sas_v4_combined)
    
  })
  
  output$sas_v4_incorrect <- renderTable({
    sas_v4_data <- sas_v4_values()
    
    return_sas_v4 <- sas_v4_data %>% 
      mutate(sas_v4_std_q1 = factor(sas_v4_std_q1, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet together")),
             K_StD_Q1 = factor(K_StD_Q1, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet together")),
             sas_v4_std_q3 = factor(sas_v4_std_q3, app_values_1_5,
                                    c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet tandem")),
             K_StD_Q3 = factor(K_StD_Q3, app_values_1_5,
                               c("Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet tandem"))
      ) %>% 
      mutate_all(as.character) %>% 
      select(-c(Score_sas_v4)) %>% 
      pivot_longer(., 
                   cols = c(starts_with("sas_v"), starts_with("K_"), starts_with("Score")), 
                   names_to = "Question",
                   values_to = "Score"
      ) %>% 
      mutate(Q = c(rep(c("Q1", "Q2", "Q3", "Q4", "Q5", "Q6"), 3)),
             type = c(rep("Response", 6), rep("Answer", 6), rep("Score", 6))
      ) %>% 
      select(-c(task_id:text_sas_v4_date, Question)) %>% 
      rename(Question = Q) %>% 
      pivot_wider(., 
                  id_cols = Question,
                  names_from = type,
                  values_from = Score) %>% 
      select(Question, Response, Answer, Score) %>% 
      filter(Score != 1) 
    
    return(return_sas_v4) 
  })
  
  output$sas_v4_score <- renderText({
    
    sas_v4_data <- sas_v4_values()
    
    percent_correct <- sas_v4_data$Score_sas_v4 * 100
    
    return(paste0(percent_correct, "%"))
  })
  



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
