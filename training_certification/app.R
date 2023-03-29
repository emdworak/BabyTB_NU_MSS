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


radio_labels <- c("Yes", "No", "NA")
radio_values <- c(1, 0, NA)
app_values2_noNA <- c(1, 0)
app_values2 <- c(NA, 1, 0)
app_values3 <- c(NA, 0, 1, 2)
app_values3_no0 <- c(NA, 1, 2)
app_values4 <- c(NA, 0, 1, 2, 3)
app_values4_no0 <- c(NA, 1, 2, 3)
app_values5 <- c(NA, 0, 1, 2, 3, 4)
app_values5_no0 <- c(NA, 1, 2, 3, 4)
app_values6 <- c(NA, 1, 2, 3, 4, 5)
app_values7 <- c(NA, 1, 2, 3, 4, 5, 6)
app_values8 <- c(NA, 1, 2, 3, 4, 5, 6, 7)
app_values9 <- c(NA, 1, 2, 3, 4, 5, 6, 7, 8)
app_values10 <- c(NA, 1, 2, 3, 4, 5, 6, 7, 8, 9)

# Define the UI -----

## Set up the menu / navigation bar -----
ui <- dashboardPage(
  dashboardHeader(title = "BabyTB Training Scoring Certification"),

  dashboardSidebar(
    width = 300,
    tags$head(
      tags$style("@import url(https://use.fontawesome.com/releases/v6.2.1/css/all.css);")
      ),

    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),

      menuItem("Social Observational (younger)", tabName = "som_younger", icon = icon("cubes-stacked"),
               menuSubItem("Video 1: Social Observational", tabName = "tab_somY_v1", icon = icon("cubes-stacked")),
               menuSubItem("Video 2: Social Observational", tabName = "tab_somY_v2", icon = icon("cubes-stacked"))
               ),

      menuItem("Social Observational (older)", tabName = "som_older", icon = icon("cubes-stacked"),
               menuSubItem("Video 1: Social Observational", tabName = "tab_somO_v1", icon = icon("cubes-stacked")),
               menuSubItem("Video 2: Social Observational", tabName = "tab_somO_v2", icon = icon("cubes-stacked"))
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

              p("This application is intended to help certify examiners undergoing training in the administration of the NIH BabyTB."),

              p("More details will be added "),
              
              dataTableOutput("test")

      ),


## Social Observational (younger) page ------

### Video 1: SOM (younger) -----
tabItem(tabName = "tab_somY_v1",

        h2("Certification Checklist for Social Observational (ages 9-23 months)"),

        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_sobY_v1_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sobY_v1_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sobY_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 numericInput("text_sobY_v1_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Communicative Temptation 1: Minute One"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_1", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_2", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_3", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_4", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_5", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_6", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_7", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Response to Name & Gaze/Point 1: Minute Two"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_9", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_10", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_11", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_12", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_13", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_14", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_15", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_16", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_17", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


          h3("Communication Temptation 2: Minute Three"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_19", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_20", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_21", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_22", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_23", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_24", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_25", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        h3("Communicative Temptation 3, probe 2: Minute Four"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_27", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_28", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_29", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_30", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_31", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_32", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_33", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_34", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_35", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Sharing Books 1: Minute Five"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_37", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_38", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_39", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_40", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_41", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_43", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Sharing Books 2: Minute Six"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_45", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_46", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_47", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_48", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_49", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_50", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_51", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 1: Minute Seven"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_53", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_54", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_56", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_57", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Parent/Caregiver-Child Play 2: Minute Eight"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_66", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_67", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
         column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_69", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_70", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 3: Minute Nine"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_79", p("Explores features of object"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_80", p("Uses item functionally"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_82", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                   radioButtons("radio_sobY_v1_SO_9_23_83", p("2 Pretend action sequences."),
                                choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
            )
            ),



        h3("Parent/Caregiver-Child Play 4: Minute Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_92", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_93", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_95", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v1_SO_9_23_96", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobY_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sobY_score"))
        )
),

### Video 2: SOM (younger) -----
tabItem(tabName = "tab_somY_v2",

        h2("Certification Checklist for Social Observational (ages 9-23 months)"),

        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_sobY_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sobY_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sobY_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 numericInput("text_sobY_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Communicative Temptation 1: Minute One"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_1", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_2", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_3", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_4", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_5", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_6", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_7", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Response to Name & Gaze/Point 1: Minute Two"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_9", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_10", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_11", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_12", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_13", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_14", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_15", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_16", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_17", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Communication Temptation 2: Minute Three"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_19", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_20", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_21", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_22", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_23", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_24", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_25", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        h3("Communicative Temptation 3, probe 2: Minute Four"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_27", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_28", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_29", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_30", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_31", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_32", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_33", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_34", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_35", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Sharing Books 1: Minute Five"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_37", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_38", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_39", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_40", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_41", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_43", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Sharing Books 2: Minute Six"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_45", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_46", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_47", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_48", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_49", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_50", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_51", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 1: Minute Seven"),


        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_53", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_54", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_56", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_57", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Parent/Caregiver-Child Play 2: Minute Eight"),

        fluidRow(

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_66", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_67", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_69", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_70", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Parent/Caregiver-Child Play 3: Minute Nine"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_79", p("Explores features of object"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_80", p("Uses item functionally"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_82", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_83", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Parent/Caregiver-Child Play 4: Minute Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_92", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_93", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_95", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobY_v2_SO_9_23_96", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobY_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sobY_score"))
        )
),

