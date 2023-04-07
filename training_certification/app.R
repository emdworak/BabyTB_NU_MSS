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
app_values_1_0 <- c(-999, 1, 0)
app_values_0_2 <- c(-999, 0, 1, 2)
app_values_1_2 <- c(-999, 1, 2)
#app_values_0_3 <- c(-999, 0, 1, 2, 3)
app_values_1_3 <- c(-999, 1, 2, 3)
app_values_0_4 <- c(-999, 0, 1, 2, 3, 4)
app_values_1_4 <- c(-999, 1, 2, 3, 4)
app_values_1_5 <- c(-999, 1, 2, 3, 4, 5)
app_values_0_5 <- c(-999, 0, 1, 2, 3, 4, 5)
app_values_1_6 <- c(-999, 1, 2, 3, 4, 5, 6)
app_values_1_7 <- c(-999, 1, 2, 3, 4, 5, 6, 7)
app_values_0_8 <- c(-999, 0, 1, 2, 3, 4, 5, 6, 7, 8)
app_values_1_9 <- c(-999, 1, 2, 3, 4, 5, 6, 7, 8, 9)
app_values_0_3_neg2 <- c(-999, 0, -2, 1, 2, 3)

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

      # menuItem("Social Observational (younger)", tabName = "som_younger", icon = icon("cubes-stacked"),
      #          menuSubItem("Video 1: Social Observational", tabName = "tab_somY_v1", icon = icon("cubes-stacked")),
      #          menuSubItem("Video 2: Social Observational", tabName = "tab_somY_v2", icon = icon("cubes-stacked"))
      #          ),
      # 
      # menuItem("Social Observational (older)", tabName = "som_older", icon = icon("cubes-stacked"),
      #          menuSubItem("Video 1: Social Observational", tabName = "tab_somO_v1", icon = icon("cubes-stacked")),
      #          menuSubItem("Video 2: Social Observational", tabName = "tab_somO_v2", icon = icon("cubes-stacked"))
      # ),

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

              p("More details will be added ")

      ),


