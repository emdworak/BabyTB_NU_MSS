# Load packages ----
### Need these packages for connecting to OneDrive.
## Currently not working, so code is commented out
# library(AzureAuth)
# library(AzureGraph)
# library(Microsoft365R)

library(psych)
library(tidyverse)
library(DT)
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(googlesheets4)
library(shinydashboard)

# Set up how to write data to one drive -------
### Need this code for connecting to OneDrive.
## Currently not working, so code is commented out

# ## Load the personal files
# load(file = "authentication_files/authentication_info.rdata")
#
# tenant <- tenant
#
# # the application/client ID of the app registration you created in AAD
# # - not to be confused with the 'object ID' or 'service principal ID'
# app <- app_id
#
# # the address of your app: also the redirect URI of your app registration
# # - AAD allows only HTTPS for non-localhost redirects, not HTTP
# redirect <- shiny_app_url
# port <- httr::parse_url(redirect)$port
# options(shiny.port=if(is.null(port)) 443 else as.numeric(port))
#
# # if your app reg has a 'webapp' redirect, it requires a client secret (password)
# # - you should NEVER put secrets in code: here we get it from an environment variable
# # - leave the environment variable unset if you have a 'desktop & mobile' redirect
# pwd <- secret
# if(pwd == "") pwd <- NULL
#
#
# resource <- c("https://graph.microsoft.com/.default", "openid")


# Establish details that will be reused throughout the shiny app-----