## Social Observational (older) page ------
### Video 1: SOM (older) -----
tabItem(tabName = "tab_somO_v1",

        h2("Certification Checklist for Social Observational (ages 24 months and older)"),

        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_sobO_v1_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sobO_v1_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sobO_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_sobO_v1_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Joint Attention: Minute One"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_1", p("Following point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_2", p("Complies with request (pot) spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_3", p("Complies with request after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_4", p("Comments on jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_5", p("Points to jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_6", p("Shows jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Pretend Play: Minutes Two-Three"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_7", p("Child-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_8", p("Substitution."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_9", p("Substitution without object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_10", p("Dolls-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_11", p("Socio-dramatic play."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Prosocial Behavior: Minutes Four-Five"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_12", p("Shares blocks."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_13", p("Takes turns building tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_15", p("Concerned facial expression."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_16", p("Verbal concern/comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_17", p("Physical comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_18", p("Helps clean up spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_19",  p("Helps clean up after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),




        h3("Social Communication 1: Minutes Six-Seven"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_21", p("Rebuilds elephant all steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_22", p("Steps in correct order."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_23", p("Asks for help opening container."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Social Communications 2: Minutes Eight-Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_24", p("Initiates/responds to conversation."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_25", p("Takes a conversational turn."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_26", p("Responds to a shift in topic."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_27", p("Corrects mislabeling by protest only."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_29", p("Adapts speech register for doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_30", p("Turns book to face doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v1_SO_24_48_31", p("Attempts to teach doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
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
        )
),



### Video 2: SOM (older) -----
tabItem(tabName = "tab_somO_v2",

        h2("Certification Checklist for Social Observational (ages 24 months and older)"),

        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_sobO_v2_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sobO_v2_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sobO_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_sobO_v2_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Joint Attention: Minute One"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_1", p("Following point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_2", p("Complies with request (pot) spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_3", p("Complies with request after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_4", p("Comments on jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_5", p("Points to jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_6", p("Shows jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),


        h3("Pretend Play: Minutes Two-Three"),


        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_7", p("Child-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_8", p("Substitution."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_9", p("Substitution without object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_10", p("Dolls-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_11", p("Socio-dramatic play."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Prosocial Behavior: Minutes Four-Five"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_12", p("Shares blocks."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_13", p("Takes turns building tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_15", p("Concerned facial expression."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_16", p("Verbal concern/comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_17", p("Physical comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_18", p("Helps clean up spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_19",  p("Helps clean up after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),




        h3("Social Communication 1: Minutes Six-Seven"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_21", p("Rebuilds elephant all steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_22", p("Steps in correct order."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_23", p("Asks for help opening container."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),



        h3("Social Communications 2: Minutes Eight-Ten"),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_24", p("Initiates/responds to conversation."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_25", p("Takes a conversational turn."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_26", p("Responds to a shift in topic."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_27", p("Corrects mislabeling by protest only."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_29", p("Adapts speech register for doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_30", p("Turns book to face doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          ),

          column(4,
                 radioButtons("radio_sobO_v2_SO_24_48_31", p("Attempts to teach doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
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
        )
),


## Get Up and Go page ------

### Video 1: GUG -----
tabItem(tabName = "tab_gug_v1",

        h2("Certification Checklist for Get Up and Go"),
        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_gug_v1_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_gug_v1_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_gug_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_gug_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),



        h3("Pre-Locomotion (PL) Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_back", p("Did child get off back?"),
                              choiceNames = c("NA", "No (didn’t try)", "No (tried but couldn’t)", "Yes"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_prone", p("What child did on belly?"),
                              choiceNames = c("NA", "Nothing, did not lift head",
                                              "Lifted head only", "Propped on forearms",
                                              "Rolled onto back", "Propped on hands",
                                              "Took steps or got off belly"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_roll", p("How child got off back? "),
                              choiceNames = c("NA", "Rolled to belly, hands trapped",
                                              "Rolled to belly, hands out", "Rolled to hands-knees",
                                              "Side lying", "Got up without rolling"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_uppos", p("Most upright postures?"),
                              choiceNames = c("NA", "Belly", "Hands-knees or hands-feet",
                                              "Sit or kneel, back vertical", "Stand"),
                              choiceValues = app_values5_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_sit", p("How child got to sit or kneel?"),
                              choiceNames = c("NA", "Pushed up from crawl",
                                              "Pushed up from side lying", "Sat up directly from supine"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),


        h3("Locomotion (LO) version"),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_stand", p("How child got to standing?"),
                              choiceNames = c("NA", "Down-dog to stand",
                                              "Half-kneel to stand", "Squat to stand"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_hands", p("How many hands child used?"),
                              choiceNames = c("NA", "0",
                                              "1", "2"),
                              choiceValues = app_values3,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_turn", p("Child turned to face finish line? "),
                              choiceNames = c("NA", "Never faced finish",
                                              "Turned to face finish", "Already facing finish"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_trameth", p("How child traveled?"),
                              choiceNames = c("NA", "Did not travel", "log roll",
                                              "belly crawl", "bum shuffle or hitch",
                                              "Hands-knees or hands-feet", "knee-walk or half-kneel",
                                              "walk"),
                              choiceValues = app_values8,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_toes", p("Child walked on toes?"),
                              choiceNames = c("NA", "Can't see heels", "No",
                                              "Right foot", "Left foot",
                                              "Both"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_tradis", p("How far child traveled?"),
                              choiceNames = c("NA",  "Took a few steps and fell",
                                              "Took a few steps and stopped", "3 meters, not continuous",
                                              "3 meters, but dawdled", "3 meters, no dawdling"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v1_starttime", p("When did the child cross start line?", br(),
                                                       "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v1_endtime", p("When did the child cross finish line?", br(),
                                                     "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_tradis", p("How did child get up stair?"),
                              choiceNames = c("NA", "Didn't try", "Did not pull up",
                                              "Pulled up to knees", "Pulled up to stand",
                                              "Climbed up, stayed prone", "Climbed up, stood up",
                                              "Tried to step & fell", "Stepped up, not integrated",
                                              "Stepped up, gait integrated"),
                              choiceValues = app_values10,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_stairdo", p("How did child get down stair?"),
                              choiceNames = c("NA",  "Didn't try to come down",
                                              "Climbed down, fell", "Climbed down, stayed down",
                                              "Walked down, fell", "Walked down, not integrated",
                                              "Walked down, integrated", "Jumped or leaped & fell",
                                              "Jumped or leaped no fall"),
                              choiceValues = app_values9,  selected = "")
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
        )
),


### Video 2: GUG -----
tabItem(tabName = "tab_gug_v2",

        h2("Certification Checklist for Get Up and Go"),
        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_gug_v2_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_gug_v2_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_gug_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_gug_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),



        h3("Pre-Locomotion (PL) Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_back", p("Did child get off back?"),
                              choiceNames = c("NA", "No (didn’t try)", "No (tried but couldn’t)", "Yes"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_prone", p("What child did on belly?"),
                              choiceNames = c("NA", "Nothing, did not lift head",
                                              "Lifted head only", "Propped on forearms",
                                              "Rolled onto back", "Propped on hands",
                                              "Took steps or got off belly"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_roll", p("How child got off back? "),
                              choiceNames = c("NA", "Rolled to belly, hands trapped",
                                              "Rolled to belly, hands out", "Rolled to hands-knees",
                                              "Side lying", "Got up without rolling"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_uppos", p("Most upright postures?"),
                              choiceNames = c("NA", "Belly", "Hands-knees or hands-feet",
                                              "Sit or kneel, back vertical", "Stand"),
                              choiceValues = app_values5_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_sit", p("How child got to sit or kneel?"),
                              choiceNames = c("NA", "Pushed up from crawl",
                                              "Pushed up from side lying", "Sat up directly from supine"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),


        h3("Locomotion (LO) version"),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_stand", p("How child got to standing?"),
                              choiceNames = c("NA", "Down-dog to stand",
                                              "Half-kneel to stand", "Squat to stand"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_hands", p("How many hands child used?"),
                              choiceNames = c("NA", "0",
                                              "1", "2"),
                              choiceValues = app_values3,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_turn", p("Child turned to face finish line? "),
                              choiceNames = c("NA", "Never faced finish",
                                              "Turned to face finish", "Already facing finish"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_trameth", p("How child traveled?"),
                              choiceNames = c("NA", "Did not travel", "log roll",
                                              "belly crawl", "bum shuffle or hitch",
                                              "Hands-knees or hands-feet", "knee-walk or half-kneel",
                                              "walk"),
                              choiceValues = app_values8,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_toes", p("Child walked on toes?"),
                              choiceNames = c("NA", "Can't see heels", "No",
                                              "Right foot", "Left foot",
                                              "Both"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v2_tradis", p("How far child traveled?"),
                              choiceNames = c("NA",  "Took a few steps and fell",
                                              "Took a few steps and stopped", "3 meters, not continuous",
                                              "3 meters, but dawdled", "3 meters, no dawdling"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v2_starttime", p("When did the child cross start line?", br(),
                                                       "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_gug_v2_endtime", p("When did the child cross finish line?", br(),
                                                     "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_tradis", p("How did child get up stair?"),
                              choiceNames = c("NA", "Didn't try", "Did not pull up",
                                              "Pulled up to knees", "Pulled up to stand",
                                              "Climbed up, stayed prone", "Climbed up, stood up",
                                              "Tried to step & fell", "Stepped up, not integrated",
                                              "Stepped up, gait integrated"),
                              choiceValues = app_values10,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_gug_v2_stairdo", p("How did child get down stair?"),
                              choiceNames = c("NA",  "Didn't try to come down",
                                              "Climbed down, fell", "Climbed down, stayed down",
                                              "Walked down, fell", "Walked down, not integrated",
                                              "Walked down, integrated", "Jumped or leaped & fell",
                                              "Jumped or leaped no fall"),
                              choiceValues = app_values9,  selected = "")
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
        )
),

## Reach to Eat page ------

### Video 1: RtE -----
tabItem(tabName = "tab_rte_v1",

        h2("Certification Checklist for Reach to Eat"),
        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_rte_v1_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_rte_v1_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_rte_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_rte_v1_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),




        # h3("Block (BT) Task"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtr_success ", p("Did child reach block with right hand?"),
        #                       choiceNames = c(NA, "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values7,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtl_success ", p("Did child reach block with left hand?"),
        #                       choiceNames = c(NA, "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values7,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtl_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),


        h3("Cheerio Small Base Task"),
        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctl_success ", p("Did child reach small base with left hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),



        # h3("Cheerio Large Base Task"),
        # h4("Right Hand"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctr_success", p("Did child reach large base with right hand?"),
        #                       choiceNames = c(NA, "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values7,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        # h4("Left Hand"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctl_success ", p("Did child reach large base with left hand?"),
        #                       choiceNames = c(NA, "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values7,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lctl_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        #
        h3("Cheerio Spoon Easy & Hard Tasks"),

        h4("Cheerio Spoon Easy (Right Hand)"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnter_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnter_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnter_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(
           column(6,
                 radioButtons("radio_rte_v1_spnter_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnter_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values6,  selected = "")
          )
        ),


        fluidRow(
          h4("Cheerio Spoon Hard (Right Hand)")
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values6,  selected = "")
          )
        ),



          h4("Cheerio Spoon Easy (Left Hand)"),




        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values6,  selected = "")
          )
        ),



          h4("Cheerio Spoon Hard (Left Hand)"),



        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnthl_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"),
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = app_values6,  selected = "")
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
        )
),



### Video 2: RtE -----
tabItem(tabName = "tab_rte_v2",

        h2("Certification Checklist for Reach to Eat"),
        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_rte_v2_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_rte_v2_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_rte_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_rte_v2_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),




        # h3("Block (BT) Task"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_lbtr_success ", p("Did child reach block with right hand?"),
        #                       choiceNames = c(NA, "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values7,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_lbtr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_lbtl_success ", p("Did child reach block with left hand?"),
        #                       choiceNames = c(NA, "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values7,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_lbtl_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),


        h3("Cheerio Small Base Task"),

        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctl_success ", p("Did child reach small base with left hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),



        h3("Cheerio Large Base Task"),

        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctr_success", p("Did child reach large base with right hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctl_success ", p("Did child reach large base with left hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values7,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v2_lctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),


        # h3("Cheerio Spoon Easy & Hard Tasks"),
        #
        # h4("Cheerio Spoon Easy (Right Hand)"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnter_purpose", p("Did child use right hand to move spoon?"),
        #                       choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
        #                                       "Picked up to play", "Grasped Cheerio",
        #                                       "Grasped spoon for transport"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spnter_move", p("Did child use right hand to grasp or move handle?"),
        #                       choiceNames = c(NA, "Grasped handle", "Moved handle"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spnter_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
        #                                       "Adult-like grip"), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnter_thumb", p("Where was right hand thumb pointing?"),
        #                       choiceNames = c(NA, "Away from bowl", "Toward bowl"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnter_success", p("Did child bring cheerio to mouth with right hand?"),
        #                       choiceNames = c(NA, "Didn't try", "Child used restrained hand",
        #                                       "Cheerio fell", "After replacement",
        #                                       "On first attempt"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        # fluidRow(
        #   h4("Cheerio Spoon Hard (Right Hand)")
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthr_purpose", p("Did child use right hand to move spoon?"),
        #                       choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
        #                                       "Picked up to play", "Grasped Cheerio",
        #                                       "Grasped spoon for transport"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthr_move", p("Did child use right hand to grasp or move handle?"),
        #                       choiceNames = c(NA, "Grasped handle", "Moved handle"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
        #                                       "Adult-like grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthr_thumb", p("Where was right hand thumb pointing?"),
        #                       choiceNames = c(NA, "Away from bowl", "Toward bowl"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthr_success", p("Did child bring cheerio to mouth with right hand?"),
        #                       choiceNames = c(NA, "Didn't try", "Child used restrained hand",
        #                                       "Cheerio fell", "After replacement",
        #                                       "On first attempt"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        #
        # h4("Cheerio Spoon Easy (Left Hand)"),
        #
        #
        #
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spntel_purpose", p("Did child use left hand to move spoon?"),
        #                       choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
        #                                       "Picked up to play", "Grasped Cheerio",
        #                                       "Grasped spoon for transport"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spntel_move", p("Did child use left hand to grasp or move handle?"),
        #                       choiceNames = c(NA, "Grasped handle", "Moved handle"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spntel_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
        #                                       "Adult-like grip"), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spntel_thumb", p("Where was left hand thumb pointing?"),
        #                       choiceNames = c(NA, "Away from bowl", "Toward bowl"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spntel_success", p("Did child bring cheerio to mouth with left hand?"),
        #                       choiceNames = c(NA, "Didn't try", "Child used restrained hand",
        #                                       "Cheerio fell", "After replacement",
        #                                       "On first attempt"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        #
        # h4("Cheerio Spoon Hard (Left Hand)"),
        #
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthl_purpose", p("Did child use left hand to move spoon?"),
        #                       choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
        #                                       "Picked up to play", "Grasped Cheerio",
        #                                       "Grasped spoon for transport"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthl_move", p("Did child use left hand to grasp or move handle?"),
        #                       choiceNames = c(NA, "Grasped handle", "Moved handle"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthl_grasp", p("Child used which grasp with left hand?"),
        #                       choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
        #                                       "Adult-like grip" ), choiceValues = app_values4_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthl_thumb", p("Where was left hand thumb pointing?"),
        #                       choiceNames = c(NA, "Away from bowl", "Toward bowl"),
        #                       choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v2_spnthl_success", p("Did child bring cheerio to mouth with left hand?"),
        #                       choiceNames = c(NA, "Didn't try", "Child used restrained hand",
        #                                       "Cheerio fell", "After replacement",
        #                                       "On first attempt"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),


        fluidRow(
          column(1,
                 actionButton(inputId = "rte_v2_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("rte_v2_score"))
        )
),


## Sit and Stand page ------

### Video 1: SaS -----
tabItem(tabName = "tab_sas_v1",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 1"),

        fluidRow(
          column(6,
                 textInput("text_sas_v1_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sas_v1_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sas_v1_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_sas_v1_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        # h3("Pull to Sit"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v1_pts_q1", p("Pull to Sit: head in line with torso?"),
        #                       choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #

        h3("Unsupported Sit"),


        fluidRow(
         column(6,
                 radioButtons("radio_sas_v1_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v1_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                               "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 numericInput("radio_sas_v1_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                             "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        # h3("Unsupported Stand: Feet Apart"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v1_ftapt_q1", p("Feet Apart Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v1_ftapt_q2_starttime", p("Find Timing: When did the child start standing?", br(),
        #                                                         "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v1_ftapt_q2_endtime", p("Find Timing: When did the child stop standing?", br(),
        #                                                       "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        #
        # h3("Unsupported Stand: Feet Together"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_sas_v1_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v1_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
        #                                                       "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v1_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
        #                                                     "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # h3("Unsupported Stand: Tandem Stand"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_sas_v1_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v1_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
        #                                                       "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v1_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
        #                                                     "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v1_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        # h2("Your Score"),
        # fluidRow(
        #   column(12,
        #          verbatimTextOutput("sas_v1_score"))
        # ),

        h4("This will be removed, but it's here to show that the data upload worked")#,

        
        
),


### Video 2: SaS -----
tabItem(tabName = "tab_sas_v2",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 2"),

        fluidRow(
          column(6,
                 textInput("text_sas_v2_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sas_v2_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sas_v2_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_sas_v2_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        # h3("Pull to Sit"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v2_pts_q1", p("Pull to Sit: head in line with torso?"),
        #                       choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #

        # h3("Unsupported Sit"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v2_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
        #                       choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v2_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
        #                                                           "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v2_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
        #                                                         "(End Time in Seconds: XX.XX)"),
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
        #          radioButtons("radio_sas_v2_ftapt_q1", p("Feet Apart Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v2_ftapt_q2_starttime", p("Find Timing: When did the child start standing?", br(),
        #                                                            "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v2_ftapt_q2_endtime", p("Find Timing: When did the child stop standing?", br(),
        #                                                          "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        #
        h3("Unsupported Stand: Feet Together"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v2_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
                                              "Sat without support", "Shifted to prone"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        h3("Unsupported Stand: Tandem Stand"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v2_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
                                              "Sat without support", "Shifted to prone"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v2_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Seconds: XX.XX)"),
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
        )
),

### Video 3: SaS -----
tabItem(tabName = "tab_sas_v3",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 3"),

        fluidRow(
          column(6,
                 textInput("text_sas_v3_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sas_v3_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sas_v3_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_sas_v3_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Pull to Sit"),


        fluidRow(
          column(6,
                 radioButtons("radio_sas_v3_pts_q1", p("Pull to Sit: head in line with torso?"),
                              choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
          )
        ),


        h3("Unsupported Sit"),


        fluidRow(
          column(6,
                 radioButtons("radio_sas_v3_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v3_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                                  "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(
          column(6,
                 numericInput("radio_sas_v3_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                                "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        # h3("Unsupported Stand: Feet Apart"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v3_ftapt_q1", p("Feet Apart Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v3_ftapt_q2_starttime", p("Find Timing: When did the child start standing?", br(),
        #                                                            "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v3_ftapt_q2_endtime", p("Find Timing: When did the child stop standing?", br(),
        #                                                          "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        #
        # h3("Unsupported Stand: Feet Together"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_sas_v3_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v3_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
        #                                                          "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v3_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
        #                                                        "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # h3("Unsupported Stand: Tandem Stand"),
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_sas_v3_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
        #                       choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v3_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
        #                                                          "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v3_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
        #                                                        "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v3_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v3_score"))
        )
),

### Video 4: SaS -----
tabItem(tabName = "tab_sas_v4",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details for Video 4"),

        fluidRow(
          column(6,
                 textInput("text_sas_v4_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sas_v4_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sas_v4_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),

          column(6,
                 numericInput("text_sas_v4_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        # h3("Pull to Sit"),
        #
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_sas_v4_pts_q1", p("Pull to Sit: head in line with torso?"),
        #                       choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
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
        #                       choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v4_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
        #                                                           "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v4_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
        #                                                         "(End Time in Seconds: XX.XX)"),
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
        #                       choiceNames = c(NA, "Non-complaint", "Fell", "Used hands for support",
        #                                       "Sat without support", "Shifted to prone"),
        #                       choiceValues = app_values6,  selected = "")
        #   )
        # ),
        #
        #
        #
        # fluidRow(
        #   column(6,
        #          numericInput("radio_sas_v4_ftapt_q2_starttime", p("Find Timing: When did the child start standing?", br(),
        #                                                            "(Start Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #
        # fluidRow(
        #
        #   column(6,
        #          numericInput("radio_sas_v4_ftapt_q2_endtime", p("Find Timing: When did the child stop standing?", br(),
        #                                                          "(End Time in Seconds: XX.XX)"),
        #                       value = "", min = 0, max = 1800, step = 0.01)
        #   )
        # ),
        #

        h3("Unsupported Stand: Feet Together"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v4_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
                                              "Sat without support", "Shifted to prone"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        h3("Unsupported Stand: Tandem Stand"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v4_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support",
                                              "Sat without support", "Shifted to prone"),
                              choiceValues = app_values6,  selected = "")
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                                 "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),

        fluidRow(

          column(6,
                 numericInput("radio_sas_v4_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                               "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sas_v4_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_v4_score"))
        )
)

## Close to Survey -----
)))


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {

  key <- read_sheet(ss = key_id, sheet = "Sheet1")

# ## Looking While Listening data ------
#
#   lwl_values <- eventReactive(input$lwl_submit, {
#
#     lwl_data <- data.frame(
#       "text_lwl_person" = c(input$text_lwl_person),
#       "text_lwl_site" = c(input$text_lwl_site),
#       "text_lwl_date" = format(as.Date(input$text_lwl_date, origin="2023-01-01")),
#       "text_lwl_certifier" = c(input$text_lwl_certifier),
#       "text_lwl_childAge" = c(input$text_lwl_childAge),
#       "radio_lwl_001" = c(input$radio_lwl_001),
#       "radio_lwl_002" = c(input$radio_lwl_002),
#       "radio_lwl_003" = c(input$radio_lwl_003),
#       "radio_lwl_004" = c(input$radio_lwl_004),
#       "radio_lwl_005" = c(input$radio_lwl_005),
#       "radio_lwl_006" = c(input$radio_lwl_006),
#       "radio_lwl_007" = c(input$radio_lwl_007),
#       "radio_lwl_008" = c(input$radio_lwl_008),
#       "value_lwl_001" = as.numeric(c(input$radio_lwl_001)),
#       "value_lwl_002" = as.numeric(c(input$radio_lwl_002)),
#       "value_lwl_003" = as.numeric(c(input$radio_lwl_003)),
#       "value_lwl_004" = as.numeric(c(input$radio_lwl_004)),
#       "value_lwl_005" = as.numeric(c(input$radio_lwl_005)),
#       "value_lwl_006" = as.numeric(c(input$radio_lwl_006)),
#       "value_lwl_007" = as.numeric(c(input$radio_lwl_007)),
#       "value_lwl_008" = as.numeric(c(input$radio_lwl_008)),
#       "notes_lwl_001" = as.numeric(c(input$text_lwl_001)),
#       "notes_lwl_002" = as.numeric(c(input$text_lwl_002))
#     )
#
#     lwl_data$sum <- rowSums(lwl_data %>% select(starts_with("value_")), na.rm = TRUE) * NA^!rowSums(!is.na(lwl_data %>% select(starts_with("value_"))))
#
#     percent_correct <- round((lwl_data$sum / 8)*100, 2)
#
#     paste0(percent_correct, "%")
#
#   })
#
#   output$lwl_score <- renderText({
#     lwl_values()
#   })
#
# ## Mullen Expressive Language Prompted data ----
#
#   melp_examiner_data <- reactive({
#     req(input$melp_examiner_file)
#
#     melp_exam_df <- read.csv(input$melp_examiner_file$datapath) %>%
#       select(Key, ItemID, Value) %>%
#       filter(Key == "Score") %>%
#       filter(ItemID %in% c("EL7", "EL10", "EL11", "EL15", "EL16")) %>%
#       pivot_wider(names_from = ItemID,
#                   values_from = Value) %>%
#       rename("exam_EL7" = "EL7",
#              "exam_EL10" = "EL10",
#              "exam_EL11" = "EL11",
#              "exam_EL15" = "EL15",
#              "exam_EL16" = "EL16") ## Need to confirm what shows up if the test is NA
#
#     melp_exam_df <- data.frame(melp_exam_df)
#   })
#
#
#   melp_values <- eventReactive(input$melp_submit, {
#
#     melp_data <- data.frame(
#       text_melp_person = c(input$text_melp_person),
#       text_melp_site = c(input$text_melp_site),
#       text_melp_date = format(as.Date(input$text_melp_date, origin="2023-01-01")),
#       text_melp_certifier = c(input$text_melp_certifier),
#       text_melp_childAge = c(input$text_melp_childAge),
#
#       "radio_melp_001" = c(input$radio_melp_001),
#       "radio_melp_002" = c(input$radio_melp_002),
#       "radio_melp_003" = c(input$radio_melp_003),
#       "radio_melp_004" = c(input$radio_melp_004),
#       "radio_melp_005" = c(input$radio_melp_005),
#       "radio_melp_006" = c(input$radio_melp_006),
#       "radio_melp_el7" = c(input$radio_melp_el7),
#       "radio_melp_007" = c(input$radio_melp_007),
#       "radio_melp_008" = c(input$radio_melp_008),
#       "radio_melp_el10" = c(input$radio_melp_el10),
#       "radio_melp_009" = c(input$radio_melp_009),
#       "radio_melp_el11" = c(input$radio_melp_el11),
#       "radio_melp_010" = c(input$radio_melp_010),
#       "radio_melp_el15" = c(input$radio_melp_el15),
#       "radio_melp_011" = c(input$radio_melp_011),
#       "radio_melp_el16" = c(input$radio_melp_el16),
#
#       "value_melp_001" = as.numeric(c(input$radio_melp_001)),
#       "value_melp_002" = as.numeric(c(input$radio_melp_002)),
#       "value_melp_003" = as.numeric(c(input$radio_melp_003)),
#       "value_melp_004" = as.numeric(c(input$radio_melp_004)),
#       "value_melp_005" = as.numeric(c(input$radio_melp_005)),
#       "value_melp_006" = as.numeric(c(input$radio_melp_006)),
#       "value_melp_el7" = as.numeric(c(input$radio_melp_el7)),
#       "value_melp_007" = as.numeric(c(input$radio_melp_007)),
#       "value_melp_008" = as.numeric(c(input$radio_melp_008)),
#       "value_melp_el10" = as.numeric(c(input$radio_melp_el10)),
#       "value_melp_009" = as.numeric(c(input$radio_melp_009)),
#       "value_melp_el11" = as.numeric(c(input$radio_melp_el11)),
#       "value_melp_010" = as.numeric(c(input$radio_melp_010)),
#       "value_melp_el15" = as.numeric(c(input$radio_melp_el15)),
#       "value_melp_011" = as.numeric(c(input$radio_melp_011)),
#       "value_melp_el16" = as.numeric(c(input$radio_melp_el16)),
#
#       "notes_melp_001" = as.numeric(c(input$text_melp_001)),
#       "notes_melp_002" = as.numeric(c(input$text_melp_002))) %>%
#       mutate(radio_melp_el7 = factor(radio_melp_el7, levels = app_values2[-c(1)], labels = c("Yes", "No")),
#              radio_melp_el10 = factor(radio_melp_el10, levels = app_values2[-c(1)], labels = c("Yes", "No")),
#              radio_melp_el11 = factor(radio_melp_el11, levels = app_values4[-c(1)], labels = c("Zero", "One",
#                                                                                                "Two to seven", "Eight or more")),
#              radio_melp_el15 = factor(radio_melp_el15, levels = app_values4[-c(1)], labels = c("No endorsed buttons", "1-3 endorsed buttons",
#                                                                                                "4 or 5 endorsed buttons", "6 endorsed buttons")),
#              radio_melp_el16 = factor(radio_melp_el16, levels = app_values2[-c(1)], labels = c("Does not label labels at least one picture",
#                                                                                       "Labels at least one picture"))
#   ) %>%
#       mutate(scoring_melp_001 = ifelse(is.na(value_melp_001), 1, value_melp_001),
#              scoring_melp_002 = ifelse(is.na(value_melp_002), 1, value_melp_002),
#              scoring_melp_003 = ifelse(is.na(value_melp_003), 1, value_melp_003),
#              scoring_melp_004 = ifelse(is.na(value_melp_004), 1, value_melp_004),
#              scoring_melp_005 = ifelse(is.na(value_melp_005), 1, value_melp_005),
#              scoring_melp_006 = ifelse(is.na(value_melp_006), 1, value_melp_006),
#              scoring_melp_007 = ifelse(is.na(value_melp_007), 1, value_melp_007),
#              scoring_melp_008 = ifelse(is.na(value_melp_008), 1, value_melp_008),
#              scoring_melp_009 = ifelse(is.na(value_melp_009), 1, value_melp_009),
#              scoring_melp_010 = ifelse(is.na(value_melp_010), 1, value_melp_010),
#              scoring_melp_011 = ifelse(is.na(value_melp_011), 1, value_melp_011))
#
#
#     pull_cols <- melp_data %>%
#       select(starts_with("radio_melp_0")) %>%
#       colnames()
#
#     melp_data[,pull_cols] <- lapply(melp_data[,pull_cols],
#                                     factor,
#                                     levels = c(0, 1),
#                                     labels = c("No", "Yes"))
#
#
#     melp_data$sum <- rowSums(melp_data %>% select(starts_with("scoring_melp_0")), na.rm = TRUE) * NA^!rowSums(!is.na(melp_data %>% select(starts_with("scoring_melp_0"))))
#
#     #melp_combined <- cbind(melp_data, melp_examiner_data)
#
#     return(melp_data)#combined)
#
#   })
#
#   # output$test <- renderTable({
#   #   melp_values()
#   # })
#
#   # output$melp_score <- renderText({
#   #
#   #   melp_data <- melp_values()
#   #
#   #   percent_correct <- round((melp_data$sum / 11)*100, 2)
#   #
#   #   return(paste0(percent_correct, "%"))
#   #
#   # })
#
#
## Social Observational (younger) data ------
### Video 1 ------

### Video 2 ------

## Social Observational (older) data ------
  ### Video 1 ------
  ### Video 2 ------

## Get Up and Go data ------
  ### Video 1 ------
  ### Video 2 ------

## Reach to Eat data ------
  ### Video 1 ------
  ### Video 2 ------

## Sit and Stand data ------
  ### Video 1 ------
  #sas_v1_scoring <- reactive({
  # sas_v1_scoring <- eventReactive(input$sas_v1_submit, {
  #   #req(key)
  #
  #   sas_key_df <- key %>%
  #     filter(identifierV == 1) %>%
  #     filter(str_detect(ItemID, "_Q")) %>%
  #     pivot_wider(names_from = ItemID,
  #                 values_from = Value) %>%
  #     rename("K_Usit_Q1" = "Usit_Q1",
  #            "K_Usit_Q2_St" = "Usit_Q2_St",
  #            "K_Usit_Q2_End" = "Usit_Q2_End"
  #            )
  #
  #   sas_key_df <- data.frame(sas_key_df)
  #
  #   return(sas_key_df)
  # })

  # sas_v1_scoring <- eventReactive(input$sas_v1_submit, {
  #   # Read our sheet
  #   key <- read_sheet(ss = key_id,
  #                        sheet = "Sheet1")
  # 
  #   sas_key_df <- key %>%
  #       filter(identifierV == 1) %>%
  #       filter(str_detect(ItemID, "_Q")) %>%
  #       pivot_wider(names_from = ItemID,
  #                   values_from = Value) %>%
  #       rename("K_Usit_Q1" = "Usit_Q1",
  #              "K_Usit_Q2_St" = "Usit_Q2_St",
  #              "K_Usit_Q2_End" = "Usit_Q2_End"
  #              )
  # 
  #     sas_key_df <- data.frame(sas_key_df)
  # 
  #     return(sas_key_df)
  # 
  # })



  output$test <- renderDataTable({
    key#sas_v1_scoring()
      })
  


  ### Video 2 ------
  ### Video 3 ------
  ### Video 4 ------




}

shinyApp(ui, server)


# server <- function(input, output) {
#   data <- read_sheet(ss = key_id, sheet = "Sheet1")
#   
#   output$table <- renderDataTable({
#     data
#   })
# }
# 
# ui <- fluidPage(sidebarLayout(sidebarPanel("Test"),
#                               mainPanel(dataTableOutput('table'))
# )
# )
# 
# shinyApp(ui = ui, server = server)

