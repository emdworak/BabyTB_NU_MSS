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
el_values2_noNA <- c(1, 0)
el_values2 <- c(NA, 1, 0)
el_values3 <- c(NA, 0, 1, 2)
el_values4 <- c(NA, 0, 1, 2, 3)

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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
               menuSubItem("Mullen Receptive Language", tabName = "tab_mrl", icon = icon("comment")),
               menuSubItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Reach to Eat", tabName = "tab_rte", icon = icon("cookie-bite")),
               menuSubItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment"))
               ),
      
      menuItem("Child 6-8 Month Battery", tabName = "child_6_8", icon = icon("baby"),
               menuSubItem("Mullen Visual Reception", tabName = "tab_mvr", icon = icon("eye")),
               menuSubItem("Sit and Stand", tabName = "tab_sas", icon = icon("child-reaching")),
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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
               menuSubItem("Get Up and Go", tabName = "tab_guag", icon = icon("person-running")),
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

              p("Welcome to the NIH BabyTB training certification page."),

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
                       textInput("text_efg_childAge", h4("Child Age (in months):"),
                                 value = "")
                )
                
              ),
              
              h3("Set-Up"),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver"),
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
                       radioButtons("radio_efg_004", p("If highchair, caregiver is sitting behind child in chair"),
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
                       textAreaInput("text_efg_001", h4("Notes about setup"),
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
                       textAreaInput("text_efg_002", h4("Notes about head placement"),
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
                       radioButtons("radio_efg_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above) ."),
                                    choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),
              
              fluidRow(
                column(6,
                       radioButtons("radio_efg_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly & go to calibration again (see above)."),
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
                       textAreaInput("text_efg_004", h4("Notes about testing"),
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
                 textInput("text_ncd_childAge", h4("Child Age (in months):"),
                           value = "")
          )
          
        ),
        
        h3("Set-Up"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver"),
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
                 radioButtons("radio_ncd_004", p("If highchair, caregiver is sitting behind child in chair"),
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
                 textAreaInput("text_ncd_001", h4("Notes about setup"),
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
                 textAreaInput("text_ncd_002", h4("Notes about head placement"),
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
                 radioButtons("radio_ncd_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above) ."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_ncd_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly & go to calibration again (see above)."),
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
                 textAreaInput("text_ncd_004", h4("Notes about testing"),
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
                 textInput("text_scd_childAge", h4("Child Age (in months):"),
                           value = "")
          )
          
        ),
        
        h3("Set-Up"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver"),
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
                 radioButtons("radio_scd_004", p("If highchair, caregiver is sitting behind child in chair"),
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
                 textAreaInput("text_scd_001", h4("Notes about setup"),
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
                 textAreaInput("text_scd_002", h4("Notes about head placement"),
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
                 radioButtons("radio_scd_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above) ."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_scd_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly & go to calibration again (see above)."),
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
                 textAreaInput("text_scd_004", h4("Notes about testing"),
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


## LWL page ------
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
                 textInput("text_lwl_childAge", h4("Child Age (in months):"),
                           value = "")
          )
          
        ),
        
        h3("Set-Up"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_001", p("Examiner has iPad, iPad stand, highchair, table, chair for caregiver"),
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
                 radioButtons("radio_lwl_004", p("If highchair, caregiver is sitting behind child in chair"),
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
                 textAreaInput("text_lwl_001", h4("Notes about setup"),
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
                 textAreaInput("text_lwl_002", h4("Notes about head placement"),
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
                 radioButtons("radio_lwl_020", p("If iPad does not register look in at least 1 corner, returns to head placement (see above) ."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_lwl_021", p("If app loses child's gaze when child turned, app will find child's gaze quickly & go to calibration again (see above)."),
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
                 textAreaInput("text_lwl_004", h4("Notes about testing"),
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
                 textInput("text_melo_childAge", h4("Child Age (in months):"),
                           value = "")
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
                              choiceNames = c("Vocalizes", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el3", p("EL3: Smiles and Makes Happy Sounds"),
                              choiceNames = c("Smiles and Makes Happy Sounds", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el4", p("EL4: Coos, Chuckles, or Laughs (makes 2 of 3 sounds)"),
                              choiceNames = c("Coos, Chuckles, or Laughs", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el5", p("EL5: Makes Vocalizations (uses 2 or more sounds, like ah, eh, m);  Examiner can ask caregiver."),
                              choiceNames = c("Make Vocalizations", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el6", p("EL6: Plays with Sounds (such as o, u, a-a-a, ah-goo);  Examiner can ask caregiver."),
                              choiceNames = c("Plays with Sounds", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el8", p("EL8: Produces 3 Consonant Sounds (such as p, d, k, g, m)."),
                              choiceNames = c("Produces 3 Consonant Sounds", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el12", p("EL12: Jabbers with Inflection (changes in inflection; different tones or pitch)."),
                              choiceNames = c("Jabbers with Inflection", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el13", p("EL13: Combines Jargon/Gestures (jargon + gestures, touching or looking)."),
                              choiceNames = c("Combines Jargon/Gestures", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el14", p("EL14: Combines Words/Gestures (word approximations with pointing or gesturing); Examiner can ask caregiver."),
                              choiceNames = c("Combines Words/Gestures", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el17", p("EL17: Uses 2-Word Phrases."),
                              choiceNames = c("Uses 2-Word Phrases", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el19", p("EL19: Uses Pronouns (such as “my”, “mine”, “you” or “me”)."),
                              choiceNames = c("Uses Pronouns", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_melo_el22", p("EL22: Uses 3 to 4 Word Sentences."),
                              choiceNames = c("Uses 3 to 4 Word Sentences", "Unselected"), choiceValues = el_values2_noNA,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_melo_001", h4("Notes about testing"),
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
                 verbatimTextOutput("melo_score")),
        ),
        
        h4("This will be removed, but it's here to show that the data upload worked"),
        fluidRow(
          column(12,
                 tableOutput("test"))
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
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
                )
              ),

            fluidRow(
              column(6,
                     textAreaInput("text_melp_001", h4("Notes about setup"),
                               value = "")
              )
            ),

            h3("Testing"),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_004", p("E slides purple button to the right to begin"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),


            fluidRow(
              column(6,
                     radioButtons("radio_melp_005", p("E reviews instructions & slides purple button to right"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),



            fluidRow(
              column(6,
                     radioButtons("radio_melp_006", p("Age 1-23 months: EL7: Voluntary Babbling: Attracts C’s attention with repeated sounds"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),


              column(6,
                     radioButtons("radio_melp_el7", p("EL7: Voluntary Babbling"),
                                  choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_007", p("Age 1-23 months: EL10: Plays Gestures / Language Game; asks caregiver which gesture/language game C enjoys (pat-a-cake, peek-a-boo)"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_008", p("E plays game with C; observes C’s enjoyment"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el10", p("EL10: Plays Gestures/Language Game"),
                                  choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_009", p("Age 1-23 months: EL11: Says first words; ask caregiver which words C says and try to elicit words."),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el11", p("EL11: Says first words"),
                                  choiceNames = c("NA", "Zero", "One",
                                                  "Two to seven", "Eight or more"),
                                  choiceValues = el_values4,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_010", p("All ages: EL15: Names objects: E lays out objects on table in front of C but not reachable by C; points to each item & asks “what is this?” or “what do we call this?”"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el15", p("EL15: Names objects"),
                                  choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                                  "4 or 5 endorsed buttons", "6 endorsed buttons"),
                                  choiceValues = el_values4,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     radioButtons("radio_melp_011", p("All ages: EL16: Labels pictures: E shows C 3 images and points to each, asking “what is this?” or “what do we call this?”"),
                                  choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
              ),

              column(6,
                     radioButtons("radio_melp_el16", p("EL16: Labels Pictures"),
                                  choiceNames = c("NA", "Does not label labels at least one picture ",
                                                  "Labels at least one picture"),
                                  choiceValues = el_values2,  selected = "")
              )
            ),

            fluidRow(
              column(6,
                     textAreaInput("text_melp_002", h4("Notes about testing"),
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
                     verbatimTextOutput("melp_score")),
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
                 textInput("text_pv_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),


        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_001", p("iPad is set up so that both examiner & child can see screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_002", p("Child, caregiver & examiner are seated correctly."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),


        fluidRow(
          column(6,
                 textAreaInput("text_pv_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_003", p("iPad sound is loud enough for child & examiner to hear "),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_pv_004", p("Examiner slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_pv_005", p("After App audio reads the instructions, NEXT button is active and examiner taps it"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_pv_006", p("Practice item 1 is presented; child has 3 attempts. If child does not succeed in 3 tries, examiner should touch picture of Banana, saying: “this is a banana”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_007", p("Practice item 2 is presented, child has 3 attempts. If child does not succeed in 3 tries, examiner should touch picture of Banana, saying: “this is a spoon”"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_008", p("App audio reads a second set of instructions. After confirming child is ready to begin, examiner slides purple button to the right."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_009", p("The items appear one at a time for about  5 minutes.  Examiner does nothing during this time unless child has trouble touching the screen.  In this case, child points to response choice & examiner touches the screen."),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_pv_010", p("If child repeats a word several times, examiner may say the word once & encourage child to choose a picture."),
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
                 textAreaInput("text_pv_002", h4("Notes about testing"),
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
                 verbatimTextOutput("pv_score")),
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
                 textInput("text_sobY_childAge", h4("Child Age (in months):"),
                           value = "")
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
                 radioButtons("radio_sobY_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sobY_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_sobY_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_sobY_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_sobY_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobY_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobY_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobY_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobY_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobY_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sobY_002", h4("Notes about testing"),
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
                 verbatimTextOutput("sobY_score")),
        )
),

## Social Observational (older) page ------

tabItem(tabName = "tab_sobO",

        h2("Certification Checklist for Social Observational (ages 24 months and older)"
           ),
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
                 textInput("text_sobO_childAge", h4("Child Age (in months):"),
                           value = "")
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
                 radioButtons("radio_sobO_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sobO_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_sobO_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_sobO_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_sobO_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobO_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobO_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobO_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sobO_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sobO_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sobO_002", h4("Notes about testing"),
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
                 verbatimTextOutput("sobO_score")),
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
                 textInput("text_whm_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("whm_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_whm_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_whm_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_whm_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_whm_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_whm_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_whm_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_whm_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_whm_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_whm_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_whm_002", h4("Notes about testing"),
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
                 verbatimTextOutput("whm_score")),
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
                 textInput("text_sub_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("sub_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sub_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_sub_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_sub_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_sub_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sub_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sub_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sub_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sub_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sub_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sub_002", h4("Notes about testing"),
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
                 verbatimTextOutput("sub_score")),
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
                 textInput("text_oc_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("oc_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_oc_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_oc_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_oc_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_oc_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_oc_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_oc_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_oc_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_oc_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_oc_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_oc_002", h4("Notes about testing"),
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
                 verbatimTextOutput("oc_score")),
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
                 textInput("text_va_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("va_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_va_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_va_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_va_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_va_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_va_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_va_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_va_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_va_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_va_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_va_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_va_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_va_002", h4("Notes about testing"),
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
                 verbatimTextOutput("va_score")),
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
                 textInput("text_vc_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("vc_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_vc_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_vc_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_vc_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_vc_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_vc_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_vc_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_vc_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_vc_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_vc_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_vc_002", h4("Notes about testing"),
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
                 verbatimTextOutput("vc_score")),
        )
),

## Get Up and Go page ------

tabItem(tabName = "tab_guag",

        h2("Certification Checklist for Get Up and Go"),
        h3("Certification Details"),

        fluidRow(
          column(6,
                 textInput("text_guag_person", h4("Person being certified:"),
                           value = "")
          ),

          column(6,
                 textInput("text_guag_site", h4("Site:"),
                           value = "")
          ),

          column(6,
                 dateInput("text_guag_date",
                           label = "Date (yyyy-mm-dd)",
                           value = Sys.Date()
                 )
          ),


          column(6,
                 textInput("text_guag_certifier", h4("Certifier:"),
                           value = "")
          ),

          column(6,
                 textInput("text_guag_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("guag_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_guag_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_guag_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_guag_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_guag_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_guag_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_guag_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_guag_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_guag_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_guag_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_guag_002", h4("Notes about testing"),
                               value = "")
          )
        ),


        fluidRow(
          column(1,
                 actionButton(inputId = "guag_submit", label = "Submit",
                              icon = NULL, width = NULL))
        ),

        h2("Your Score"),
        fluidRow(
          column(12,
                 verbatimTextOutput("guag_score")),
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
                 textInput("text_rte_childAge", h4("Child Age (in months):"),
                           value = "")
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
                 radioButtons("radio_rte_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
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
                 radioButtons("radio_rte_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_rte_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_rte_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_rte_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_rte_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_rte_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_rte_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_rte_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_rte_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_rte_002", h4("Notes about testing"),
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
                 verbatimTextOutput("rte_score")),
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
                 textInput("text_sas_childAge", h4("Child Age (in months):"),
                           value = "")
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
                 radioButtons("radio_sas_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sas_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_sas_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_sas_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_sas_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sas_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sas_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sas_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_sas_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_sas_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_sas_002", h4("Notes about testing"),
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
                 verbatimTextOutput("sas_score")),
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
                 textInput("text_mrl_childAge", h4("Child Age (in months):"),
                           value = "")
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
                 radioButtons("radio_mrl_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mrl_001", h4("Notes about setup"),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          
          column(6,
                 radioButtons("radio_mrl_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_mrl_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_mrl_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_mrl_002", h4("Notes about testing"),
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
                 verbatimTextOutput("mrl_score")),
        ),
        
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
                 textInput("text_mvr_childAge", h4("Child Age (in months):"),
                           value = "")
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
                 radioButtons("radio_mvr_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_mvr_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_mvr_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_mvr_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_mvr_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_mvr_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_mvr_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_mvr_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_mvr_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_mvr_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_mvr_002", h4("Notes about testing"),
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
                 verbatimTextOutput("mvr_score")),
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
                 textInput("text_touch_childAge", h4("Child Age (in months):"),
                           value = "")
          )
          
        ),
        
        h3("Upload Examiner File"),
        
        fluidRow(
          column(6,
                 fileInput("touch_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),
        
        h3("Before Beginning"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_touch_001", h4("Notes about setup"),
                               value = "")
          )
        ),
        
        h3("Testing"),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          
          column(6,
                 radioButtons("radio_touch_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_touch_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_touch_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_touch_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 radioButtons("radio_touch_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),
          
          column(6,
                 radioButtons("radio_touch_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),
        
        fluidRow(
          column(6,
                 textAreaInput("text_touch_002", h4("Notes about testing"),
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
                 verbatimTextOutput("touch_score")),
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
                 textInput("text_elm_childAge", h4("Child Age (in months):"),
                           value = "")
          )

        ),

        h3("Upload Examiner File"),

        fluidRow(
          column(6,
                 fileInput("elm_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
                           multiple = FALSE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv"))
          ),
        ),

        h3("Before Beginning"),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_001", p("iPad is set up correctly"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_elm_001", h4("Notes about setup"),
                               value = "")
          )
        ),

        h3("Testing"),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_004", p("E slides purple button to the right to begin"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),


        fluidRow(
          column(6,
                 radioButtons("radio_elm_005", p("E reviews instructions & slides purple button to right"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),



        fluidRow(
          column(6,
                 radioButtons("radio_elm_006", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),


          column(6,
                 radioButtons("radio_elm_el7", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_007", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_008", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_elm_el10", p("ADD QUESTION"),
                              choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_009", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_elm_el11", p("ADD QUESTION"),
                              choiceNames = c("NA", "Zero", "One",
                                              "Two to seven", "Eight or more"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_010", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_elm_el15", p("ADD QUESTION"),
                              choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons",
                                              "4 or 5 endorsed buttons", "6 endorsed buttons"),
                              choiceValues = el_values4,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 radioButtons("radio_elm_011", p("ADD QUESTION"),
                              choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
          ),

          column(6,
                 radioButtons("radio_elm_el16", p("ADD QUESTION"),
                              choiceNames = c("NA", "Does not label labels at least one picture ",
                                              "Labels at least one picture"),
                              choiceValues = el_values2,  selected = "")
          )
        ),

        fluidRow(
          column(6,
                 textAreaInput("text_elm_002", h4("Notes about testing"),
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
                 verbatimTextOutput("elm_score")),
        )
)


  )
)
)


# Need an overall feedback area that may help flag folks that aren't qualified

# Define server logic to plot various variables against mpg ----
server <- function(input, output, session) {

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
      "radio_melp_el16" = c(input$radio_melp_el16))#,

    #   "value_melp_001" = as.numeric(c(input$radio_melp_001)),
    #   "value_melp_002" = as.numeric(c(input$radio_melp_002)),
    #   "value_melp_003" = as.numeric(c(input$radio_melp_003)),
    #   "value_melp_004" = as.numeric(c(input$radio_melp_004)),
    #   "value_melp_005" = as.numeric(c(input$radio_melp_005)),
    #   "value_melp_006" = as.numeric(c(input$radio_melp_006)),
    #   "value_melp_el7" = as.numeric(c(input$radio_melp_el7)),
    #   "value_melp_007" = as.numeric(c(input$radio_melp_007)),
    #   "value_melp_008" = as.numeric(c(input$radio_melp_008)),
    #   "value_melp_el10" = as.numeric(c(input$radio_melp_el10)),
    #   "value_melp_009" = as.numeric(c(input$radio_melp_009)),
    #   "value_melp_el11" = as.numeric(c(input$radio_melp_el11)),
    #   "value_melp_010" = as.numeric(c(input$radio_melp_010)),
    #   "value_melp_el15" = as.numeric(c(input$radio_melp_el15)),
    #   "value_melp_011" = as.numeric(c(input$radio_melp_011)),
    #   "value_melp_el16" = as.numeric(c(input$radio_melp_el16)),
    #
    #   "notes_melp_001" = as.numeric(c(input$text_melp_001)),
    #   "notes_melp_002" = as.numeric(c(input$text_melp_002)))
    #
    #
    # melp_data$sum <- rowSums(melp_data %>% select(starts_with("value_melp_0")), na.rm = TRUE) * NA^!rowSums(!is.na(melp_data %>% select(starts_with("value_0"))))

  #melp_combined <- cbind(melp_data, melp_examiner_data)

  #return(melp_data)#combined)

})

  output$test <- renderTable({
    melp_values()
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