radio_labels <- c("Yes", "No", "NA")
radio_values <- c(1, 0, 1)
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
  dashboardHeader(title = "BabyTB Training Certification"),

  dashboardSidebar(
    width = 300,
    tags$head(
      tags$style("@import url(https://use.fontawesome.com/releases/v6.2.1/css/all.css);")
      ),

    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),
      
      menuItem("Child 1-5 Month Battery", tabName = "child_1_5", icon = icon("baby"),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
               ),
      
      menuItem("Child 6-8 Month Battery", tabName = "child_6_8", icon = icon("baby"),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Executive Function (Gaze)", tabName = "tab_efg", icon = icon("eye")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Numerical Change Detection", tabName = "tab_ncd", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Spatial Change Detection", tabName = "tab_scd", icon = icon("eye")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
               ),
      
      menuItem("Child 9-15 Month Battery", tabName = "child_9_15", icon = icon("baby"),
               menuSubItem("Social Observational (younger)", tabName = "tab_sobY", icon = icon("cubes-stacked")),
               menuSubItem("Executive Function (Gaze)", tabName = "tab_efg", icon = icon("eye")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Numerical Change Detection", tabName = "tab_ncd", icon = icon("eye")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Spatial Change Detection", tabName = "tab_scd", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
      ),
      
      menuItem("Child 16-21 Month Battery 1", tabName = "child_16_21_b1", icon = icon("baby"),
               menuSubItem("Social Observational (younger)", tabName = "tab_sobY", icon = icon("cubes-stacked")),
               menuSubItem("Executive Function (Gaze)", tabName = "tab_efg", icon = icon("eye")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Numerical Change Detection", tabName = "tab_ncd", icon = icon("eye")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Spatial Change Detection", tabName = "tab_scd", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
      ),
      
      menuItem("Child 16-21 Month Battery 2", tabName = "child_16_21_b2", icon = icon("baby"),
               menuSubItem("Social Observational (younger)", tabName = "tab_sobY", icon = icon("cubes-stacked")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Numerical Change Detection", tabName = "tab_ncd", icon = icon("eye")),
               menuSubItem("Spatial Change Detection", tabName = "tab_scd", icon = icon("eye")),
               menuSubItem("NBT Touch Screen Tutorial", tabName = "tab_touch", icon = icon("hand-point-up")),
               menuSubItem("EF Learning & Memory", tabName = "tab_elm", icon = icon("brain")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
      ),
      
      menuItem("Child 22-23 Month Battery", tabName = "child_22_23", icon = icon("child"),
               menuSubItem("Social Observational (younger)", tabName = "tab_sobY", icon = icon("cubes-stacked")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Numerical Change Detection", tabName = "tab_ncd", icon = icon("eye")),
               menuSubItem("Spatial Change Detection", tabName = "tab_scd", icon = icon("eye")),
               menuSubItem("NBT Touch Screen Tutorial", tabName = "tab_touch", icon = icon("hand-point-up")),
               menuSubItem("EF Learning & Memory", tabName = "tab_elm", icon = icon("brain")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
      ),
      
      menuItem("Child 24-36 Month Battery", tabName = "child_24_36", icon = icon("child"),
               menuSubItem("Social Observational (older)", tabName = "tab_sobO", icon = icon("cubes-stacked")),
               menuSubItem("NBT Touch Screen Tutorial", tabName = "tab_touch", icon = icon("hand-point-up")),
               menuSubItem("EF Learning & Memory", tabName = "tab_elm", icon = icon("brain")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Picture Vocab", tabName = "tab_pv", icon = icon("comment")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Verbal Counting", tabName = "tab_vc", icon = icon("arrow-up-9-1")),
               menuSubItem("Object Counting", tabName = "tab_oc", icon = icon("arrow-up-9-1")),
               menuSubItem("Subitizing", tabName = "tab_sub", icon = icon("arrow-up-9-1")),
               menuSubItem("Who Has More", tabName = "tab_whm", icon = icon("arrow-up-9-1")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
      ),
      
      
      menuItem("Child 37+ Month Battery", tabName = "child_37_plus", icon = icon("child"),
               menuSubItem("Social Observational (older)", tabName = "tab_sobO", icon = icon("cubes-stacked")),
               menuSubItem("NBT Touch Screen Tutorial", tabName = "tab_touch", icon = icon("hand-point-up")),
               menuSubItem("EF Learning & Memory", tabName = "tab_elm", icon = icon("brain")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Picture Vocab", tabName = "tab_pv", icon = icon("comment")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_gug", icon = icon("person-running")),
               menuSubItem("Verbal Counting", tabName = "tab_vc", icon = icon("arrow-up-9-1")),
               menuSubItem("Object Counting", tabName = "tab_oc", icon = icon("arrow-up-9-1")),
               menuSubItem("Subitizing", tabName = "tab_sub", icon = icon("arrow-up-9-1")),
               menuSubItem("Who Has More", tabName = "tab_whm", icon = icon("arrow-up-9-1")),
               menuSubItem("Verbal Arithmetic", tabName = "tab_va", icon = icon("arrow-up-9-1")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
############### It needs to be determined if PSM and Speeded Matching will be certified      
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

## Executive Function (Gaze) page ------
      tabItem(tabName = "tab_efg",
              
              h2("Certification Checklist for Executive Function (Gaze)"),
              h3("Certification Details"),
              
              fluidRow(
                column(6,
                       textInput("text_efg_person", h4("Person being certified:"),
                                 value = "")
                ),
                
                column(6,
                       textInput("text_efg_site", h4("Site:"),
                                 value = "")
                ),
                
                column(6,
                       dateInput("text_efg_date",
                                 label = "Date (yyyy-mm-dd)",
                                 value = Sys.Date()
                       )
                ),
                
                
                column(6,
                       textInput("text_efg_certifier", h4("Certifier:"),
                                 value = "")
                ),
                
                column(6,
                       numericInput("text_efg_childAge", h4("Child Age (in months):"),
                                    value = "", min = 0, max = 60, step = 0.5)
                )
                
              ),
              
              h3("Set-Up"),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_002", p("Child is in high-chair or on caregiver’s lap."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_003", p("If latter, caregiver shields face or looks down throughout testing."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_004", p("If highchair, caregiver is sitting behind child in chair."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_005", p("Caregiver does not interact with child, once test begins."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_006", p("Examiner stands behind child, to the right side and out of view."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       textAreaInput("text_efg_001", h4("Notes about setup."),
                                     value = ""))
              ),
              
              h3("Head Placement"),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_007", p("iPad should not be tilted."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_008", p("iPad close to child, but not in reach."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_009", p("iPad camera at height of child’s eyes."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_010", p("Examiner adjusts iPad, table or child’s chair to get iPad camera height correct."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_011", p("Border on iPad screen stays blue, not flashing."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_012", p("If border is red, examiner adjusts tilt, height, or distance from child, until border is blue."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_013", p("Examiner taps NEXT when border turns blue."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       textAreaInput("text_efg_002", h4("Notes about head placement."),
                                     value = ""))
              ),
              
              h3("Calibration"),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_014", p("Child cannot be wearing mask."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_015", p("Child cannot be using pacifier."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_016", p("Distractions are removed from room."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_017", p("Caregiver may sit nearer to child but out of view of iPad camera."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_018", p("Animations appear in all four corners of screen."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_019", p("If iPad register look in all 4 corners, it moves to test."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above)."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly and go to calibration again (see above)."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       textAreaInput("text_efg_003", h4("Notes about calibration."),
                                     value = ""))
              ),
              
              h3("Testing"),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_022", p("Examiner waits for child to look back if distracted."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_023", p("Examiner tries to redirect child if child is distracted by tapping on back of iPad."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_024", p("If redirecting is more distracting, examiner backs off."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_025", p("Examiner repositions child if they have squirmed."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_026", p("Examiner avoids eye-contact with child."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_027", p("Examiner goes back to position behind child."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              
              fluidRow(
                column(6,
                       textAreaInput("text_efg_004", h4("Notes about testing."),
                                     value = ""))
              ),
              
              
              
              
              
              fluidRow(
                column(1,
                       actionButton(inputId = "efg_submit", label = "Submit",
                                    icon = NULL, width = NULL))
              ),
              
              h2("Your Score"),
              fluidRow(
                column(12,
                       verbatimTextOutput("efg_score"))
              )
      ),
      
      
## Numerical Change Detection page ------
tabItem(tabName = "tab_ncd",
        
        h2("Certification Checklist for Numerical Change Detection"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_ncd_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_ncd_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_ncd_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_ncd_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_ncd_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Set-Up"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_002", p("Child is in high-chair or on caregiver’s lap."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_003", p("If latter, caregiver shields face or looks down throughout testing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_004", p("If highchair, caregiver is sitting behind child in chair."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_005", p("Caregiver does not interact with child, once test begins."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_006", p("Examiner stands behind child, to the right side and out of view."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_ncd_001", h4("Notes about setup."),
                               value = ""))
        ),
        
        h3("Head Placement"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_007", p("iPad should not be tilted."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_008", p("iPad close to child, but not in reach."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_009", p("iPad camera at height of child’s eyes."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_010", p("Examiner adjusts iPad, table or child’s chair to get iPad camera height correct."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_011", p("Border on iPad screen stays blue, not flashing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_012", p("If border is red, examiner adjusts tilt, height, or distance from child, until border is blue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_013", p("Examiner taps NEXT when border turns blue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_ncd_002", h4("Notes about head placement."),
                               value = ""))
        ),
        
        h3("Calibration"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_014", p("Child cannot be wearing mask."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_015", p("Child cannot be using pacifier."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_016", p("Distractions are removed from room."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_017", p("Caregiver may sit nearer to child but out of view of iPad camera."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_018", p("Animations appear in all four corners of screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_019", p("If iPad register look in all 4 corners, it moves to test."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly and go to calibration again (see above)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_ncd_003", h4("Notes about calibration."),
                               value = ""))
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_022", p("Examiner waits for child to look back if distracted."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_023", p("Examiner tries to redirect child if child is distracted by tapping on back of iPad."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_024", p("If redirecting is more distracting, examiner backs off."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_025", p("Examiner repositions child if they have squirmed."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_026", p("Examiner avoids eye-contact with child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_027", p("Examiner goes back to position behind child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_ncd_004", h4("Notes about testing."),
                               value = ""))
        ),
        
        
        
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "ncd_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("ncd_score"))
        )
),


## Spatial Change Detection page ------
tabItem(tabName = "tab_scd",
        
        h2("Certification Checklist for Spatial Change Detection"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_scd_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_scd_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_scd_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_scd_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_scd_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Set-Up"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_002", p("Child is in high-chair or on caregiver’s lap."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_003", p("If latter, caregiver shields face or looks down throughout testing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_004", p("If highchair, caregiver is sitting behind child in chair."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_005", p("Caregiver does not interact with child, once test begins."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_006", p("Examiner stands behind child, to the right side and out of view."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_scd_001", h4("Notes about setup."),
                               value = ""))
        ),
        
        h3("Head Placement"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_007", p("iPad should not be tilted."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_008", p("iPad close to child, but not in reach."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_009", p("iPad camera at height of child’s eyes."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_010", p("Examiner adjusts iPad, table or child’s chair to get iPad camera height correct."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_011", p("Border on iPad screen stays blue, not flashing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_012", p("If border is red, examiner adjusts tilt, height, or distance from child, until border is blue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_013", p("Examiner taps NEXT when border turns blue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_scd_002", h4("Notes about head placement."),
                               value = ""))
        ),
        
        h3("Calibration"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_014", p("Child cannot be wearing mask."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_015", p("Child cannot be using pacifier."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_016", p("Distractions are removed from room."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_017", p("Caregiver may sit nearer to child but out of view of iPad camera."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_018", p("Animations appear in all four corners of screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_019", p("If iPad register look in all 4 corners, it moves to test."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly and go to calibration again (see above)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_scd_003", h4("Notes about calibration."),
                               value = ""))
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_022", p("Examiner waits for child to look back if distracted."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_023", p("Examiner tries to redirect child if child is distracted by tapping on back of iPad."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_024", p("If redirecting is more distracting, examiner backs off."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_025", p("Examiner repositions child if they have squirmed."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_026", p("Examiner avoids eye-contact with child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_027", p("Examiner goes back to position behind child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_scd_004", h4("Notes about testing."),
                               value = ""))
        ),
        
        
        
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "scd_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("scd_score"))
        )
),


## Looking While Listening page ------
tabItem(tabName = "tab_lwl",
        
        h2("Certification Checklist for Looking While Listening"),
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
                 dateInput("text_lwl_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_lwl_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_lwl_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Set-Up"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_002", p("Child is in high-chair or on caregiver’s lap."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_003", p("If latter, caregiver shields face or looks down throughout testing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_004", p("If highchair, caregiver is sitting behind child in chair."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_005", p("Caregiver does not interact with child, once test begins."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_006", p("Examiner stands behind child, to the right side and out of view."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_lwl_001", h4("Notes about setup."),
                               value = ""))
        ),
        
        h3("Head Placement"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_007", p("iPad should not be tilted."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_008", p("iPad close to child, but not in reach."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_009", p("iPad camera at height of child’s eyes."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_010", p("Examiner adjusts iPad, table or child’s chair to get iPad camera height correct."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_011", p("Border on iPad screen stays blue, not flashing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_012", p("If border is red, examiner adjusts tilt, height, or distance from child, until border is blue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_013", p("Examiner taps NEXT when border turns blue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_lwl_002", h4("Notes about head placement."),
                               value = ""))
        ),
        
        h3("Calibration"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_014", p("Child cannot be wearing mask."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_015", p("Child cannot be using pacifier."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_016", p("Distractions are removed from room."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_017", p("Caregiver may sit nearer to child but out of view of iPad camera."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_018", p("Animations appear in all four corners of screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_019", p("If iPad register look in all 4 corners, it moves to test."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly and go to calibration again (see above)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_lwl_003", h4("Notes about calibration."),
                               value = ""))
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_022", p("Examiner waits for child to look back if distracted."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_023", p("Examiner tries to redirect child if child is distracted by tapping on back of iPad."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_024", p("If redirecting is more distracting, examiner backs off."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_025", p("Examiner repositions child if they have squirmed."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_026", p("Examiner avoids eye-contact with child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_027", p("Examiner goes back to position behind child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_lwl_004", h4("Notes about testing."),
                               value = ""))
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


## Mullen Expressive Language Observational page ------

tabItem(tabName = "tab_melo",
        
        h2("Certification Checklist for Mullen Expressive Language Observational"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_melo_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_melo_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_melo_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_melo_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_melo_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Upload Examiner File"),
        
        fluidRow(
          column(6,
                 fileInput("melo_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),
        
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el2", p("EL2: Vocalizes (any throaty sounds)"),
                              choiceNames = c("Vocalizes", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el3", p("EL3: Smiles and makes happy sounds."),
                              choiceNames = c("Smiles and Makes Happy Sounds", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el4", p("EL4: Coos, chuckles, or laughs (makes 2 of 3 sounds)"),
                              choiceNames = c("Coos, Chuckles, or Laughs", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el5", p("EL5: Makes vocalizations (uses 2 or more sounds, like ah, eh, m);  Examiner can ask caregiver."),
                              choiceNames = c("Make Vocalizations", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el6", p("EL6: Plays with sounds (such as o, u, a-a-a, ah-goo);  Examiner can ask caregiver."),
                              choiceNames = c("Plays with Sounds", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el8", p("EL8: Produces 3 consonant sounds (such as p, d, k, g, m)."),
                              choiceNames = c("Produces 3 Consonant Sounds", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el12", p("EL12: Jabbers with inflection (changes in inflection; different tones or pitch)."),
                              choiceNames = c("Jabbers with Inflection", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el13", p("EL13: Combines jargon/gestures (jargon + gestures, touching or looking)."),
                              choiceNames = c("Combines Jargon/Gestures", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el14", p("EL14: Combines words/gestures (word approximations with pointing or gesturing); Examiner can ask caregiver."),
                              choiceNames = c("Combines Words/Gestures", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el17", p("EL17: Uses 2-word phrases."),
                              choiceNames = c("Uses 2-Word Phrases", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el19", p("EL19: Uses pronouns (such as “my”, “mine”, “you” or “me”)."),
                              choiceNames = c("Uses Pronouns", "Unselected"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el22", p("EL22: Uses 3 to 4 word sentences."),
                              choiceNames = c("Uses 3 to 4 Word Sentences", "Unselecte."), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_melo_001", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "melo_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("melo_score"))
        # ),
        # 
        # h4("This will be removed, but it's here to show that the data upload worked"),
        # fluidRow(
        #   column(12,
        #          tableOutput("test"))
        )
),

## Mullen Expressive Language Prompted page ----

    tabItem(tabName = "tab_melp",

            h2("Certification Checklist for Mullen Expressive Language Prompted"),
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
                     dateInput("text_melp_date",
                               label = "Date (yyyy-mm-dd)",
                               value = Sys.Date()
                     )
              ),


              column(6,
                     textInput("text_melp_certifier", h4("Certifier:"),
                               value = "")
              ),

              column(6,
                     numericInput("text_melp_childAge", h4("Child Age (in months):"),
                                  value = "", min = 0, max = 60, step = 0.5)
              )

            ),

            h3("Upload Examiner File"),
            
            fileInput("melp_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                      multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),

            h3("Before Beginning"),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_001", p("iPad is set up correctly."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_002", p("Seating is correct for child, caregiver, and examiner."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),

            fluidRow(
              column(6,
                     textAreaInput("text_melp_001", h4("Notes about setup."),
                               value = "")
              )
            ),

            fluidRow(
              column(6, h3("Testing")
                     ),
              
              column(6, h3("How You Would Score the Task?")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_004", p("Examiner slides purple button to the right to begin."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),


            fluidRow(
              column(6,
                     radioButtons("radio_melp_005", p("Examiner reviews instructions and slides purple button to right."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),



            fluidRow(
              column(6,
                     radioButtons("radio_melp_006", p("Age 1-23 months: EL7: Voluntary Babbling: Attracts child's attention with repeated sounds."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),


              column(6,
                     radioButtons("radio_melp_el7", p("EL7: Voluntary Babbling."),
                                  choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_007", p("Age 1-23 months: EL10: Plays Gestures / Language Game; asks caregiver which gesture/language game child enjoys (pat-a-cake, peek-a-boo)"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_008", p("Examiner plays game with child; observes child's enjoyment."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el10", p("EL10: Plays Gestures/Language Game."),
                                  choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_009", p("Age 1-23 months: EL11: Says first words; ask caregiver which words child says and try to elicit words."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el11", p("EL11: Says first words."),
                                  choiceNames = c("NA", "Zero", "One",
                                                  "Two to seven", "Eight or more"),
                                  choiceValues = app_values4,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_010", p("All ages: EL15: Names objects: Examiner lays out objects on table in front of child but not reachable by child; points to each item and asks “what is this?” or “what do we call this?”"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el15", p("EL15: Names objects."),
                                  choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                                  "4 or 5 endorsed buttons", "6 endorsed buttons"),
                                  choiceValues = app_values4,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_011", p("All ages: EL16: Labels pictures: Examiner shows child 3 images and points to each, asking “what is this?” or “what do we call this?”"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el16", p("EL16: Labels Pictures."),
                                  choiceNames = c("NA", "Does not label labels at least one picture",
                                                  "Labels at least one picture"),
                                  choiceValues = app_values2,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     textAreaInput("text_melp_002", h4("Notes about testing."),
                                   value = "")
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
                     verbatimTextOutput("melp_score"))
            ),

            h4("This will be removed, but it's here to show that the data upload worked"),
            fluidRow(
              column(12,
                     tableOutput("test"))
            )
    ),
## Picture Vocab page ------

tabItem(tabName = "tab_pv",

        h2("Certification Checklist for Picture Vocab"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_pv_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_pv_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_pv_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_pv_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_pv_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_001", p("iPad is set up so that both examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_002", p("Child, caregiver, and examiner are seated correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),


        fluidRow(
          column(6,
                 textAreaInput("text_pv_001", h4("Notes about setup."),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_003", p("iPad sound is loud enough for child and examiner to hear."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_pv_004", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_pv_005", p("After App audio reads the instructions, NEXT button is active and examiner taps it."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_pv_006", p("Practice item 1 is presented; child has 3 attempts. If child does not succeed in 3 tries, examiner should touch picture of Banana, saying: “this is a banana”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_007", p("Practice item 2 is presented, child has 3 attempts. If child does not succeed in 3 tries, examiner should touch picture of Banana, saying: “this is a spoon”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_008", p("App audio reads a second set of instructions. After confirming child is ready to begin, examiner slides purple button to the right.."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_009", p("The items appear one at a time for about  5 minutes.  Examiner does nothing during this time unless child has trouble touching the screen.  In this case, child points to response choice and examiner touches the screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_010", p("If child repeats a word several times, examiner may say the word once and encourage child to choose a picture."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_011", p("Test continues until all items are presented."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_pv_002", h4("Notes about testing."),
                               value = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "pv_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("pv_score"))
        )
),

## Social Observational (younger) page ------

tabItem(tabName = "tab_sobY",

        h2("Certification Checklist for Social Observational (ages 9-23 months)"),
        
        h3("Certification Details"),

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
                 textInput("text_sobY_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_sobY_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("sobY_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_001", p("Set up is correct- table and chairs in right place."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_002", p("Child is at table and sitting in correct position."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_003", p("Examiner reads instructions to the caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_004", p("Has toys for transitions available for child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sobY_001", h4("Notes about setup."),
                               value = "")
          )
        ),

        fluidRow(
          column(6, h3("Communicative Temptation 1: Minute One")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
      
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_005", p("Step 1- Examiner activates wind-up toy."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_1", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_006", p("Step 2- Examiner engages in social exchange of turns activates wind-up toy."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_2", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_007", p("Step 3- If necessary, examiner requests wind-up toy back."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_3", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_008", p("Step 4- Examiner activates wind-up toy."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_4", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_009", p("Step 5- Examiner engages in social exchange of turns."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_5", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_010", p("Step 6- Examiner requests wind-up toy back and bye-bye."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_6", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),

        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_7", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_002", h4("Notes about minute one of testing."),
                               value = "")
          )
        ),

        fluidRow(
          column(6, h3("Response to Name & Gaze/Point 1: Minute Two")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_011", p("Has car and places in front of child and to side of examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_9", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_012", p("Step 1- Examiner calls child’s name."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_10", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_013", p("Step 2- Examiner points to car and says, “LOOK!”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_11", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_014", p("Step 3- Examiner gives child car to play with."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_12", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_015", p("Step 4- Examiner engage in social exchange of turns."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_13", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_016", p("Step 5- Examiner requests requests car or gently removes."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_14", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_15", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_16", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_17", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_003", h4("Notes about minute two of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Communication Temptation 2: Minute Three")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_017", p("Has required toys."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_19", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_018", p("Puts figure in jar."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_20", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_019", p("Step 1- Examiner puts jar w/ figure inside in front of child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_21", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_020", p("Step 2- Examiner opens lid and gives to child, engages in social exchange of turns."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_22", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_021", p("Step 3- Examiner requests jar back- holds out hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_23", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_022", p("Step 4- Examiner puts stringy ball in jar, closes lid, and hands child the jar."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_24", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_023", p("Step 5- Examiner opens lid and gives to child, engages in social exchange of turns."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_25", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_024", p("Step 6- Examiner requests jar back, holds out hand, and bye-bye."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_004", h4("Notes about minute three of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Communicative Temptation 3, probe 2: Minute Four")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_025", p("Examiner has small figure from previous placed at table height behind child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_27", p("Responds to name."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_026", p("Step 1 (9-15 mos)- Examiner plays “Walk mouse, creep mouse” with 2 trials separated by 3 secs and bye-bye."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_28", p("Follows gaze/point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_027", p("Step 1 (16-23 mos)- Examiner plays “Itsy Bitsy Spider” with 2 trials separated by 3 secs and bye-bye at end."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_29", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_028", p("Step 2- Calls child’s name."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_30", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_029", p("Step 3- Examiner point to objects and says, “LOOK!”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_31", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_030", p("Step 4- Label object. The examiner tries to get child to look in direction by tapping before the examiner labels object."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_32", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_031", p("Step 5- Examiner and child engage in social exchange of turns about object."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_33", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_34", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_35", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_005", h4("Notes about minute four of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Sharing Books 1: Minute Five")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_032", p("Has requisite two books."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_37", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_033", p("Step 1- Examiner allows child to choose one of two books."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_38", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_034", p("Step 2- Examiner encourages social interaction by looking through the book together."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_39", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_035", p("Step 3- Examiner points, names or describes a picture on the page the child has open."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_40", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_036", p("Step 4- Examiner removes first book; says bye-bye book."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_41", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_42", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_43", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_006", h4("Notes about minute five of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Sharing Books 2: Minute Six")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_037", p("Has same books as earlier."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_45", p("2-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_038", p("Step 1- Examiner gives child remaining book."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_46", p("3-point gaze shift."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_039", p("Step 2- Examiner encourages social interactions by looking through book with child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_47", p("Smiles without look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_040", p("Step 3- Examiner points, names or describes a picture on the page the child has open."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_48", p("Smiles with look."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_041", p("Step 4- Examiner removes book; says bye-bye book."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_49", p("Show gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_50", p("Uses point gesture."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_51", p("Comments with sounds or words."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_007", h4("Notes about minute six of testing."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6,  h3("Parent/Caregiver-Child Play 1: Minute Seven")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_042", p("Has feeding playset."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_53", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_043", p("Step 1- Examiner explains play activity to caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_54", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_044", p("Step 2- Examiner brings out feeding playset."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_55", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_045", p("Step 3- Examiner encourages play."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_56", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_046", p("Step 4- Examiner brings out small bowl and plate; encourages more play."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_57", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_047", p("Step 5- Examiner engages with child; names actions or objects child is touching."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_008", h4("Notes about minute seven of testing."),
                               value = "")
          )
        ),
        

        fluidRow(
          column(6,  h3("Parent/Caregiver-Child Play 2: Minute Eight")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_048", p("Has matching feeding playset for parent and cooking playset."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_66", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_049", p("Step 1- Examiner gives feeding playset to caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_67", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_050", p("Step 2- Examiner asks caregiver to demonstrate pretend play (feeding)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_68", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_051", p("Step 3- Examiner brings out pan, lid and spatula from cooking set; put between the caregiver and child."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_69", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_052", p("Step 4- Examiner asks caregiver to encourage child to play."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_70", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_009", h4("Notes about minute eight of testing"),
                               value = "")
          )
        ),

                
        fluidRow(
          column(6,  h3("Parent/Caregiver-Child Play 3: Minute Nine")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_053", p("Has cooking playset."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_79", p("Explores features of object"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_054", p("Step 1- Examiner brings out large bowl and large spoon; place between child and caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_80", p("Uses item functionally"),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_055", p("Step 2- Examiner asks caregiver to demonstrate pretend play: cooking and serving."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_81", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_056", p("Step 3- Examiner encourages child to pretend cooking and serving."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_82", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_83", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_010", h4("Notes about minute nine of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6,  h3("Parent/Caregiver-Child Play 4: Minute Ten")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_057", p("Has four toys from earlier minutes 1-4."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_92", p("Explores features of object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_058", p("Step 1- Examiner offers one of the other toys for the child to incorporate into the play."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_93", p("Uses item functionally."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_059", p("Step 2- Examiner asks parent to pretend play (cooking and serving)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_94", p("Pretends toward other (caregiver, examiner, doll)."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobY_060", p("Step 3- Examiner encourages child to caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobY_SO_9_23_95", p("2 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_sobY_SO_9_23_96", p("3 Pretend action sequences."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobY_011", h4("Notes about minute ten of testing."),
                               value = "")
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

tabItem(tabName = "tab_sobO",
        
        h2("Certification Checklist for Social Observational (ages 24 months and older)"),
        
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_sobO_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_sobO_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_sobO_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_sobO_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_sobO_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Upload Examiner File"),
        
        fluidRow(
          column(6,
                 fileInput("sobO_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),
        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_001", p("Set up is correct- table and chairs in right place."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_002", p("Child is at table and sitting in correct position."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_003", p("Examiner reads instructions to the caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_004", p("Has toys for transitions available for chil."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobO_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6,  h3("Joint Attention: Minute One")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_005", p("Cooking pot placed without child taking note."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_1", p("Following point."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_006", p("Examiner pulls out cookware and puts on table."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_2", p("Complies with request (pot) spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_007", p("Examiner completes set-up/ intro script: “Hey [name], I’ve got…”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_3", p("Complies with request after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_008", p("Step 1- “missing my cooking pot” and pointing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_4", p("Comments on jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_009", p("Step 2- If necessary, examiner brings cooking pot."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_5", p("Points to jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_010", p("Step 3- If pot not opened, examiner asks child to do so."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_6", p("Shows jungle animal."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobO_002", h4("Notes about minute one of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6,  h3("Pretend Play: Minutes Two-Three")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_011", p("Puts out doll and action figure."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_7", p("Child-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_012", p("Child choses between above."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_8", p("Substitution."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_013", p("Step 1- Examiner demonstrates pretend play."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_9", p("Substitution without object."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_014", p("Step 2- Examiner demonstrates substitution if necessary."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_10", p("Dolls-as-agent."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_015", p("Step 3- Examiner mirrors child’s pretend and escalate if child does not escalate."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_11", p("Socio-dramatic play."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_016", p("Step 4- Examiner removes all items."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobO_003", h4("Notes about minutes two-three of testing."),
                               value = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,  h3("Prosocial Behavior: Minutes Four-Five")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_017", p("Has required toys."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_12", p("Shares blocks."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_018", p("Dumps out the bags of blocks."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_13", p("Takes turns building tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_019", p("Step 1- Examiner indicates discrepancy in number of blocks to encourage sharing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_14", p("Picks up fallen blocks or repairs tower."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_020", p("Step 2- Examiner takes turns building tower."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_15", p("Concerned facial expression."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_021", p("Step 3- Examiner accidently knocks over tower."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_16", p("Verbal concern/comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_022", p("Step 4- Examiner expresses disappointment."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_17", p("Physical comforting."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_023", p("Step 5- Examiner starts cleaning; requests help if necessary."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_18", p("Helps clean up spontaneously."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, offset = 6, 
                 radioButtons("radio_sobO_SO_24_48_19",  p("Helps clean up after prompt."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobO_004", h4("Notes about minute four-five of testing."),
                               value = "")
          )
        ),
        
  
        
        
        fluidRow(
          column(6,  h3("Social Communication 1: Minutes Six-Seven")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_024", p("Has required Duplo set in container."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_20", p("Rebuilds elephant at least 2-steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_025", p("ELephant is disassembled when brought out."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_21", p("Rebuilds elephant all steps."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_026", p("Step 1- Examiner demonstrates the 4 steps to “correctly” assemble elephant using the words: this goes here, for each step."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_22", p("Steps in correct order."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_027", p("Step 2- Examiner disassembles and puts back in container; give to child: “Can you build it like I did?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_23", p("Asks for help opening container."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_028", p("Step 3- Examiner offers help if needed."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_029", p("Step 4- Examiner remove all items."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobO_005", h4("Notes about minute six-seven of testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6,  h3("Social Communications 2: Minutes Eight-Ten")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_030", p("Has requisite book: I spy."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_24", p("Initiates/responds to conversation."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_031", p("Set-up- Examiner introduces book."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_25", p("Takes a conversational turn."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_032", p("Step 1- Examiner opens book to invite conversation."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_26", p("Responds to a shift in topic."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_033", p("Step 2- Examiner mentions hat, then butterfly to encourage conversation and turn taking."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_27", p("Corrects mislabeling by protest only."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_034", p("Step 3- Examiner points to another object to shift conversation."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sobO_SO_24_48_28", p("Corrects mislabeling by giving correct label."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_035", p("Step 4- Examiner turns page and mislabels book as “dog”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          column(6, 
                 radioButtons("radio_sobO_SO_24_48_29", p("Adapts speech register for doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_036", p("Step 5- Examiner pretends with doll and book."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6, 
                 radioButtons("radio_sobO_SO_24_48_30", p("Turns book to face doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sobO_037", p("Step 6- Examiner clears table."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6, 
                 radioButtons("radio_sobO_SO_24_48_31", p("Attempts to teach doll."),
                              choiceNames = c("Yes", "No"), choiceValues = app_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sobO_006", h4("Notes about minute eight-ten of testing."),
                               value = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "sobO_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sobO_score"))
        )
),

## Who Has More page ------

tabItem(tabName = "tab_whm",
        
        h2("Certification Checklist for Who Has More"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_whm_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_whm_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_whm_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_whm_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_whm_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_001", p("iPad is set up correctly so that both the examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_whm_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_003", p("iPad sound is loud enough for child and examiner to hear."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_004", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_005", p("Examiner demonstration item is presented."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_006", p("On 4th screen, examiner touches the bird with more berries."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_007", p("When NEXT button is active, examiner taps it."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_008", p("Examiner reads: Now it’s your turn. Remember to select the box that has the most items."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_009", p("Examiner slides purple button to the right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_010", p("Practice item appears and the audio says: “Who has more?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_011", p("Examiner encourages the child to make a choice and after the child choses, the examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_012", p("If the child makes an incorrect choice, the audio says: “Try Again.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_013", p("After answering correctly or after three incorrect answers, the App moves to live items."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_014", p("Examiner reminds child to tap the box with more items."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_015", p("Examiner slides purple button to the right to bring up test items."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_016", p("The items appear automatically after the child makes a choice."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_whm_017", p("Test continues until the child answers incorrectly and/or times out on 4 live items in a row."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_whm_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "whm_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("whm_score"))
        )
),

## Subitizing page ------

tabItem(tabName = "tab_sub",

        h2("Certification Checklist for Subitizing"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_sub_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sub_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sub_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_sub_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_sub_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_001", p("iPad is set up correctly so that both the examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sub_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_003", p("iPad sound is loud enough for child and examiner to hear."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_004", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_005", p("After audio prompt says “Look at the screen” NEXT button is active and examiner taps it."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_006", p("Item appears for one second and audio prompts: “how many did you see?” "),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_007", p("Examiner taps NEXT and records child’s answer on a screen with three choices: Numeric response; No response; or invalid response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_008", p("After entering response, examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_009", p("The 2nd item appears for one second and audio prompts: “How many did you see?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_010", p("Examiner taps NEXT and records child’s answer on a screen with three choices: Numeric response; No response; or invalid response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_011", p("After entering response, examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sub_012", p("Test continues until all items are presented."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sub_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "sub_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        
        fluidRow(
          column(12,
                 verbatimTextOutput("sub_score"))
        )
),

## Object Counting page ------

tabItem(tabName = "tab_oc",

        h2("Certification Checklist for Object Counting"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_oc_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_oc_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_oc_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_oc_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_oc_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_001", p("iPad is set up correctly so that both the examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_oc_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_003", p("iPad sound is loud enough for child and examiner to hear."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_004", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_005", p("The 1st item appears and audio prompts: “Look at the screen.” “How many are there?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_006", p("Examiner taps NEXT and records child’s answer on a screen with three choices: Numeric response; No response; or invalid response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_007", p("After entering the child’s response, the examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_008", p("The 2nd item appears and audio prompts: “How many are there?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_009", p("Examiner taps NEXT and records child’s answer on a screen with three choices: Numeric response; No response; or invalid response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_010", p("After entering the child’s response, the examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_011", p("The 3rd item appears and audio prompts: “How many are there?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_012", p("Examiner taps NEXT and records child’s answer on a screen with three choices: Numeric response; No response; or invalid response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_013", p("After entering the child’s response, the examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_oc_014", p("The pattern above continues until the last item or until the response option for the 1st or 3rd  item is: an incorrect numerical choice; no response; or an invalid response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_oc_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "oc_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("oc_score"))
        )
),


## Verbal Arithmetic page ------

tabItem(tabName = "tab_va",

        h2("Certification Checklist for Verbal Arithmetic"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_va_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_va_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_va_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_va_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_va_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_001", p("iPad is set up correctly so that both the examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_003", p("There are 5 blocks on table to use."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_va_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_004", p("Examiner puts blocks on table to their right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_005", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_006", p("Examiner reads the first problem: ”If I have two blocks and I find another one, how many do I have now?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_007", p("If child answers, examiner records the child’s answer on screen and taps NEXT button."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_008", p("If child doesn’t answer, examiner waits 5 seconds and asks question again; this time taking first 2 blocks and adding 1 block from blocks to the examiner’s right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_009", p("If the child doesn’t answer within 10 seconds, examiner taps No Response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_010", p("After entering the child’s response, the examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_011", p("The sequence above is repeated through the remaining 4 questions:", 
                                                br(), "If I have 1 block and my friend D gives me 3 more, how many…", 
                                                br(), "If I have 4 blocks and I lose 1, how many…", 
                                                br(), "If I have 2 blocks and I lose 1, how many…", 
                                                br(), "If have 3 blocks and my friend J takes 2, how many… "),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_va_012", p("Test continues until all 5 questions are presented."),
                      choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                 )
          ),

        fluidRow(
          column(6,
                 textAreaInput("text_va_002", h4("Notes about testing."),
                               value = "")
          )
        ),

        fluidRow(
          column(1,
                 actionButton(inputId = "va_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("va_score"))
        )
        ),


## Verbal Counting page ------

tabItem(tabName = "tab_vc",

        h2("Certification Checklist for Verbal Counting"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_vc_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_vc_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_vc_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_vc_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_vc_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),


        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_001", p("iPad is set up correctly so that both the examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_vc_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_003", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_004", p("Examiner asks: “How high can you count? Please start at one and show me?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_005", p("When child stops counting, examiner prompts, saying: “What comes next?” or “Can you count higher?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_006", p("Examiner choses response: Numeric; Did not start at 1; Invalid Response."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_vc_007", p("After entering the child’s response, the examiner taps NEXT."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_vc_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "vc_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("vc_score"))
        )
),

## Get Up and Go page ------

tabItem(tabName = "tab_gug",
        
        h2("Certification Checklist for Get Up and Go"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_gug_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_gug_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_gug_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_gug_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_gug_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Upload Examiner File"),
        
        fluidRow(
          column(6,
                 fileInput("gug_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),
        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_001", p("Has 36 x36 box."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_002", p("Has masking tape and tape measure for start and end lines."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_003", p("Has carpet, foam mat, other floor covering (recommended)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_004", p("Has attractive toy/snack to entice child to get up and go."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_005", p("Has set up the floor with the equipment above."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_gug_001", h4("Notes about setup"),
                               value = "")
          )
        ),
        
        
        h3("Questions before Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_006", p("If not observed earlier, examiner asks caregiver: “Can [child's name] get off their back?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_007", p("Examiner asks necessary follow-up questions."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_008", p("If yes above and not observed earlier, the examiner asks “Can [child's name] take forward steps independently?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_009", p("Examiner asks necessary follow-up questions."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,  h3("Pre-Locomotion (PL) Testing")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_010", p("Examiner places child on back."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_011", p("Examiner and caregiver are on the side of the mat."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_012", p("Examiner holds and shakes toy above the child’s face."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_013", p("After child reaches for toy, examiner moves toy on diagonal toward self; encourages the child to roll using name and encouraging words."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_014", p("Testing stops when child rolls to prone or after 30 seconds have elapsed."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_back", p("Did child get off back?"),
                              choiceNames = c("NA", "No (didn’t try)", "No (tried but couldn’t)", "Yes"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_015", p("Examiner begins testing prone if the child turns over."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_prone", p("What child did on belly?"),
                              choiceNames = c("NA", "Nothing, did not lift head",
                                              "Lifted head only", "Propped on forearms",
                                              "Rolled onto back", "Propped on hands",
                                              "Took steps or got off belly"),
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_016", p("If child did not turn over, examiner puts the child in prone position."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_roll", p("How child got off back? "),
                              choiceNames = c("NA", "Rolled to belly, hands trapped",
                                              "Rolled to belly, hands out", "Rolled to hands-knees",
                                              "Side lying", "Got up without rolling"),
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_017", p("Examiner encourage the child to lift head/push up with encouraging words or toys in front of face."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_uppos", p("Most upright postures?"),
                              choiceNames = c("NA", "Belly", "Hands-knees or hands-feet",
                                              "Sit or kneel, back vertical", "Stand"),
                              choiceValues = app_values5_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_018", p("Examiner tests prone skills for 30 seconds."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_sit", p("How child got to sit or kneel?"),
                              choiceNames = c("NA", "Pushed up from crawl", 
                                              "Pushed up from side lying", "Sat up directly from supine"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_gug_002", h4("Notes about pre-locomotion testing"),
                               value = "")
          )
        ),
        
        h3("Locomotion (LO) version"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_019", p("Examiner places child on back."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_stand", p("How child got to standing?"),
                              choiceNames = c("NA", "Down-dog to stand", 
                                              "Half-kneel to stand", "Squat to stand"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_020", p("Caregiver is behind the platform."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_hands", p("How many hands child used?"),
                              choiceNames = c("NA", "0", 
                                              "1", "2"),
                              choiceValues = app_values3,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_021", p("Examiner moves next to caregiver, behind box/platform and crouches there."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_turn", p("Child turned to face finish line? "),
                              choiceNames = c("NA", "Never faced finish", 
                                              "Turned to face finish", "Already facing finish"),
                              choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_022", p("Examiner encourages child to get off back and start toward platform."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_trameth", p("How child traveled?"),
                              choiceNames = c("NA", "Did not travel", "log roll", 
                                              "belly crawl", "bum shuffle or hitch", 
                                              "Hands-knees or hands-feet", "knee-walk or half-kneel", 
                                              "walk"),
                              choiceValues = app_values8,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_023", p("Examiner encourages child with words, toys, and snacks."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_toes", p("Child walked on toes?"),
                              choiceNames = c("NA", "Can't see heels", "No", 
                                              "Right foot", "Left foot", 
                                              "Both"),
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_024", p("Testing stops when child gets onto and off the platform or after 30 seconds have elapsed."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_gug_tradis", p("How far child traveled?"),
                              choiceNames = c("NA",  "Took a few steps and fell",
                                              "Took a few steps and stopped", "3 meters, not continuous",
                                              "3 meters, but dawdled", "3 meters, no dawdling"),
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_025", p("Examiner encourages child to get off the platform."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_gug_starttime", p("When did the child cross start line?", br(),
                                                       "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_gug_026", p("Examiner spots child getting onto or off the platform if child seems unsteady but does not offer support."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_gug_endtime", p("When did the child cross finish line?", br(),
                                                     "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_gug_tradis", p("How did child get up stair?"),
                              choiceNames = c("NA", "Didn't try", "Did not pull up", 
                                              "Pulled up to knees", "Pulled up to stand", 
                                              "Climbed up, stayed prone", "Climbed up, stood up", 
                                              "Tried to step & fell", "Stepped up, not integrated", 
                                              "Stepped up, gait integrated"),
                              choiceValues = app_values10,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6, offset = 6,
                 radioButtons("radio_gug_stairdo", p("How did child get down stair?"),
                              choiceNames = c("NA",  "Didn't try to come down",
                                              "Climbed down, fell", "Climbed down, stayed down",
                                              "Walked down, fell", "Walked down, not integrated",
                                              "Walked down, integrated", "Jumped or leaped & fell",
                                              "Jumped or leaped no fall"),
                              choiceValues = app_values9,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_gug_003", h4("Notes about locomotion testing"),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "gug_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("gug_score"))
        )
),

## Reach to Eat page ------

tabItem(tabName = "tab_rte",

        h2("Certification Checklist for Reach to Eat"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_rte_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_rte_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_rte_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_rte_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_rte_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("rte_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_001", p("Has “large base” (1 cup measure)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_002", p("Has “small base” (formula spoon with flat base and flat handle)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_003", p("Has 1-inch wooden cube."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_004", p("Has ~10 Cheerios or similar dry snack."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_005", p("Has spoon (approx. 6.2-inch with 1.25 inch diameter bowl)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_006", p("Has tissue to dry off spoon."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_007", p("Has hand sanitizer to clean child’s hand before they eat food and before examiner touches food child will eat."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_008", p("Set up of table is correct- caregiver and child on one side facing."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_009", p("Child’s is correct height: Child’s chest touching front edge of table and tabletop approximately below the child’s elbow (child’s arm is above tabletop)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_001", h4("Notes about setup"),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_010", p("Examiner asks caregiver if they are comfortable with us giving child cheerios or another dry but easily dissolvable snack."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_011", p("If caregiver says “no”, examiner administers Block task (BT)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_012", p("If caregiver says “yes”, examiner administers Cheerios task (CT)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6, h3("Block (BT) Task")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_013", p("Right Hand- Examiner overturns measuring cup (large base) with non-dominant hand and with dominant hand places block on top."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_014", p("Right Hand- Examiner asks caregiver to gently hold child’s left arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_015", p("Right Hand- Examiner uses both hands to move base and block to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_016", p("Right Hand- Examiner quickly releases block and pulls back dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_017", p("Right Hand- Examiner continues to hold cup with non-dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_018", p("Right Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_019", p("Right Hand- Examiner draws child's attention to the block."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lbtr_success ", p("Did child reach block with right hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp", 
                                              "Grasped from the table", "Grasped from the base"), 
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_020", p("Right Hand- If block falls off cup, examiner leaves block on table and removes cup."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lbtr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip", 
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_021", p("Left Hand- Repeats task with child’s left hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_022", p("Left Hand- Examiner overturns measuring cup (large base) with non-dominant hand and with dominant hand places block on top."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_023", p("Left Hand- Examiner asks caregiver to gently hold child’s right arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_024", p("Left Hand- Examiner uses both hands to move base and block to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_025", p("Left Hand- Examiner uses both hands to move base and block to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_026", p("Left Hand- Examiner quickly releases block and pulls back dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_027", p("Left Hand- Examiner continues to hold cup with non-dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_028", p("Left Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lbtl_success ", p("Did child reach block with left hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp", 
                                              "Grasped from the table", "Grasped from the base"), 
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_029", p("Left Hand- Examiner draws child attention to the block."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lbtl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip", 
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_030", p("Left Hand- If block falls off cup, leave block on table and remove cup."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_003", h4("Notes about block task."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6, h3("Cheerio Small Base Task")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_031", p("Right Hand- Examiner uses non-dominant hand: holds upside down formula spoon (small base) by handle and with dominant hand puts cheerio on top of spoon bowl."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_032", p("Right Hand- Examiner asks caregiver to gently hold child’s left arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_033", p("Right Hand- Examiner uses both hands to move spoon and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_034", p("Right Hand- Examiner quickly releases cheerio and pulls back dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_035", p("Right Hand- Continues to hold spoon with non-dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_036", p("Right Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_037", p("Right Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_sctr_success", p("Did child reach small base with right hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp", 
                                              "Grasped from the table", "Grasped from the base"), 
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_038", p("Right Hand- If cheerio falls off base, examiner leaves cheerio on table and removes base."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_sctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip", 
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_039", p("Left Hand- Repeats task with child’s left hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_040", p("Left Hand- Examiner uses non-dominant hand: holds upside down formula spoon (small base) by handle and with dominant hand puts cheerio on top of spoon bowl."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_041", p("Left Hand- Examiner asks caregiver to gently hold child’s right arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_042", p("Left Hand- Examiner uses both hands: moves spoon and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_043", p("Left Hand- Examiner quickly releases cheerio and pulls back dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_044", p("Left Hand- Examiner continues to hold base with non-dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_045", p("Left Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_046", p("Left Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_sctl_success ", p("Did child reach small base with left hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp", 
                                              "Grasped from the table", "Grasped from the base"), 
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_047", p("Left Hand- If cheerio falls off base, examiner leaves cheerio on table and removes base."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_sctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip", 
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_004", h4("Notes about cheerio small base task."),
                               value = "")
          )
        ),
        
        br(),
        
        fluidRow(
          tags$b("If child fails both small base trials, examiner administers 2 trials with large base.", br(), 
            "If child succeeds with either hand, examiner administers 4 trials with spoon (SPE) easy and (SPH) hard.")
        ),
        
        br(),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_048", p("Examiner administers the correct next item (large base or spoon) based on child’s behavior on small base."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6, h3("Cheerio Large Base Task")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_049", p("Right Hand- Examiner overturns measuring cup (large base) with non-dominant hand and with dominant hand places cheerio on top."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_050", p("Right Hand- Examiner asks caregiver to gently hold child’s left arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_051", p("Right Hand- Examiner uses both hands to move base and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_052", p("Right Hand- Examiner quickly releases cheerio and pulls back dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_053", p("Right Hand- Continues to hold base with non-dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_054", p("Right Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_055", p("Right Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lctr_success", p("Did child reach large base with right hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp", 
                                              "Grasped from the table", "Grasped from the base"), 
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_056", p("Right Hand- If cheerio falls off base, examiner leaves cheerio on table and removes base."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lctr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip", 
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_057", p("Left Hand- Repeats task with child’s left hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_058", p("Left Hand- overturns measuring cup (large base) with non-dominant hand and with dominant hand places cheerio on top."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_059", p("Left Hand- Examiner asks caregiver to gently hold child’s right arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_060", p("Left Hand- Examiner uses both hands: moves base and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_061", p("Left Hand- Examiner quickly releases cheerio and pulls back dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_062", p("Left Hand- Examiner continues to hold base with non-dominant hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_063", p("Left Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_064", p("Left Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lctl_success ", p("Did child reach large base with left hand?"),
                              choiceNames = c(NA, "Noncompliant", "Didn't try",
                                              "Moved arm only", "Touched but no grasp", 
                                              "Grasped from the table", "Grasped from the base"), 
                              choiceValues = app_values7,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_065", p("Left Hand- If cheerio falls off base, examiner leaves cheerio on table and removes cup"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_lctl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Multi-finger grip", 
                                              "Thumb & finger grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_005", h4("Notes about cheerio large base task."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6, h3("Cheerio Spoon Easy & Hard Tasks")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          h4("Cheerio Spoon Easy (Right Hand)")
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_066", p("Right Hand- Examiner places measuring up right side up on the table, holding the cup by the handle with your non-dominant hand and with dominant hand holding the spoon handle up (with cheerio in bowl of spoon)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_067", p("Right Hand- Examiner demonstrates using the spoon to bring cheerio to mouth."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_068", p("Right Hand- Examiner asks caregiver to gently hold child’s left arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_069", p("Right Hand- Examiner uses both hands to move cup with spoon and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnter_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio", 
                                              "Grasped spoon for transport"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_070", p("Right Hand- When cup is in place, let go of the spoon and quickly pull back dominant hand; examiner continues to hold the cup by the handle with non-dominant hand; handle of spoon should be in direction of right hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnter_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_071", p("Right Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnter_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_072", p("Right Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnter_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_073", p("Right Hand- After child grasps spoon or tries to eat cheerio directly from bowl, dry spoon with tissue and administer Hard spoon trial."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnter_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand", 
                                              "Cheerio fell", "After replacement", 
                                              "On first attempt"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_006", h4("Notes about cheerio spoon easy task with right hand."),
                               value = "")
          )
        ),
        
        fluidRow(
          h4("Cheerio Spoon Hard (Right Hand)")
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_074", p("Right Hand- Examiner places measuring up right side up on the table, holding the cup by the handle with your non-dominant hand and with dominant hand holding the spoon handle up (with cheerio in bowl of spoon."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_075", p("Right Hand- If child grabbed cheerio from base on earlier trial, examiner demonstrates using the spoon to bring cheerio to mouth."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_076", p("Right Hand- Examiner asks caregiver to gently hold child’s left arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_077", p("Right Hand- Examiner uses both hands to move cup with spoon and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthr_purpose", p("Did child use right hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio", 
                                              "Grasped spoon for transport"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_078", p("Right Hand- When cup is in place, let go of the spoon and quickly pull back dominant hand; examiner continues to hold the cup by the handle with non-dominant hand; handle of spoon should be away from the right hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthr_move", p("Did child use right hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_079", p("Right Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthr_grasp", p("Child used which grasp with right hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip", 
                                              "Adult-like grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_080", p("Right Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthr_thumb", p("Where was right hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_081", p("Right Hand- After child grasps spoon or tries to eat cheerio directly from bowl, dry spoon with tissue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthr_success", p("Did child bring cheerio to mouth with right hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand", 
                                              "Cheerio fell", "After replacement", 
                                              "On first attempt"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_007", h4("Notes about cheerio spoon hard task with right hand."),
                               value = "")
          )
        ),
  
        fluidRow(
          h4("Cheerio Spoon Easy (Left Hand)")
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_082", p("Left Hand- Examiner begins administration of Easy spoon trial to left hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_083", p("Left Hand- Examiner places measuring up right side up on the table, holding the cup by the handle with your non-dominant hand and with dominant hand holding the spoon handle up (with cheerio in bowl of spoon)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_084", p("Left Hand- If child grabbed cheerio from base on earlier trial, examiner demonstrates using the spoon to bring cheerio to mouth."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_085", p("Left Hand- Examiner asks caregiver to gently hold child’s right arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_086", p("Left Hand- Examiner uses both hands to move cup with spoon and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spntel_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio", 
                                              "Grasped spoon for transport"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_087", p("Left Hand- When cup is in place, let go of the spoon and quickly pull back dominant hand; examiner continues to hold the cup by the handle with non-dominant hand; handle of spoon should be in direction of left hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spntel_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_088", p("Left Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spntel_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip",
                                              "Adult-like grip"), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_089", p("Left Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spntel_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_090", p("Left Hand- After child grasps spoon or tries to eat cheerio directly from bowl, dry spoon with tissue and administer Hard spoon trial."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spntel_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand", 
                                              "Cheerio fell", "After replacement", 
                                              "On first attempt"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_008", h4("Notes about cheerio spoon easy task with left hand."),
                               value = "")
          )
        ),
        
        fluidRow(
          h4("Cheerio Spoon Hard (Left Hand)")
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_091", p("Left Hand- Examiner places measuring up right side up on the table, holding the cup by the handle with your non-dominant hand and with dominant hand holding the spoon handle up (with cheerio in bowl of spoon."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_092", p("Left Hand- If child grabbed cheerio from base on earlier trial, examiner demonstrates using the spoon to bring cheerio to mouth."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_093", p("Left Hand- Examiner asks caregiver to gently hold child’s right arm."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_094", p("Left Hand- Examiner uses both hands to move cup with spoon and cheerio to midline of child within easy reach from child’s chest."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthl_purpose", p("Did child use left hand to move spoon?"),
                              choiceNames = c(NA, "Noncompliant", "Refused to pick up spoon",
                                              "Picked up to play", "Grasped Cheerio", 
                                              "Grasped spoon for transport"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_095", p("Left Hand- When cup is in place, let go of the spoon and quickly pull back dominant hand; examiner continues to hold the cup by the handle with non-dominant hand; handle of spoon should be away from the left hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthl_move", p("Did child use left hand to grasp or move handle?"),
                              choiceNames = c(NA, "Grasped handle", "Moved handle"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_096", p("Left Hand- Examiner should not obstruct the camera with arm or hand."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthl_grasp", p("Child used which grasp with left hand?"),
                              choiceNames = c(NA, "Palmer grip", "Thumb & finger grip", 
                                              "Adult-like grip" ), choiceValues = app_values4_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_097", p("Left Hand- Examiner draws child's attention to the cheerio."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthl_thumb", p("Where was left hand thumb pointing?"),
                              choiceNames = c(NA, "Away from bowl", "Toward bowl"), 
                              choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_rte_098", p("Left Hand- After child grasps spoon or tries to eat cheerio directly from bowl, dry spoon with tissue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_rte_spnthl_success", p("Did child bring cheerio to mouth with left hand?"),
                              choiceNames = c(NA, "Didn't try", "Child used restrained hand", 
                                              "Cheerio fell", "After replacement", 
                                              "On first attempt"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_rte_009", h4("Notes about cheerio spoon hard task with left hand."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "rte_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("rte_score"))
        )
),


## Sit and Stand page ------

tabItem(tabName = "tab_sas",

        h2("Certification Checklist for Sit and Stand"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_sas_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_sas_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_sas_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_sas_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_sas_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("sas_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_001", p("Clean, non-skid mat that won’t move when child moves on it."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_002", p("Toys, large picture books or smart phone to keep child’s attention."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_003", p("Footprint mat (for older children- Feet Together & Feet Tandem."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        
        h3("Questions Before Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_004", p("If not observed earlier, examiner asks caregiver, “Have you seen [child's name] walk 3m unsupported?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_005", p("If child is older than 24 months and answer is “yes”, go to Feet Together & Tandem Stands"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_006", p("If child is younger than 24 months and answer is “yes”, no more testing DONE."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_007", p("If not observed earlier, examiner asks caregiver “Can child stand?”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_008", p("If answer to above is “yes”, go to Unsupported Stand: Feet Apart."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_009", p("If answer to above is “no” and not observed earlier, examiner asks caregiver, “Have you seen [child's name] sit unsupported for 10s.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_010", p("If answer to above is “yes”, go to Unsupported Sit."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6, 
                 radioButtons("radio_sas_011", p("If answer to above is “no”, go to Pull to Sit & Unsupported Sit."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_002", h4("Notes about questions before testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Pull to Sit")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_012", p("If answer to unsupported sit is “no”, go to Pull to Sit."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_013", p("Lays child down on back with feet pointed toward examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_014", p("Examiner reassures caregiver about testing head and neck control."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_015", p("Holds each of child’s hands in examiner’s hands with thumbs in child’s palms and fingers grasping child’s wrists."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_016", p("Takes approximately 4 seconds count to raise child fully, engaging child in the process with words and attention to face."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_017", p("If child cannot support head at all, examiner stops and lays child down."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_018", p("If child’s head tips backwards or child makes effort to keep head in line with body, examiner continues."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_019", p("After child completes Pull-to-Sit, examiner gently lies child back down on floor."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sas_pts_q1", p("Pull to Sit: head in line with torso?"),
                              choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_003", h4("Notes about pull to sit task"),
                               value = "")
          )
        ),

        fluidRow(
          column(6, h3("Unsupported Sit")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_020", p("If child successfully completes, examiner carefully positions child in sitting position facing away from examiner but facing caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sas_usit_q1", p("Unsupported Sit: Did child sit for 30 seconds?"),
                              choiceNames = c(NA, "No", "Yes"), choiceValues = app_values3_no0,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_021", p("Caregiver and examiner entertain child while counting down from 30 seconds."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_usit_q2_starttime", p("Find Longest Segment: When did the child start sitting?", br(),
                                                               "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_022", p("Examiner catches child if they begin to fall or lean, guiding them back to sitting until the 30 seconds elapses."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_usit_q2_endtime", p("Find Longest Segment: When did the child stop sitting?", br(),
                                                             "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_004", h4("Notes about unsupported sit."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Unsupported Stand: Feet Apart")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_023", p("examiner puts child into standing position while supporting chest and bottom."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_024", p("Examiner removes hands from child once child takes own weight."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sas_ftapt_q1", p("Feet Apart Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell", "Used hands for support", 
                                              "Sat without support", "Shifted to prone"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_025", p("As needed, examiner offers additional support to get child standing again without help."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_ftapt_q2_starttime", p("Find Timing: When did the child start standing?", br(),
                                                                "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_026", p("Child maintains position for 30 seconds."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_ftapt_q2_endtime", p("Find Timing: When did the child stop standing?", br(),
                                                              "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_005", h4("Notes about feet apart stand."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(6, h3("Unsupported Stand: Feet Together")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_027", p("If child is under 24 months and walks, have child put their feet on the Feet Together footprints."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sas_std_q1", p("Feet Together Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support", 
                                              "Sat without support", "Shifted to prone"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_028", p("Child should maintain position on Feet Together footprints for 30 seconds."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_std_q2_starttime", p("Feet Together Stand Find Timing: When did the child start standing?", br(),
                                                              "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_029", p("Examiner catches child if they begin to fall or lean, guiding them back to footprints until the 30 seconds elapses."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_std_q2_endtime", p("Feet Together Stand Find Timing: When did the child stop standing?", br(),
                                                            "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_006", h4("Notes about feet together stand."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6, h3("Unsupported Stand: Tandem Stand")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_030", p("After completing the Feet Together stance, have child put their feet on the Tandem footprints."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_sas_std_q3", p("Tandem Stand: Unsupported for 30 seconds?"),
                              choiceNames = c(NA, "Non-complaint", "Fell or grabbed", "Used hands for support", 
                                              "Sat without support", "Shifted to prone"), 
                              choiceValues = app_values6,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_031", p("Child should maintain position on Tandem footprints for 30 seconds."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_std_q4_starttime", p("Tandem Stand Find Timing: When did the child start standing?", br(),
                                                              "(Start Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_sas_032", p("Examiner catches child if they begin to fall or lean, guiding them back to footprints until the 30 seconds elapses."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 numericInput("radio_sas_std_q4_endtime", p("Tandem Stand Find Timing: When did the child stop standing?", br(),
                                                            "(End Time in Seconds: XX.XX)"),
                              value = "", min = 0, max = 1800, step = 0.01)
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_sas_007", h4("Notes about feet together stand."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "sas_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("sas_score"))
        )
),


## Mullen Receptive Language page ------

tabItem(tabName = "tab_mrl",
        
        h2("Certification Checklist for Mullen Receptive Language"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_mrl_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_mrl_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_mrl_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_mrl_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_mrl_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Upload Examiner File"),
        
        fluidRow(
          column(6,
                 fileInput("mrl_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),
        
        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_001", p("iPad is set up correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_003", p("Materials are all assembled: toy blocks and can; 2-3 familiar toys; toy car; red ball; colorful box with cover; stimulus book images; 2 drinking cups; toy table; plastic teddy bear."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mrl_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6, h3("Testing")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_004", p("Examiner slides purple button to the right to begin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_005", p("Examiner reviews instructions and slides purple button to right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_006", p("RL1: Age 1-4 months: Reacts reflexively to sounds: Examiner puts bocks in can and shakes it about 10 inches from child’s ears.  If child doesn’t startle immediately, try a second time."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          
          column(6,
                 radioButtons("radio_mrl_rl1", p("RL1: Reacts reflexively to sounds."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_007", p("If child doesn’t startle immediately, try a second time."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_008", p("RL3: Age 1-4 months: Responds to voice and face by smiling."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl3", p("RL3: Responds to voice and face by smiling."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_009", p("Examiner bends over child, smiles and then talks to child with exaggerated “baby talk”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_010", p("RL5: Age 1-10 months: Responds to voice and face by vocalizing. Examiner attracts child’s attention, then smiles at child and says “Boo” in playful voice."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl5", p("RL5: Responds to voice and face by vocalizing."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_011", p("RL6: Age 1-10 months: Coordinates listening and looking. Examiner stands to the side out of view (3-4 feet away).  When child isn’t looking, examiner says: “Hi baby, hi baby”.  Watch for child to turn head to look at E. "),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl6", p("RL6: Coordinates listening and looking."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_012", p("RL9: Age 1-14 months: Recognizes familiar words. Examiner asks caregiver for words that child typically responds to, such as bottle, mama, etc."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl9", p("RL9: Recognizes familiar words."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_013", p("Examiner says these words to C.  Examiner looks for child's facial movements or vocalizations."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_014", p("RL10: Age 1-22 months: Recognizes own name. Examiner hands child a toy; while child is attending to toy, examiner moves off to the side or behind child and calls the child by name."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl10", p("RL10: Recognizes own name."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_015", p("Examiner notes whether child turns toward examiner after hearing their name."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_016", p("RL13: Age 1-22 months: Understands gesture and commands. Examiner sits across table from child, with 2-3 familiar toys on table. Examiner encourages child to play with toys and when child is holding toy, examiner holds out hand and says “give it to me”; examiner repeats request if necessary."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl13", p("RL13 Understands gesture and command."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_017", p("Examiner answers Yes if child gives toy or starts to give toy and then keeps it."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_018", p("RL15: Age 1-32: Gives toy on verbal command. Examiner asks caregiver how child refers to them. Examiner gives child a toy and after a moment, says “give the (toy) to (caregiver by name)."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl15", p("RL15: Gives toy on verbal command."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_019", p("Examiner answers Yes if child gives caregiver the toy or holds is out to the caregiver."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_020", p("RL16: Age 1-32: Comprehension Questions. Examiner asks one or more questions from the list of questions."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl16", p("RL16: Comprehension questions."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_021", p("Examiner answers Yes if child looked, gestured, pointed, or nodded head to at least one of the objects in the questions."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_022", p("RL17: Age 1-32: Follows related commands. Examiner adapts instructions so child doesn’t need to get out of seat. Examiner has ball and colorful box on table."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl17", p("RL17: Follows related commands."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_023", p("Examiner asks child to grab the ball or to give the box. Examiner answers Yes if child responds correctly to either command."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_024", p("RL18: Age 1-34: Recognizes parts of body. Examiner turns iPad toward child; examiner asks child to show them: the dolly’s eyes, nose, mouth, ears, hands, feet, hair."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl18", p("RL18: Recognizes parts of body."),
                              choiceNames = c("NA", "None", "1-3", "4-5", "6-7"), 
                              choiceValues = app_values4,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_025", p("Examiner keeps track of child's responses until they are able to enter the answers on the iPad."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_026", p("RL20: Age 1-32: Follows directions. Examiner places car and block on table in front of C."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl20", p("RL20: Follows Directions."),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_027", p("Examiner says “give block to (caregiver). Examiner pauses and then says, “give the car to me.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_028", p("If child doesn’t give car to examiner, examiner says “give the car to (caregiver).”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_029", p("Examiner answers Yes if child gives the block to the caregiver and gives the car to either the caregiver or the E.",
                                                 br(),
                                                 "Examiner answers No, if child responds to only one request or ignore both requests."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_030", p("RL22: Age 1-34: Auditory spatial awareness. Examiner places 2 cups on table in front of C.  One cup is upside down and the other is right side up. Examiner puts block in the open cup and says “this block is in the cup.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_rl22", p("RL22: Auditory spatial awareness."),
                              choiceNames = c("NA", "None", "One", "Two", "Three",
                                              "Four or five"), choiceValues = app_values5,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_031", p("Examiner puts block on the upside down cup and says “this block is in the cup.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_032", p("Examiner reverses the positions of the cups and gives the block to the child, asking them to put the block in the cup”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_033", p("Examiner removes cups and block; examiner brings out toy table and bear. Using the table and bear, the examiner asks child to “put the bear under the table.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_034", p("Examiner continues, asking child to “put the bear behind the table”; “in front of the table”; and “beside the table”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_035", p("Examiner marks the correct actions on the iPad."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mrl_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "mrl_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("mrl_score"))
        )
),

## Mullen Visual Reception page ------

tabItem(tabName = "tab_mvr",

        h2("Certification Checklist for Mullen Visual Reception"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_mvr_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_mvr_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_mvr_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_mvr_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_mvr_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("mvr_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_001", p("iPad is set up correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_003", p("Materials are all assembled: spoon, ball, hairbrush, washcloths, cup, ring, cars, picture book."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mvr_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        fluidRow(
          column(6, h3("Testing")
          ),
          
          column(6, h3("How You Would Score the Task?")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_004", p("Examiner reviews instructions and slides purple button to right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_005", p("MVR3: Tracks moving bull’s eye: Attracts child's attention with iPad image of a bull’s eye, shaking iPad and moving it to right of midline and to left of midline; then moving iPad up and down from above forehead to below chin."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr3", p("MVR3: Did child track bull’s-eye smoothly with eye and head movements?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_006", p("MVR5: Stares at own hand; examiner observes whether child stares at their own hand while on their back."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr5", p("MVR5: Did child stare at their own hand?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_007", p("MVR6: Tracks bull’s eye near and far: examiner attracts child's attention, moving iPad into child's line of vision and then moving it 7-8” from child and then slowly to 3” from child and repeat going back to 7-8” and then to 15”."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr6", p("MVR6: Did child locate the bull’s-eye as it moved near and far from them?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_008", p("MVR7: Looks for dropped spoon. Examiner taps metal spoon on table until to get child's attention, then slides spoon to edge of table on child's side; examiner raises spoon ~6” above table and deliberately drops it on the floor to make a sound."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr7", p("MVR7: Did child turn and look over the side of table, searching for dropped spoon?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_009", p("MVR9: Looks for ring hidden under wash cloth: examiner attracts child's attention with colorful ring, When child is watching, examiner puts ring on table and covers it completely with washcloth."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr9", p("MVR9: At what stage did child uncover the ring?"),
                              choiceNames = c("NA", "Child did not uncover ring", 
                                              "Child finds ring when partially covered",
                                              "Child finds ring when fully hidden"), choiceValues = app_values3,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_010", p("Examiner encourages child to look for ring."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_011", p("If child does not look for ring, examiner administers item again with ring only partially covered."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_012", p("MVR10: Turns cup right-side up. Examiner shows cup to child and flips cup upside down in front of C. Examiner should tap upside down cup to attract attention. Examiner observes child's reaction to incorrect position of cup."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr10", p("MVR10: Did child turn cup right-side up?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_013", p("MVR11: Makes object associations: examiner places objects (hairbrush, spoon, cup, ball) one at a time on the table in front of C."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr11", p("MVR11: Examiner notes which objects child uses appropriately or imitates E’s use."),
                              choiceNames = c("NA", "None", "At least one object selected"), choiceValues = c(NA, 0, 1),  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_014", p("Examiner watches to see if child uses one of the objects spontaneously. If not, examiner demonstrates with one object at a time how they are used; after each demo, examiner asks child to demo."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_015", p("MVR12: Looks for car under washcloth. Examiner puts out two washcloths next to each other about 6” apart on table. With child looking, examiner puts a car under wash cloth on child's left. Examiner says, “Find it”. Repeat if no response in 15 seconds. Do same sequence on right; do not repeat."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr12", p("MVR12: Did child find car under washcloth on the right, even if they looked under the left washcloth?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          ) 
          
          
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_016", p("MVR13: Shows interest in book as hinge. Examiner demos opening and closing picture book. Examiner gives child book and encourages them to look at book and open/close it."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr13", p("MVR13: Did child open and close the book in 30 seconds?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_017", p("MVR14: Attends to picture. Examiner opens child's picture book and shows picture to child, pointing and naming picture."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr14", p("MVR14: Did child attend to picture by vocalizing, pointing or patting the picture?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_018", p("MVR15: Looks for toy covered, then displaced. Examiner places teddy bear in large nesting cup and covers cup with washcloth. Examiner then removes cup from under wash cloth and leaves bear under wash cloth without outline showing. Examiner shows child empty cup."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mvr_mvr15", p("MVR15: Did child find bear under the washcloth?"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = app_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mvr_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        h3("For the rest of the items: the child will respond by tapping the iPad",
           br(),
           "Before Beginning"),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_019", p("iPad is set up so that both examiner and child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_020", p("Child, caregiver, and examiner are seated correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_021", p("iPad sound is loud enough for child and examiner to hear."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_022", p("Examiner reviews instructions and slides purple button to right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mvr_023", p("FOR ALL ITEMS: Examiner makes sure child waits for instructions to finish before touching screen. Examiner touches NEXT to bring up the next item."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mvr_003", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "mvr_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("mvr_score"))
        )
),


## Touch Tutorial page ------

tabItem(tabName = "tab_touch",
        
        h2("Certification Checklist for Touch Tutorial"),
        h3("Certification Details"),
        
        fluidRow(
          column(6,
                 textInput("text_touch_person", h4("Person being certified:"),
                           value = "")
          ),
          
          column(6,
                 textInput("text_touch_site", h4("Site:"),
                           value = "")
          ),
          
          column(6,
                 dateInput("text_touch_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),
          
          
          column(6,
                 textInput("text_touch_certifier", h4("Certifier:"),
                           value = "")
          ),
          
          column(6,
                 numericInput("text_touch_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )
          
        ),
        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_001", p("iPad is set up correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_003", p("Volume is loud enough; Examiner reminds child not to touch screen before audio has stopped."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_touch_001", h4("Notes about setup."),
                               value = "")
          )
        ),
        
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_004", p("Examiner slides the purple button to the right to begin measure."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_005", p("Audio prompt tells child to “Touch the butterfly”. Child touches butterfly; if not, request is repeated.  If child still doesn’t touch the butterfly, examiner touches NEXT button to continue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_006", p("Audio prompt tells child to “Touch the flower”. Child touches flower; if not, request is repeated.  If child still doesn’t touch the flower, examiner touches the NEXT button to continue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_007", p("Audio prompt tells child to “Touch the flower”. Child touches flower; if not, request is repeated.  If child still doesn’t touch, examiner touches the NEXT button to continue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_008", p("Audio prompt tells child to “Touch the car”. Child touches car; if not, request is repeated.  If child still doesn’t touch the car, examiner touches the NEXT button to continue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_009", p("Audio prompt tells child to “Touch the bubble”. Child touches bubble; if not, request is repeated.  If child still doesn’t touch the bubble, examiner touches the NEXT button to continue."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_touch_002", h4("Notes about testing."),
                               value = "")
          )
        ),
        
        
        fluidRow(
          column(1,
                 actionButton(inputId = "touch_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),
        
        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("touch_score"))
        )
),


## EF Learning & Memory page ------

tabItem(tabName = "tab_elm",

        h2("Certification Checklist for Memory Task Learning, Visual Delayed Response, and Memory Task Test"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_elm_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_elm_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_elm_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_elm_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 numericInput("text_elm_childAge", h4("Child Age (in months):"),
                              value = "", min = 0, max = 60, step = 0.5)
          )

        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_001", p("iPad is set up correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_002", p("Seating is correct for child, caregiver, and examiner."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_elm_001", h4("Notes about setup."),
                               value = "")
          )
        ),

        h3("Testing"),
        
        h4("Learning"),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_003", p("Examiner begins the measure and introduces the child to the 3 practice items, encouraging the child to touch when necessary and pointing out the box around the correct response when child makes an error."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_elm_004", p("After the practice, the 11 encoding items with minimal feedback, examiner keeps encouraging the child to touch the iPad."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        h4("Visual Delayed Response"),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_005", p("When the learning measure is over, the examiner brings up the practice items from the Visual Delayed Response measure and helps child touch after the audio is over- with statements like “wait for the directions to finish and then touch.”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_elm_006", p("After the practice items, there are 8 test items that have the same format as the practice items. Examiner encourages the child to touch when appropriate and to wait for audio instructions to finish before touching."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_007", p("When warning screen comes up, examiner may have to distract the child for a short period of time to reach the required 6-8 minutes."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        h4("Memory"),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_008", p("Examiner begins measure and introduces task encouraging the child to touch the new animal each time a pair of animals is presented and to reminding child to wait for the audio instructions to finish before touching."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_009", p("Examiner knows how and when to pause or stop the test if necessary."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_elm_002", h4("Notes about testing."),
                               value = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "elm_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("elm_score"))
        )
)


  )
)
)


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output, session) {

  
## Executive Function (Gaze) data ----
## Numerical Change Detection data ------
## Spatial Change Detection data ------
## Looking While Listening data ------
## Mullen Expressive Language Observational data ------
## Mullen Expressive Language Prompted data ----
  
  melp_examiner_data <- reactive({
    req(input$melp_examiner_file)
    
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
    
    melp_exam_df <- data.frame(melp_exam_df)
  })
  
  
  melp_values <- eventReactive(input$melp_submit, {
    
    melp_data <- data.frame(
      text_melp_person = c(input$text_melp_person),
      text_melp_site = c(input$text_melp_site),
      text_melp_date = format(as.Date(input$text_melp_date, origin="2023-01-01")),
      text_melp_certifier = c(input$text_melp_certifier),
      text_melp_childAge = c(input$text_melp_childAge),
      
      "radio_melp_001" = c(input$radio_melp_001),
      "radio_melp_002" = c(input$radio_melp_002),
      "radio_melp_003" = c(input$radio_melp_003),
      "radio_melp_004" = c(input$radio_melp_004),
      "radio_melp_005" = c(input$radio_melp_005),
      "radio_melp_006" = c(input$radio_melp_006),
      "radio_melp_el7" = c(input$radio_melp_el7),
      "radio_melp_007" = c(input$radio_melp_007),
      "radio_melp_008" = c(input$radio_melp_008),
      "radio_melp_el10" = c(input$radio_melp_el10),
      "radio_melp_009" = c(input$radio_melp_009),
      "radio_melp_el11" = c(input$radio_melp_el11),
      "radio_melp_010" = c(input$radio_melp_010),
      "radio_melp_el15" = c(input$radio_melp_el15),
      "radio_melp_011" = c(input$radio_melp_011),
      "radio_melp_el16" = c(input$radio_melp_el16),
      
      "value_melp_001" = as.numeric(c(input$radio_melp_001)),
      "value_melp_002" = as.numeric(c(input$radio_melp_002)),
      "value_melp_003" = as.numeric(c(input$radio_melp_003)),
      "value_melp_004" = as.numeric(c(input$radio_melp_004)),
      "value_melp_005" = as.numeric(c(input$radio_melp_005)),
      "value_melp_006" = as.numeric(c(input$radio_melp_006)),
      "value_melp_el7" = as.numeric(c(input$radio_melp_el7)),
      "value_melp_007" = as.numeric(c(input$radio_melp_007)),
      "value_melp_008" = as.numeric(c(input$radio_melp_008)),
      "value_melp_el10" = as.numeric(c(input$radio_melp_el10)),
      "value_melp_009" = as.numeric(c(input$radio_melp_009)),
      "value_melp_el11" = as.numeric(c(input$radio_melp_el11)),
      "value_melp_010" = as.numeric(c(input$radio_melp_010)),
      "value_melp_el15" = as.numeric(c(input$radio_melp_el15)),
      "value_melp_011" = as.numeric(c(input$radio_melp_011)),
      "value_melp_el16" = as.numeric(c(input$radio_melp_el16)),
      
      "notes_melp_001" = as.numeric(c(input$text_melp_001)),
      "notes_melp_002" = as.numeric(c(input$text_melp_002)))
    
    
    melp_data$sum <- rowSums(melp_data %>% select(starts_with("value_melp_0")), na.rm = TRUE) * NA^!rowSums(!is.na(melp_data %>% select(starts_with("value_0"))))
    
    #melp_combined <- cbind(melp_data, melp_examiner_data)
    
    #return(melp_data)#combined)
    
  })
  
  output$test <- renderTable({
    melp_examiner_data()#melp_values()
  })
  
  # output$melp_score <- renderText({
  #
  #   melp_data <- melp_values()
  #
  #   percent_correct <- round((melp_data$sum / 11)*100, 2)
  #
  #   return(paste0(percent_correct, "%"))
  #
  # })
  
  
## Picture Vocab data ------
## Social Observational (younger) data ------
## Social Observational (older) data ------
## Who Has More data ------
## Subitizing data ------
## Object Counting data ------
## Verbal Arithmetic data ------
## Verbal Counting data ------
## Get Up and Go data ------
## Reach to Eat data ------
## Sit and Stand data ------
## Mullen Receptive Language data ------
## Mullen Visual Reception data ------
## Touch Tutorial data ------
## EF Learning & Memory data ------
  
  

  lwl_values <- eventReactive(input$lwl_submit, {

    lwl_data <- data.frame(
      "text_lwl_person" = c(input$text_lwl_person),
      "text_lwl_site" = c(input$text_lwl_site),
      "text_lwl_date" = format(as.Date(input$text_lwl_date, origin="2023-01-01")),
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




## The following is example code for testing if the API established with Azure works
## Currently not working (2/17/23), so code is commented out

# # a simple UI: display the user's OneDrive
# ui <- fluidPage(
#   verbatimTextOutput("drv")
# )
#
# ui_func <- function(req)
# {
#   opts <- parseQueryString(req$QUERY_STRING)
#   if(is.null(opts$code))
#   {
#     auth_uri <- build_authorization_uri(resource, tenant, app, redirect_uri=redirect, version=2)
#     redir_js <- sprintf("location.replace(\"%s\");", auth_uri)
#     tags$script(HTML(redir_js))
#   }
#   else ui
# }
#
# server <- function(input, output, session)
# {
#   opts <- parseQueryString(isolate(session$clientData$url_search))
#   if(is.null(opts$code))
#     return()
#   token <- get_azure_token(resource, tenant, app, password=pwd, auth_type="authorization_code",
#                            authorize_args=list(redirect_uri=redirect), version=2,
#                            use_cache=FALSE, auth_code=opts$code)
#   # display the contents of the user's OneDrive root folder
#   drv <- ms_graph$
#     new(token=token)$
#     get_user()$
#     get_drive()
#   output$drv <- renderPrint(drv$list_files())
# }
#
# shinyApp(ui_func, server)