# ## Social Observational (younger) page ------
# 
# ### Video 1: SOM (younger) -----
# tabItem(tabName = "tab_somY_v1",
# 
#         h2("Certification Checklist for Social Observational (ages 9-23 months)"),
# 
#         h3("Certification Details for Video 1"),
# 
#         fluidRow(
#           column(6,
#                  textInput("text_sobY_v1_person", h4("Person being certified:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  textInput("text_sobY_v1_site", h4("Site:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  dateInput("text_sobY_v1_date",
#                            label = "Date (yyyy-mm-dd)",
#                            value = Sys.Date()
#                  )
#           ),
# 
# 
#           column(6,
#                  numericInput("text_sobY_v1_childAge", h4("Child Age (in months):"),
#                               value = "", min = 0, max = 60, step = 0.5)
#           )
# 
#         ),
# 
# 
#         h3("Communicative Temptation 1: Minute One"),
# 
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_1", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_2", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_3", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_4", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_5", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_6", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_7", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Response to Name & Gaze/Point 1: Minute Two"),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_9", p("Responds to name."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_10", p("Follows gaze/point."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_11", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_12", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_13", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_14", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_15", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_16", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_17", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#           h3("Communication Temptation 2: Minute Three"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_19", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_20", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_21", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_22", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_23", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_24", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_25", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         h3("Communicative Temptation 3, probe 2: Minute Four"),
# 
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_27", p("Responds to name."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_28", p("Follows gaze/point."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_29", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_30", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_31", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_32", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_33", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_34", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_35", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Sharing Books 1: Minute Five"),
# 
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_37", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_38", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_39", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_40", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_41", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_43", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Sharing Books 2: Minute Six"),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_45", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_46", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_47", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_48", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_49", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_50", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_51", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Parent/Caregiver-Child Play 1: Minute Seven"),
# 
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_53", p("Explores features of object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_54", p("Uses item functionally."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_56", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_57", p("3 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Parent/Caregiver-Child Play 2: Minute Eight"),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_66", p("Explores features of object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_67", p("Uses item functionally."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#          column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_69", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_70", p("3 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Parent/Caregiver-Child Play 3: Minute Nine"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_79", p("Explores features of object"),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_80", p("Uses item functionally"),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_82", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                    radioButtons("radio_sobY_v1_SO_9_23_83", p("2 Pretend action sequences."),
#                                 choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#             )
#             ),
# 
# 
# 
#         h3("Parent/Caregiver-Child Play 4: Minute Ten"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_92", p("Explores features of object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_93", p("Uses item functionally."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_95", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v1_SO_9_23_96", p("3 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         fluidRow(
#           column(1,
#                  actionButton(inputId = "sobY_v1_submit", label = "Submit",
#                               icon = NULL, width = NULL))
#         ),
# 
#         h2("Your Score"),
# fluidRow(
#   column(12,
#          verbatimTextOutput("sobY_v1_score"))
# ),
# 
# h3("Incorrect scores and their answers are displayed below."),
# 
# fluidRow(
#   column(12, tableOutput("sobY_v1_incorrect"))
# )
# 
# ### Video 2: SOM (younger) -----
# tabItem(tabName = "tab_somY_v2",
# 
#         h2("Certification Checklist for Social Observational (ages 9-23 months)"),
# 
#         h3("Certification Details for Video 2"),
# 
#         fluidRow(
#           column(6,
#                  textInput("text_sobY_person", h4("Person being certified:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  textInput("text_sobY_site", h4("Site:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  dateInput("text_sobY_date",
#                            label = "Date (yyyy-mm-dd)",
#                            value = Sys.Date()
#                  )
#           ),
# 
# 
#           column(6,
#                  numericInput("text_sobY_childAge", h4("Child Age (in months):"),
#                               value = "", min = 0, max = 60, step = 0.5)
#           )
# 
#         ),
# 
# 
#         h3("Communicative Temptation 1: Minute One"),
# 
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_1", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_2", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_3", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_4", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_5", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_6", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_7", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Response to Name & Gaze/Point 1: Minute Two"),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_9", p("Responds to name."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_10", p("Follows gaze/point."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_11", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_12", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_13", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_14", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_15", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_16", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_17", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Communication Temptation 2: Minute Three"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_19", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_20", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_21", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_22", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_23", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_24", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_25", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         h3("Communicative Temptation 3, probe 2: Minute Four"),
# 
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_27", p("Responds to name."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_28", p("Follows gaze/point."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_29", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_30", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_31", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_32", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_33", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_34", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_35", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Sharing Books 1: Minute Five"),
# 
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_37", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_38", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_39", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_40", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_41", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_43", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Sharing Books 2: Minute Six"),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_45", p("2-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_46", p("3-point gaze shift."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_47", p("Smiles without look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_48", p("Smiles with look."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_49", p("Show gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_50", p("Uses point gesture."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_51", p("Comments with sounds or words."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Parent/Caregiver-Child Play 1: Minute Seven"),
# 
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_53", p("Explores features of object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_54", p("Uses item functionally."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_56", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_57", p("3 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Parent/Caregiver-Child Play 2: Minute Eight"),
# 
#         fluidRow(
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_66", p("Explores features of object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_67", p("Uses item functionally."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_69", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_70", p("3 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Parent/Caregiver-Child Play 3: Minute Nine"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_79", p("Explores features of object"),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_80", p("Uses item functionally"),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_82", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_83", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Parent/Caregiver-Child Play 4: Minute Ten"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_92", p("Explores features of object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_93", p("Uses item functionally."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_95", p("2 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobY_v2_SO_9_23_96", p("3 Pretend action sequences."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         fluidRow(
#           column(1,
#                  actionButton(inputId = "sobY_v2_submit", label = "Submit",
#                               icon = NULL, width = NULL))
#         ),
# 
#h2("Your Score"),
# fluidRow(
#   column(12,
#          verbatimTextOutput("sobY_v1_score"))
# ),
# 
# h3("Incorrect scores and their answers are displayed below."),
# 
# fluidRow(
#   column(12, tableOutput("sobY_v1_incorrect"))
# )
# 
# ## Social Observational (older) page ------
# ### Video 1: SOM (older) -----
# tabItem(tabName = "tab_somO_v1",
# 
#         h2("Certification Checklist for Social Observational (ages 24 months and older)"),
# 
#         h3("Certification Details for Video 1"),
# 
#         fluidRow(
#           column(6,
#                  textInput("text_sobO_v1_person", h4("Person being certified:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  textInput("text_sobO_v1_site", h4("Site:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  dateInput("text_sobO_v1_date",
#                            label = "Date (yyyy-mm-dd)",
#                            value = Sys.Date()
#                  )
#           ),
# 
#           column(6,
#                  numericInput("text_sobO_v1_childAge", h4("Child Age (in months):"),
#                               value = "", min = 0, max = 60, step = 0.5)
#           )
# 
#         ),
# 
# 
#         h3("Joint Attention: Minute One"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_1", p("Following point."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_2", p("Complies with request (pot) spontaneously."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_3", p("Complies with request after prompt."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_4", p("Comments on jungle animal."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_5", p("Points to jungle animal."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_6", p("Shows jungle animal."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Pretend Play: Minutes Two-Three"),
# 
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_7", p("Child-as-agent."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_8", p("Substitution."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_9", p("Substitution without object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_10", p("Dolls-as-agent."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_11", p("Socio-dramatic play."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Prosocial Behavior: Minutes Four-Five"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_12", p("Shares blocks."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_13", p("Takes turns building tower."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_15", p("Concerned facial expression."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_16", p("Verbal concern/comforting."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_17", p("Physical comforting."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_18", p("Helps clean up spontaneously."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_19", p("Helps clean up after prompt."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
# 
#         h3("Social Communication 1: Minutes Six-Seven"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_21", p("Rebuilds elephant all steps."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_22", p("Steps in correct order."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_23", p("Asks for help opening container."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Social Communications 2: Minutes Eight-Ten"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_24", p("Initiates/responds to conversation."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_25", p("Takes a conversational turn."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_26", p("Responds to a shift in topic."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_27", p("Corrects mislabeling by protest only."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_29", p("Adapts speech register for doll."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_30", p("Turns book to face doll."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v1_SO_24_48_31", p("Attempts to teach doll."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#           ),
# 
# 
#         fluidRow(
#           column(1,
#                  actionButton(inputId = "sobO_v1_submit", label = "Submit",
#                               icon = NULL, width = NULL))
#         ),
# 
#h2("Your Score"),
# fluidRow(
#   column(12,
#          verbatimTextOutput("sobO_v1_score"))
# ),
# 
# h3("Incorrect scores and their answers are displayed below."),
# 
# fluidRow(
#   column(12, tableOutput("sobO_v1_incorrect"))
# )
# 
# 
# 
# ### Video 2: SOM (older) -----
# tabItem(tabName = "tab_somO_v2",
# 
#         h2("Certification Checklist for Social Observational (ages 24 months and older)"),
# 
#         h3("Certification Details for Video 2"),
# 
#         fluidRow(
#           column(6,
#                  textInput("text_sobO_v2_person", h4("Person being certified:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  textInput("text_sobO_v2_site", h4("Site:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  dateInput("text_sobO_v2_date",
#                            label = "Date (yyyy-mm-dd)",
#                            value = Sys.Date()
#                  )
#           ),
# 
#           column(6,
#                  numericInput("text_sobO_v2_childAge", h4("Child Age (in months):"),
#                               value = "", min = 0, max = 60, step = 0.5)
#           )
# 
#         ),
# 
# 
#         h3("Joint Attention: Minute One"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_1", p("Following point."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_2", p("Complies with request (pot) spontaneously."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_3", p("Complies with request after prompt."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_4", p("Comments on jungle animal."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_5", p("Points to jungle animal."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_6", p("Shows jungle animal."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         h3("Pretend Play: Minutes Two-Three"),
# 
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_7", p("Child-as-agent."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_8", p("Substitution."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_9", p("Substitution without object."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_10", p("Dolls-as-agent."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_11", p("Socio-dramatic play."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Prosocial Behavior: Minutes Four-Five"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_12", p("Shares blocks."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_13", p("Takes turns building tower."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_15", p("Concerned facial expression."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_16", p("Verbal concern/comforting."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_17", p("Physical comforting."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_18", p("Helps clean up spontaneously."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_19", p("Helps clean up after prompt."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
# 
#         h3("Social Communication 1: Minutes Six-Seven"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_21", p("Rebuilds elephant all steps."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_22", p("Steps in correct order."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_23", p("Asks for help opening container."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
# 
#         h3("Social Communications 2: Minutes Eight-Ten"),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_24", p("Initiates/responds to conversation."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_25", p("Takes a conversational turn."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_26", p("Responds to a shift in topic."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_27", p("Corrects mislabeling by protest only."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_29", p("Adapts speech register for doll."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_30", p("Turns book to face doll."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           ),
# 
#           column(4,
#                  radioButtons("radio_sobO_v2_SO_24_48_31", p("Attempts to teach doll."),
#                               choiceNames = c("Yes", "No"), choiceValues = app_values_1or0, selected = "")
#           )
#         ),
# 
# 
#         fluidRow(
#           column(1,
#                  actionButton(inputId = "sobO_v2_submit", label = "Submit",
#                               icon = NULL, width = NULL))
#         ),
# 
#h2("Your Score"),
# fluidRow(
#   column(12,
#          verbatimTextOutput("sobO_v2_score"))
# ),
# 
# h3("Incorrect scores and their answers are displayed below."),
# 
# fluidRow(
#   column(12, tableOutput("sobO_v2_incorrect"))
# )
# ),
# 
# 
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
                              choiceValues = app_values_0_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_prone", p("What child did on belly?"),
                              choiceNames = c("NA", "Nothing, did not lift head",
                                              "Lifted head only", "Propped on forearms",
                                              "Rolled onto back", "Propped on hands",
                                              "Took steps or got off belly"),
                              choiceValues = app_values_1_6, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_roll", p("How child got off back? "),
                              choiceNames = c("NA", "Rolled to belly, hands trapped",
                                              "Rolled to belly, hands out", "Rolled to hands-knees",
                                              "Side lying", "Got up without rolling"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_uppos", p("Most upright postures?"),
                              choiceNames = c("NA", "Belly", "Hands-knees or hands-feet",
                                              "Sit or kneel, back vertical", "Stand"),
                              choiceValues = app_values_1_4, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_sit", p("How child got to sit or kneel?"),
                              choiceNames = c("NA", "Pushed up from crawl",
                                              "Pushed up from side lying", "Sat up directly from supine"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),


        h3("Locomotion (LO) version"),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_stand", p("How child got to standing?"),
                              choiceNames = c("NA", "Down-dog to stand",
                                              "Half-kneel to stand", "Squat to stand"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_hands", p("How many hands child used?"),
                              choiceNames = c("NA", "0",
                                              "1", "2"),
                              choiceValues = app_values_0_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_turn", p("Child turned to face finish line? "),
                              choiceNames = c("NA", "Never faced finish",
                                              "Turned to face finish", "Already facing finish"),
                              choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_trameth", p("How child traveled?"),
                              choiceNames = c("NA", "Did not travel", "log roll",
                                              "belly crawl", "bum shuffle or hitch",
                                              "Hands-knees or hands-feet", "knee-walk or half-kneel",
                                              "walk"),
                              choiceValues = app_values_1_7, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_gug_v1_toes", p("Child walked on toes?"),
                              choiceNames = c("NA", "Can't see heels", "No",
                                              "Right foot", "Left foot",
                                              "Both"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_gug_v1_tradis", p("How far child traveled?"),
                              choiceNames = c("NA", "Took a few steps and fell",
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
                              choiceNames = c("NA", "Didn't try", "Did not pull up",
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
                              choiceNames = c("NA", "Didn't try to come down",
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


# ### Video 2: GUG -----
# tabItem(tabName = "tab_gug_v2",
# 
#         h2("Certification Checklist for Get Up and Go"),
#         h3("Certification Details for Video 2"),
# 
#         fluidRow(
#           column(6,
#                  textInput("text_gug_v2_person", h4("Person being certified:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  textInput("text_gug_v2_site", h4("Site:"),
#                            value = "")
#           ),
# 
#           column(6,
#                  dateInput("text_gug_v2_date",
#                            label = "Date (yyyy-mm-dd)",
#                            value = Sys.Date()
#                  )
#           ),
# 
#           column(6,
#                  numericInput("text_gug_childAge", h4("Child Age (in months):"),
#                               value = "", min = 0, max = 60, step = 0.5)
#           )
# 
#         ),
# 
# 
# 
#         h3("Pre-Locomotion (PL) Testing"),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_back", p("Did child get off back?"),
#                               choiceNames = c("NA", "No (didn’t try)", "No (tried but couldn’t)", "Yes"),
#                               choiceValues = app_values_1_3, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_prone", p("What child did on belly?"),
#                               choiceNames = c("NA", "Nothing, did not lift head",
#                                               "Lifted head only", "Propped on forearms",
#                                               "Rolled onto back", "Propped on hands",
#                                               "Took steps or got off belly"),
#                               choiceValues = app_values_0_5, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_roll", p("How child got off back? "),
#                               choiceNames = c("NA", "Rolled to belly, hands trapped",
#                                               "Rolled to belly, hands out", "Rolled to hands-knees",
#                                               "Side lying", "Got up without rolling"),
#                               choiceValues = app_values_1_5, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_uppos", p("Most upright postures?"),
#                               choiceNames = c("NA", "Belly", "Hands-knees or hands-feet",
#                                               "Sit or kneel, back vertical", "Stand"),
#                               choiceValues = app_values_1_4, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_sit", p("How child got to sit or kneel?"),
#                               choiceNames = c("NA", "Pushed up from crawl",
#                                               "Pushed up from side lying", "Sat up directly from supine"),
#                               choiceValues = app_values_1_3, selected = "")
#           )
#         ),
# 
# 
#         h3("Locomotion (LO) version"),
# 
#         fluidRow(
# 
#           column(6,
#                  radioButtons("radio_gug_v2_stand", p("How child got to standing?"),
#                               choiceNames = c("NA", "Down-dog to stand",
#                                               "Half-kneel to stand", "Squat to stand"),
#                               choiceValues = app_values_1_3, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(6,
#                  radioButtons("radio_gug_v2_hands", p("How many hands child used?"),
#                               choiceNames = c("NA", "0",
#                                               "1", "2"),
#                               choiceValues = app_values_0_2, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(6,
#                  radioButtons("radio_gug_v2_turn", p("Child turned to face finish line? "),
#                               choiceNames = c("NA", "Never faced finish",
#                                               "Turned to face finish", "Already facing finish"),
#                               choiceValues = app_values_1_3, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(6,
#                  radioButtons("radio_gug_v2_trameth", p("How child traveled?"),
#                               choiceNames = c("NA", "Did not travel", "log roll",
#                                               "belly crawl", "bum shuffle or hitch",
#                                               "Hands-knees or hands-feet", "knee-walk or half-kneel",
#                                               "walk"),
#                               choiceValues = app_values_1_7, selected = "")
#           )
#         ),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_toes", p("Child walked on toes?"),
#                               choiceNames = c("NA", "Can't see heels", "No",
#                                               "Right foot", "Left foot",
#                                               "Both"),
#                               choiceValues = app_values_1_5, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(6,
#                  radioButtons("radio_gug_v2_tradis", p("How far child traveled?"),
#                               choiceNames = c("NA", "Took a few steps and fell",
#                                               "Took a few steps and stopped", "3 meters, not continuous",
#                                               "3 meters, but dawdled", "3 meters, no dawdling"),
#                               choiceValues = app_values_1_5, selected = "")
#           )
#         ),
# 
#         fluidRow(
# 
#           column(6,
#                  numericInput("radio_gug_v2_starttime", p("When did the child cross start line?", br(),
#                                                        "(Start Time in Minutes (M) and Seconds (S): MM.SS)"),
#                               value = "", min = 0, max = 1800, step = 0.01)
#           )
#         ),
# 
#         fluidRow(
# 
#           column(6,
#                  numericInput("radio_gug_v2_endtime", p("When did the child cross finish line?", br(),
#                                                      "(End Time in Minutes (M) and Seconds (S): MM.SS)"),
#                               value = "", min = 0, max = 1800, step = 0.01)
#           )
#         ),
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_stairup", p("How did child get up stair?"),
#                               choiceNames = c("NA", "Didn't try", "Did not pull up",
#                                               "Pulled up to knees", "Pulled up to stand",
#                                               "Climbed up, stayed prone", "Climbed up, stood up",
#                                               "Tried to step & fell", "Stepped up, not integrated",
#                                               "Stepped up, gait integrated"),
#                               choiceValues = app_values_1_9, selected = "")
#           )
#         ),
# 
# 
#         fluidRow(
#           column(6,
#                  radioButtons("radio_gug_v2_stairdo", p("How did child get down stair?"),
#                               choiceNames = c("NA", "Didn't try to come down",
#                                               "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
#                                               "Walked down, fell", "Walked down, not integrated",
#                                               "Walked down, integrated", "Jumped or leaped & fell",
#                                               "Jumped or leaped no fall"),
#                               choiceValues = app_values_0_8, selected = "")
#           )
#         ),
# 
# 
# 
#         fluidRow(
#           column(1,
#                  actionButton(inputId = "gug_v2_submit", label = "Submit",
#                               icon = NULL, width = NULL))
#         ),
# 
# h2("Your Score"),
# fluidRow(
#   column(12,
#          verbatimTextOutput("gug_v2_score"))
# ),
# 
# h3("Incorrect scores and their answers are displayed below."),
# 
# fluidRow(
#   column(12, tableOutput("gug_v2_incorrect"))
# )
# ),

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
        #          radioButtons("radio_rte_v1_lbtr_success", p("Did child reach block with right hand?"),
        #                       choiceNames = c("NA", "Noncompliant", "Didn't try",
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
        #                       choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),
        #
        #
        # fluidRow(
        #
        #   column(6,
        #          radioButtons("radio_rte_v1_lbtl_success", p("Did child reach block with left hand?"),
        #                       choiceNames = c("NA", "Noncompliant", "Didn't try",
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
        #                       choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),


        h3("Cheerio Small Base Task"),
        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c("NA", "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctl_success", p("Did child reach small base with left hand?"),
                              choiceNames = c("NA", "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),



        # h3("Cheerio Large Base Task"),
        # h4("Right Hand"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctr_success", p("Did child reach large base with right hand?"),
        #                       choiceNames = c("NA", "Noncompliant", "Didn't try",
        #                                       "Moved arm only", "Touched but no grasp",
        #                                       "Grasped from the table", "Grasped from the base"),
        #                       choiceValues = app_values_0_5, selected = "")
        #   )
        # ),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctr_grasp", p("Child used which grasp with right hand?"),
        #                       choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
        #                                       "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
        #   )
        # ),
        #
        # h4("Left Hand"),
        #
        # fluidRow(
        #   column(6,
        #          radioButtons("radio_rte_v1_lctl_success", p("Did child reach large base with left hand?"),
        #                       choiceNames = c("NA", "Noncompliant", "Didn't try",
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
        #                       choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
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
                              choiceNames = c("NA", "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnter_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c("NA", "Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnter_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("NA", "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(
           column(6,
                 radioButtons("radio_rte_v1_spnter_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c("NA", "Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnter_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c("NA", "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = c(NA, 0, -2, 1:3), selected = "")
          )
        ),


        fluidRow(
          h4("Cheerio Spoon Hard (Right Hand)")
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c("NA", "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c("NA", "Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("NA", "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c("NA", "Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthr_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c("NA", "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = c(NA, 0, -2, 1:3), selected = "")
          )
        ),



          h4("Cheerio Spoon Easy (Left Hand)"),




        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c("NA", "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c("NA", "Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("NA", "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c("NA", "Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spntel_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c("NA", "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = c(NA, 0, -2, 1:3), selected = "")
          )
        ),



          h4("Cheerio Spoon Hard (Left Hand)"),



        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c("NA", "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio",
                                              "Grasped spoon for transport"),
                              choiceValues = app_values_1_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c("NA", "Grasped handle", "Moved handle"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("NA", "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v1_spnthl_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c("NA", "Away from bowl", "Toward bowl"),
                              choiceValues = app_values_1_2, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v1_spnthl_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c("NA", "Didn't try", "Child used restrained hand",
                                              "Cheerio fell", "After replacement",
                                              "On first attempt"),
                              choiceValues = c(NA, 0, -2, 1:3), selected = "")
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
        

        h3("Cheerio Small Base Task"),

        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c("NA", "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctl_success", p("Did child reach small base with left hand?"),
                              choiceNames = c("NA", "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),



        h3("Cheerio Large Base Task"),

        h4("Right Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctr_success", p("Did child reach large base with right hand?"),
                              choiceNames = c("NA", "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
                                              "Thumb & finger grip" ), choiceValues = app_values_1_3, selected = "")
          )
        ),

        h4("Left Hand"),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_v2_lctl_success", p("Did child reach large base with left hand?"),
                              choiceNames = c("NA", "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp",
                                              "Grasped from the table", "Grasped from the base"),
                              choiceValues = app_values_0_5, selected = "")
          )
        ),

        fluidRow(

          column(6,
                 radioButtons("radio_rte_v2_lctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c("NA", "Palmer grip", "Multi-finger grip",
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

        h3("Unsupported Sit"),


        fluidRow(
         column(6,
                 radioButtons("radio_sas_v1_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c("NA", "Non-compliant", "Fell", "Used hands for support",
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

        
        h3("Unsupported Stand: Feet Together"),

        fluidRow(

          column(6,
                 radioButtons("radio_sas_v2_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
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
                              choiceNames = c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
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
                              choiceNames = c("NA", "No", "Yes"), choiceValues = app_values_1_2, selected = "")
          )
        ),


        h3("Unsupported Sit"),


        fluidRow(
          column(6,
                 radioButtons("radio_sas_v3_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c("NA", "Non-compliant", "Fell", "Used hands for support",
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
        #                       choiceNames = c("NA", "No", "Yes"), choiceValues = app_values_1_2, selected = "")
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
        #                       choiceNames = c("NA", "No", "Yes"), choiceValues = app_values_1_2, selected = "")
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
        #                       choiceNames = c("NA", "Non-complaint", "Fell", "Used hands for support",
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
                              choiceNames = c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
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
                              choiceNames = c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
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

### Video 2 ------

## Social Observational (older) data ------
  ### Video 1 ------
  ### Video 2 ------

## Get Up and Go data ------
  ### Video 1 ------
  gug_v1_values <- eventReactive(input$gug_v1_submit, {
    
    gug_v1_data <- data.frame(
      task_id = c("gug_v1"),
      text_gug_v1_person = c(input$text_gug_v1_person),
      text_gug_v1_site = c(input$text_gug_v1_site),
      text_gug_v1_date = format(as.Date(input$text_gug_v1_date, origin="2023-01-01")),
      text_gug_v1_childAge = c(input$text_gug_v1_childAge),
      
      gug_v1_back = c(input$radio_gug_v1_back),
      gug_v1_prone = c(input$radio_gug_v1_prone),
      gug_v1_roll = c(input$radio_gug_v1_roll),
      gug_v1_uppos = c(input$radio_gug_v1_uppos),
      
      gug_v1_sit = c(input$radio_gug_v1_sit),
      gug_v1_stand = c(input$radio_gug_v1_stand),
      gug_v1_hands = c(input$radio_gug_v1_hands),
      gug_v1_turn = c(input$radio_gug_v1_turn),
      
      gug_v1_trameth = c(input$radio_gug_v1_trameth),
      gug_v1_toes = c(input$radio_gug_v1_toes),
      gug_v1_tradis = c(input$radio_gug_v1_tradis),
      
      gug_v1_start = c(input$radio_gug_v1_start),
      gug_v1_end = c(input$radio_gug_v1_end),
      
      gug_v1_stairup = c(input$radio_gug_v1_stairup),
      gug_v1_stairdo = c(input$radio_gug_v1_stairdo)
      
    ) %>%
      mutate(
        gug_v1_back = as.numeric(gug_v1_back),
        gug_v1_prone = as.numeric(gug_v1_prone),
        gug_v1_roll = as.numeric(gug_v1_roll),
        gug_v1_uppos = as.numeric(gug_v1_uppos),
        gug_v1_sit = as.numeric(gug_v1_sit),
        gug_v1_stand = as.numeric(gug_v1_stand),
        gug_v1_hands = as.numeric(gug_v1_hands),
        gug_v1_turn = as.numeric(gug_v1_turn),
        gug_v1_trameth = as.numeric(gug_v1_trameth),
        gug_v1_toes = as.numeric(gug_v1_toes),
        gug_v1_tradis = as.numeric(gug_v1_tradis),
        gug_v1_start = as.numeric(gug_v1_start),
        gug_v1_end = as.numeric(gug_v1_end),
        gug_v1_stairup = as.numeric(gug_v1_stairup),
        gug_v1_stairdo = as.numeric(gug_v1_stairdo)
      )
    
    gug_key_df <- data.frame(
      K_Back = c(2),
      K_Prone = c(-999),
      K_Roll = c(2),
      K_UpPos = c(2),
      K_Sit = c(-999),
      K_Stand = c(-999),
      K_Hands = c(-999),
      K_Turn = c(2),
      K_TraMeth = c(5),
      K_Toes = c(-999),
      K_TraDis = c(5),
      K_Start = c(.27),
      K_End = c(.38),
      K_StairUp = c(4),
      K_StairDo = c(2)
    )
    
    gug_v1_combined <- cbind(gug_v1_data, gug_key_df) %>% 
      mutate(Score_gug_v1_back = ifelse(gug_v1_back == K_Back, 1, 0),
             Score_gug_v1_prone = ifelse(gug_v1_prone == K_Prone, 1, 0),
             Score_gug_v1_roll = ifelse(gug_v1_roll == K_Roll, 1, 0),
             Score_gug_v1_uppos = ifelse(gug_v1_uppos == K_UpPos, 1, 0),
             Score_gug_v1_sit = ifelse(gug_v1_sit == K_Sit, 1, 0),
             Score_gug_v1_stand = ifelse(gug_v1_stand == K_Stand, 1, 0),
             Score_gug_v1_hands = ifelse(gug_v1_hands == K_Hands, 1, 0),
             Score_gug_v1_turn = ifelse(gug_v1_turn == K_Turn, 1, 0),
             Score_gug_v1_trameth = ifelse(gug_v1_trameth == K_TraMeth, 1, 0),
             Score_gug_v1_toes = ifelse(gug_v1_toes == K_Toes, 1, 0),
             Score_gug_v1_tradis = ifelse(gug_v1_tradis == K_TraDis, 1, 0),
             Score_gug_v1_start = ifelse(between(gug_v1_start, K_Start - 0.01, K_Start + 0.01), 1, 
                    ifelse(gug_v1_start == K_Start - 0.02, 0.5,
                           ifelse(gug_v1_start == K_Start + 0.02, 0.5, 0))),
             Score_gug_v1_end = ifelse(between(gug_v1_end, K_End - 0.01, K_Start + 0.01), 1, 
                    ifelse(gug_v1_end == K_End - 0.02, 0.5,
                           ifelse(gug_v1_end == K_End + 0.02, 0.5, 0))),
             Score_gug_v1_stairup = ifelse(gug_v1_stairup == K_StairUp, 1, 0),
             Score_gug_v1_stairdo = ifelse(gug_v1_stairdo == K_StairDo, 1, 0),
             
             Score_gug_v1 = sum(Score_gug_v1_back, Score_gug_v1_prone, 
                                Score_gug_v1_roll, Score_gug_v1_uppos,
                                Score_gug_v1_sit, Score_gug_v1_stand, 
                                Score_gug_v1_hands, Score_gug_v1_turn, 
                                Score_gug_v1_trameth, Score_gug_v1_toes, 
                                Score_gug_v1_tradis, Score_gug_v1_start, 
                                Score_gug_v1_end, Score_gug_v1_stairup, 
                                Score_gug_v1_stairdo),
             Score_gug_v1 = round(Score_gug_v1 / 15 , 3)
      ) 
    
    gug_v1_upload <- gug_v1_combined %>%
      pivot_longer(.,
                   cols = c(starts_with("gug_v"), starts_with("K_"), starts_with("Score")),
                   names_to = "item_id",
                   values_to = "value"
      ) %>%
      mutate(key = c(rep("Response", 15), rep("Answer", 15), rep("Score", 15), "Overall")
      ) %>%
      rename(name = text_gug_v1_person,
             site = text_gug_v1_site,
             date = text_gug_v1_date,
             c_age = text_gug_v1_childAge)

    gug_v1_upload <- as.data.frame(gug_v1_upload)

    sheet_append(ss = sheet_id,
                 data = gug_v1_upload,
                 sheet = "main")
    
    return(gug_v1_combined)
    
  })
  
  output$gug_v1_incorrect <- renderTable({
    gug_v1_data <- gug_v1_values()
    
    return_gug_v1 <- gug_v1_data %>% 
      mutate(gug_v1_back = factor(gug_v1_back, app_values_0_2, c("NA", "No (didn’t try)", "No (tried but couldn’t)", "Yes")),
             K_Back = factor(K_Back, app_values_0_2, c("NA", "No (didn’t try)", "No (tried but couldn’t)", "Yes")),

             gug_v1_prone = factor(gug_v1_prone, app_values_1_6, c("NA", "Nothing, did not lift head",
                                                           "Lifted head only", "Propped on forearms",
                                                           "Rolled onto back", "Propped on hands",
                                                           "Took steps or got off belly")),
             K_Prone = factor(K_Prone, app_values_1_6, c("NA", "Nothing, did not lift head",
                                                 "Lifted head only", "Propped on forearms",
                                                 "Rolled onto back", "Propped on hands",
                                                 "Took steps or got off belly")),

             gug_v1_roll = factor(gug_v1_roll, app_values_1_5, c("NA", "Rolled to belly, hands trapped",
                                                         "Rolled to belly, hands out", "Rolled to hands-knees",
                                                         "Side lying", "Got up without rolling")),
             K_Roll = factor(K_Roll, app_values_1_5, c("NA", "Rolled to belly, hands trapped",
                                               "Rolled to belly, hands out", "Rolled to hands-knees",
                                               "Side lying", "Got up without rolling")),

             gug_v1_uppos = factor(gug_v1_uppos, app_values_1_4, c("NA", "Belly", "Hands-knees or hands-feet",
                                                           "Sit or kneel, back vertical", "Stand")),
             K_UpPos = factor(K_UpPos, app_values_1_4, c("NA", "Belly", "Hands-knees or hands-feet",
                                                 "Sit or kneel, back vertical", "Stand")),

             gug_v1_sit = factor(gug_v1_sit, app_values_1_3, c("NA", "Pushed up from crawl",
                                                       "Pushed up from side lying", "Sat up directly from supine")),
             K_Sit = factor(K_Sit, app_values_1_3, c("NA", "Pushed up from crawl",
                                             "Pushed up from side lying", "Sat up directly from supine")),

             gug_v1_stand = factor(gug_v1_stand, app_values_1_3, c("NA", "Down-dog to stand",
                                                           "Half-kneel to stand", "Squat to stand")),
             K_Stand = factor(K_Stand, app_values_1_3, c("NA", "Down-dog to stand",
                                                 "Half-kneel to stand", "Squat to stand")),

             gug_v1_hands = factor(gug_v1_hands, app_values_0_2, c("NA", "0", "1", "2")),
             K_Hands = factor(K_Hands, app_values_0_2, c("NA", "0", "1", "2")),

             gug_v1_turn = factor(gug_v1_turn, app_values_1_3, c("NA", "Never faced finish", "Turned to face finish", "Already facing finish")),
             K_Turn = factor(K_Turn, app_values_1_3, c("NA", "Never faced finish", "Turned to face finish", "Already facing finish")),

             gug_v1_trameth = factor(gug_v1_trameth, app_values_1_7, c("NA", "Did not travel", "log roll",
                                                               "belly crawl", "bum shuffle or hitch",
                                                               "Hands-knees or hands-feet", "knee-walk or half-kneel",
                                                               "walk")),
             K_TraMeth = factor(K_TraMeth, app_values_1_7, c("NA", "Did not travel", "log roll",
                                                     "belly crawl", "bum shuffle or hitch",
                                                     "Hands-knees or hands-feet", "knee-walk or half-kneel",
                                                     "walk")),

             gug_v1_toes = factor(gug_v1_toes, app_values_1_5, c("NA", "Can't see heels", "No",
                                                         "Right foot", "Left foot",
                                                         "Both")),
             K_Toes = factor(K_Toes, app_values_1_5, c("NA", "Can't see heels", "No",
                                               "Right foot", "Left foot",
                                               "Both")),

             gug_v1_tradis = factor(gug_v1_tradis, app_values_1_5, c("NA", "Took a few steps and fell",
                                                             "Took a few steps and stopped", "3 meters, not continuous",
                                                             "3 meters, but dawdled", "3 meters, no dawdling")),
             K_TraDis = factor(K_TraDis, app_values_1_5, c("NA", "Took a few steps and fell",
                                                   "Took a few steps and stopped", "3 meters, not continuous",
                                                   "3 meters, but dawdled", "3 meters, no dawdling")),



             gug_v1_stairup = factor(gug_v1_stairup, app_values_0_8, c("NA", "Didn't try", "Did not pull up",
                                                               "Pulled up to knees", "Pulled up to stand",
                                                               "Climbed up, stayed prone", "Climbed up, stood up",
                                                               "Tried to step & fell", "Stepped up, not integrated",
                                                               "Stepped up, gait integrated")),
             K_StairUp = factor(K_StairUp, app_values_0_8, c("NA", "Didn't try", "Did not pull up",
                                                     "Pulled up to knees", "Pulled up to stand",
                                                     "Climbed up, stayed prone", "Climbed up, stood up",
                                                     "Tried to step & fell", "Stepped up, not integrated",
                                                     "Stepped up, gait integrated")),


             gug_v1_stairdo = factor(gug_v1_stairdo, app_values_0_8, c("NA", "Didn't try to come down",
                                                               "Climbed down, fell", "Climbed down, stayed down", "Climbed down, stood up",
                                                               "Walked down, fell", "Walked down, not integrated",
                                                               "Walked down, integrated", "Jumped or leaped & fell",
                                                               "Jumped or leaped no fall")),
             K_StairDo = factor(K_StairDo, app_values_0_8, c("NA", "Didn't try to come down",
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
                         "Q7", "Q8", "Q9", "Q10", "Q11", "Q12",
                         "Q13", "Q14", "Q15"), 3)),
             type = c(rep("Response", 15), rep("Answer", 15), rep("Score", 15))
      ) %>%
      select(-c(task_id:text_gug_v1_childAge, Question)) %>%
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

## Reach to Eat data ------
  ### Video 1 ------
  rte_v1_values <- eventReactive(input$rte_v1_submit, {
    
    rte_v1_data <- data.frame(
      task_id = c("rte_v1"),
      text_rte_v1_person = c(input$text_rte_v1_person),
      text_rte_v1_site = c(input$text_rte_v1_site),
      text_rte_v1_date = format(as.Date(input$text_rte_v1_date, origin="2023-01-01")),
      text_rte_v1_childAge = c(input$text_rte_v1_childAge),
      
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
             date = text_rte_v1_date,
             c_age = text_rte_v1_childAge) 
    
    rte_v1_upload <- as.data.frame(rte_v1_upload)
    
    sheet_append(ss = sheet_id,
                 data = rte_v1_upload,
                 sheet = "main")
    
    return(rte_v1_combined)
    
  })
  
  output$rte_v1_incorrect <- renderTable({
    rte_v1_data <- rte_v1_values()
    
    return_rte_v1 <- rte_v1_data %>% 
      mutate(rte_v1_sctr_success = factor(rte_v1_sctr_success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTR_Success = factor(K_SCTR_Success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v1_sctr_grasp = factor(rte_v1_sctr_grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTR_Grasp = factor(K_SCTR_Grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v1_sctl_success = factor(rte_v1_sctl_success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTL_Success = factor(K_SCTL_Success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v1_sctl_grasp = factor(rte_v1_sctl_grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTL_Grasp = factor(K_SCTL_Grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v1_spnter_purpose = factor(rte_v1_spnter_purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnTer_Purpose = factor(K_SpnTer_Purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spnter_move = factor(rte_v1_spnter_move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             K_SpnTer_Move = factor(K_SpnTer_Move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             rte_v1_spnter_grasp = factor(rte_v1_spnter_grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnTer_Grasp = factor(K_SpnTer_Grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spnter_thumb = factor(rte_v1_spnter_thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             K_SpnTer_Thumb = factor(K_SpnTer_Thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             rte_v1_spnter_success = factor(rte_v1_spnter_success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnTer_Success = factor(K_SpnTer_Success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt")),
             
             rte_v1_spnthr_purpose = factor(rte_v1_spnthr_purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnThr_Purpose = factor(K_SpnThr_Purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spnthr_move = factor(rte_v1_spnthr_move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             K_SpnThr_Move = factor(K_SpnThr_Move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             rte_v1_spnthr_grasp = factor(rte_v1_spnthr_grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnThr_Grasp = factor(K_SpnThr_Grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spnthr_thumb = factor(rte_v1_spnthr_thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             K_SpnThr_Thumb = factor(K_SpnThr_Thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             rte_v1_spnthr_success = factor(rte_v1_spnthr_success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnThr_Success = factor(K_SpnThr_Success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt")),
             
             
             rte_v1_spntel_purpose = factor(rte_v1_spntel_purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnTel_Purpose = factor(K_SpnTel_Purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spntel_move = factor(rte_v1_spntel_move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             K_SpnTel_Move = factor(K_SpnTel_Move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             rte_v1_spntel_grasp = factor(rte_v1_spntel_grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnTel_Grasp = factor(K_SpnTel_Grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spntel_thumb = factor(rte_v1_spntel_thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             K_SpnTel_Thumb = factor(K_SpnTel_Thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             rte_v1_spntel_success = factor(rte_v1_spntel_success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnTel_Success = factor(K_SpnTel_Success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                          "Cheerio fell", "After replacement",
                                                                          "On first attempt")),
             
             rte_v1_spnthl_purpose = factor(rte_v1_spnthl_purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             K_SpnThl_Purpose = factor(K_SpnThl_Purpose, app_values_0_4, c("NA", "Noncompliant", "Refused to pick up spoon", "Picked up to play", "Grasped Cheerio", "Grasped spoon for transport")),
             rte_v1_spnthl_move = factor(rte_v1_spnthl_move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             K_SpnThl_Move = factor(K_SpnThl_Move, app_values_1_2, c("NA", "Grasped handle", "Moved handle")),
             rte_v1_spnthl_grasp = factor(rte_v1_spnthl_grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             K_SpnThl_Grasp = factor(K_SpnThl_Grasp, app_values_1_3, c("NA", "Palmer grip", "Thumb & finger grip", "Adult-like grip")),
             rte_v1_spnthl_thumb = factor(rte_v1_spnthl_thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             K_SpnThl_Thumb = factor(K_SpnThl_Thumb, app_values_1_2, c("NA", "Away from bowl", "Toward bowl")),
             rte_v1_spnthl_success = factor(rte_v1_spnthl_success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
                                                                                    "Cheerio fell", "After replacement",
                                                                                    "On first attempt")),
             K_SpnThl_Success = factor(K_SpnThl_Success, app_values_0_3_neg2, c("NA", "Didn't try", "Child used restrained hand",
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
      select(-c(task_id:text_rte_v1_childAge, Question)) %>% 
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
      text_rte_v2_date = format(as.Date(input$text_rte_v2_date, origin="2023-01-01")),
      text_rte_v2_childAge = c(input$text_rte_v2_childAge),
      
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
             date = text_rte_v2_date,
             c_age = text_rte_v2_childAge) 
    
    rte_v2_upload <- as.data.frame(rte_v2_upload)
    
    sheet_append(ss = sheet_id,
                 data = rte_v2_upload,
                 sheet = "main")
    
    return(rte_v2_combined)
    
  })
  
  output$rte_v2_incorrect <- renderTable({
    rte_v2_data <- rte_v2_values()
    
    return_rte_v2 <- rte_v2_data %>% 
      mutate(rte_v2_sctr_success = factor(rte_v2_sctr_success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTR_Success = factor(K_SCTR_Success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_sctr_grasp = factor(rte_v2_sctr_grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTR_Grasp = factor(K_SCTR_Grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v2_sctl_success = factor(rte_v2_sctl_success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_SCTL_Success = factor(K_SCTL_Success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_sctl_grasp = factor(rte_v2_sctl_grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_SCTL_Grasp = factor(K_SCTL_Grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v2_lctr_success = factor(rte_v2_lctr_success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_LCTR_Success = factor(K_LCTR_Success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_lctr_grasp = factor(rte_v2_lctr_grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_LCTR_Grasp = factor(K_LCTR_Grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             
             rte_v2_lctl_success = factor(rte_v2_lctl_success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             K_LCTL_Success = factor(K_LCTL_Success, app_values_0_5, c("NA", "Noncompliant", "Didn't try", "Moved arm only", "Touched but no grasp", "Grasped from the table", "Grasped from the base")),
             rte_v2_lctl_grasp = factor(rte_v2_lctl_grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip")),
             K_LCTL_Grasp = factor(K_LCTL_Grasp, app_values_1_3, c("NA", "Palmer grip", "Multi-finger grip", "Thumb & finger grip"))
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
      select(-c(task_id:text_rte_v2_childAge, Question)) %>% 
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
      text_sas_v1_date = format(as.Date(input$text_sas_v1_date, origin="2023-01-01")),
      text_sas_v1_childAge = c(input$text_sas_v1_childAge),

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
             date = text_sas_v1_date,
             c_age = text_sas_v1_childAge) 
    
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
                                     c("NA", "Non-compliant", "Fell", "Used hands for support",
                                       "Sat without support", "Shifted to prone")),
             K_Usit_Q1 = factor(K_Usit_Q1, app_values_1_5,
                                c("NA", "Non-compliant", "Fell", "Used hands for support",
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
      select(-c(task_id:text_sas_v1_childAge, Question)) %>% 
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
      text_sas_v2_date = format(as.Date(input$text_sas_v2_date, origin="2023-01-01")),
      text_sas_v2_childAge = c(input$text_sas_v2_childAge),
      
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
             date = text_sas_v2_date,
             c_age = text_sas_v2_childAge) 
    
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
                                    c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet together")),
             K_StD_Q1 = factor(K_StD_Q1, app_values_1_5,
                               c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet together")),
             sas_v2_std_q3 = factor(sas_v2_std_q3, app_values_1_5,
                                    c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet tandem")),
             K_StD_Q3 = factor(K_StD_Q3, app_values_1_5,
                               c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
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
      select(-c(task_id:text_sas_v2_childAge, Question)) %>% 
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
      text_sas_v3_date = format(as.Date(input$text_sas_v3_date, origin="2023-01-01")),
      text_sas_v3_childAge = c(input$text_sas_v3_childAge),
      
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
             date = text_sas_v3_date,
             c_age = text_sas_v3_childAge) 
    
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
                                    c("NA", "No", "Yes")),
             sas_v3_usit_q1 = factor(sas_v3_usit_q1, app_values_1_5,
                                     c("NA", "Non-compliant", "Fell", "Used hands for support",
                                       "Sat without support", "Shifted to prone")),
             K_Usit_Q1 = factor(K_Usit_Q1, app_values_1_5,
                                c("NA", "Non-compliant", "Fell", "Used hands for support",
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
      select(-c(task_id:text_sas_v3_childAge, Question)) %>% 
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
      text_sas_v4_date = format(as.Date(input$text_sas_v4_date, origin="2023-01-01")),
      text_sas_v4_childAge = c(input$text_sas_v4_childAge),
      
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
             date = text_sas_v4_date,
             c_age = text_sas_v4_childAge) 
    
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
                                    c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet together")),
             K_StD_Q1 = factor(K_StD_Q1, app_values_1_5,
                               c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
                                 "Stepped out", "Stood feet together")),
             sas_v4_std_q3 = factor(sas_v4_std_q3, app_values_1_5,
                                    c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
                                      "Stepped out", "Stood feet tandem")),
             K_StD_Q3 = factor(K_StD_Q3, app_values_1_5,
                               c("NA", "Non-complaint", "Fell or grabbed", "Shifted to floor",
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
      select(-c(task_id:text_sas_v4_childAge, Question)) %>% 
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
