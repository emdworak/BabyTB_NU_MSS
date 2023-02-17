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



# Define the UI -----

radio_labels <- c("Yes", "No", "NA")
radio_values <- c(1, 0, 1)
el_values2 <- c(NA, 1, 0)
el_values3 <- c(NA, 0, 1, 2)
el_values4 <- c(NA, 0, 1, 2, 3)

# ui <- dashboardPage(
#   dashboardHeader(title = "BabyTB Training Certification"),
#   
#   dashboardSidebar(
#     width = 300,
#     tags$head(
#       tags$style("@import url(https://use.fontawesome.com/releases/v6.2.1/css/all.css);")
#       ),
#     
#     sidebarMenu(
#       menuItem("Dashboard", tabName = "dashboard", icon = icon("compass")),
#       menuItem("Gaze", tabName = "tab2", icon = icon("eye")),
#       menuItem("Looking While Listening", tabName = "tab_lwl", icon = icon("eye")),
#       menuItem("Mullen Expr. Lang. Observational", tabName = "tab_melo", icon = icon("comment")),
#       menuItem("Mullen Expr. Lang. Prompted", tabName = "tab_melp", icon = icon("comment")),
#       menuItem("Mullen Receptive Language", tabName = "tab6", icon = icon("comment")),
#       menuItem("Picture Vocab", tabName = "tab7", icon = icon("comment")),
#       menuItem("Social Observational (younger)", tabName = "tab8", icon = icon("cubes-stacked")),
#       menuItem("Social Observational (older)", tabName = "tab9", icon = icon("cubes-stacked")),
#       menuItem("Who Has More", tabName = "tab10", icon = icon("arrow-up-9-1")),
#       menuItem("Subitizing", tabName = "tab11", icon = icon("arrow-up-9-1")),
#       menuItem("Object Counting", tabName = "tab12", icon = icon("arrow-up-9-1")),
#       menuItem("Verbal Arithmetic", tabName = "tab13", icon = icon("arrow-up-9-1")),
#       menuItem("Verbal Counting", tabName = "tab14", icon = icon("arrow-up-9-1")),
#       menuItem("Get Up and Go", tabName = "tab15", icon = icon("person-running")),
#       menuItem("Reach to Eat", tabName = "tab16", icon = icon("cookie-bite")),
#       menuItem("Sit and Stand", tabName = "tab17", icon = icon("child-reaching")),
#       menuItem("Mullen Visual Reception", tabName = "tab18", icon = icon("eye")),
#       menuItem("EF Learning & Memory", tabName = "tab19", icon = icon("brain"))
#       
#       
#     )
#   ),
#   
#   dashboardBody(
#     tabItems(
#       # First tab content
#       tabItem(tabName = "dashboard",
#               
#               h2("Certification Information"),
#               
#               p("Welcome to the NIH BabyTB training certification page."),
#               
#               p("More details will be added ")
#               
#       ),
#       
#       tabItem(tabName = "tab19",
# 
#               fluidRow(
#                 column(1,
#                        actionButton(inputId = "test_submit", label = "Submit",
#                                     icon = NULL, width = NULL))
#               )#,
# 
#       #         h4("This will be removed, but it's here to show that the data upload worked"),
#       #         fluidRow(
#       #           column(12,
#       #                  textOutput(output$test)   
#       #         )
# 
#       ),
#       
#       # Second tab content
#       tabItem(tabName = "tab_lwl",
#               
#               h2("Certification Checklist for Looking While Listening  "),
#               h3("Certification Details"),
#               
#               fluidRow(
#                 column(6,
#                        textInput("text_lwl_person", h4("Person being certified:"), 
#                                  value = "")
#                 ),
#                 
#                 column(6,
#                        textInput("text_lwl_site", h4("Site:"), 
#                                  value = "")
#                 ),
#                 
#                 column(6,
#                        dateInput("text_lwl_date",
#                                  label = "Date (yyyy-mm-dd)",
#                                  value = Sys.Date()
#                        )
#                 ),
#                 
#                 
#                 column(6,
#                        textInput("text_lwl_certifier", h4("Certifier:"), 
#                                  value = "")
#                 ),
#                 
#                 column(6,
#                        textInput("text_lwl_childAge", h4("Child Age (in months):"), 
#                                  value = "")
#                 )
#                 
#               ),
#               
#               h3("Before Beginning"),
#               
#               fluidRow(
#                 column(6,
#                        radioButtons("radio_lwl_001", p("Child (C), caregiver & examiner (E) are seated correctly"),
#                                     choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#                        )
#                 ),
#               
#               
#             fluidRow(
#                 column(6,
#                        radioButtons("radio_lwl_002", p("iPad is set up so that C is in the correct placement for gaze."),
#                                     choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#                        )
#                 ),
#             
#                 fluidRow(
#                   column(6,
#                          textAreaInput("text_lwl_001", h4("Notes about setup"), 
#                                    value = ""))
#       ),
#       
#       h3("Testing"),
#       
#       fluidRow(
#         column(6,
#                radioButtons("radio_lwl_003", p("iPad sound is loud enough for C & E to hear"),
#                             choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#         )
#       ),
#       
#       fluidRow(
#         column(6,
#                radioButtons("radio_lwl_004", p("E slides purple button to the right"),
#                             choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#         )
#       ),
#       
#       
#       fluidRow(
#         column(6,
#                radioButtons("radio_lwl_005", p("E reviews instructional screen & slides purple button to the right"),
#                             choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#         )
#       ),
#       
#       
#       
#       fluidRow(
#         column(6,
#                radioButtons("radio_lwl_006", p("E stands behind the C unless they need to redirect the C’s attention to the iPad without touching the iPad itself or blocking the iPad camera"),
#                             choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#         )
#       ),
#       
#       
#       
#       fluidRow(
#         column(6,
#                radioButtons("radio_lwl_007", p("After calibration, the iPad begins to present items one at a time. E stands behind the C unless they need to redirect C’s attention without touching the iPad or blocking the camera"),
#                             choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#         )
#       ),
#       
#       fluidRow(
#         column(6,
#                radioButtons("radio_lwl_008", p("Test continues until all items are presented"),
#                             choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#         )
#         ),
#         
#       fluidRow(
#         column(6,
#                textAreaInput("text_lwl_002", h4("Notes about testing"), 
#                          value = "")
#         )
#       ),
#       
#       fluidRow(
#         column(1,
#                actionButton(inputId = "lwl_submit", label = "Submit", 
#                             icon = NULL, width = NULL))
#       ),
#       
#       h2("Your Score"), 
#       fluidRow(
#         column(12,
#                verbatimTextOutput("lwl_score"))
#       )
#     ),
#     
#     tabItem(tabName = "tab_melp",
#             
#             h2("Mullen Expressive Language Prompted"),
#             h3("Certification Details"),
#             
#             fluidRow(
#               column(6,
#                      textInput("text_melp_person", h4("Person being certified:"), 
#                                value = "")
#               ),
#               
#               column(6,
#                      textInput("text_melp_site", h4("Site:"), 
#                                value = "")
#               ),
#               
#               column(6,
#                      dateInput("text_melp_date",
#                                label = "Date (yyyy-mm-dd)",
#                                value = Sys.Date()
#                      )
#               ),
#               
#               
#               column(6,
#                      textInput("text_melp_certifier", h4("Certifier:"), 
#                                value = "")
#               ),
#               
#               column(6,
#                      textInput("text_melp_childAge", h4("Child Age (in months):"), 
#                                value = "")
#               )
#               
#             ),
#             
#             h3("Upload Examiner File"),
#             
#             fluidRow(
#               column(6,
#                      fileInput("melp_examiner_file", "Please upload the narrow structured item export from the examiner's administration. This file should be a CSV file",
#                         multiple = FALSE,
#                         accept = c("text/csv",
#                                    "text/comma-separated-values,text/plain",
#                                    ".csv"))
#                      ),
#             ),
#             
#             h3("Before Beginning"),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_001", p("iPad is set up correctly"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_002", p("Seating is correct for Child (C), caregiver & Examiner (E)"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = ""))
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_003", p("Materials are all assembled: red ball, picture book, toy car, key, plastic knife"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#                 )
#               ),
#             
#             fluidRow(
#               column(6,
#                      textAreaInput("text_melp_001", h4("Notes about setup"), 
#                                value = "")
#               )
#             ),
#             
#             h3("Testing"),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_004", p("E slides purple button to the right to begin"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               )
#             ),
#             
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_005", p("E reviews instructions & slides purple button to right"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               )
#             ),
#             
#             
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_006", p("Age 1-23 months: EL7: Voluntary Babbling: Attracts C’s attention with repeated sounds"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               ),
#               
#               
#               column(6,
#                      radioButtons("radio_melp_el7", p("EL7: Voluntary Babbling"),
#                                   choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_007", p("Age 1-23 months: EL10: Plays Gestures / Language Game; asks caregiver which gesture/language game C enjoys (pat-a-cake, peek-a-boo)"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_008", p("E plays game with C; observes C’s enjoyment"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               ),
#               
#               column(6,
#                      radioButtons("radio_melp_el10", p("EL10: Plays Gestures/Language Game"),
#                                   choiceNames = c("NA", "Yes", "No"), choiceValues = el_values2,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_009", p("Age 1-23 months: EL11: Says first words; ask caregiver which words C says and try to elicit words."),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               ),
#               
#               column(6,
#                      radioButtons("radio_melp_el11", p("EL11: Says first words"),
#                                   choiceNames = c("NA", "Zero", "One", 
#                                                   "Two to seven", "Eight or more"), 
#                                   choiceValues = el_values4,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_010", p("All ages: EL15: Names objects: E lays out objects on table in front of C but not reachable by C; points to each item & asks “what is this?” or “what do we call this?”"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               ),
#               
#               column(6,
#                      radioButtons("radio_melp_el15", p("EL15: Names objects"),
#                                   choiceNames = c("NA", "No endorsed buttons", "1-3 endorsed buttons", 
#                                                   "4 or 5 endorsed buttons", "6 endorsed buttons"), 
#                                   choiceValues = el_values4,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      radioButtons("radio_melp_011", p("All ages: EL16: Labels pictures: E shows C 3 images and points to each, asking “what is this?” or “what do we call this?”"),
#                                   choiceNames = radio_labels, choiceValues = radio_values,  selected = "")
#               ),
#               
#               column(6,
#                      radioButtons("radio_melp_el16", p("EL16: Labels Pictures"),
#                                   choiceNames = c("NA", "Does not label labels at least one picture ", 
#                                                   "Labels at least one picture"), 
#                                   choiceValues = el_values2,  selected = "")
#               )
#             ),
#             
#             fluidRow(
#               column(6,
#                      textAreaInput("text_melp_002", h4("Notes about testing"), 
#                                    value = "")
#               )
#             ),
# 
#             
#             fluidRow(
#               column(1,
#                      actionButton(inputId = "melp_submit", label = "Submit", 
#                                   icon = NULL, width = NULL))
#             ),
#             
#             h2("Your Score"), 
#             fluidRow(
#               column(12,
#                      verbatimTextOutput("melp_score")),
#             ),
#             
#             h4("This will be removed, but it's here to show that the data upload worked"),
#             fluidRow(
#               column(12,
#                      tableOutput("test"))
#             )
#     )
#   )
# )
# )
# 
# 
# # Need an overall feedback area that may help flag folks that aren't qualified
# 
# # Define server logic to plot various variables against mpg ----
# server <- function(input, output, session) {
#   
#   opts <- parseQueryString(isolate(session$clientData$url_search))
#   if(is.null(opts$code))
#     return()
#   
#   token <- get_azure_token(resource, tenant, app, password=pwd, auth_type="authorization_code",
#                            authorize_args=list(redirect_uri=redirect), version=2,
#                            use_cache=FALSE, auth_code=opts$code)
#   
#   pull_one_drive <- ms_graph$
#     new(token=token)$
#     get_user()$
#     get_drive()
#   
#   
#   output$test <- eventReactive(input$test_submit, {
#     renderPrint(pull_one_drive$list_items())
#     })
#   
#   
#   melp_examiner_data <- reactive({
#     req(input$melp_examiner_file)
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
#       "radio_melp_el16" = c(input$radio_melp_el16))#,
# 
#     #   "value_melp_001" = as.numeric(c(input$radio_melp_001)),
#     #   "value_melp_002" = as.numeric(c(input$radio_melp_002)),
#     #   "value_melp_003" = as.numeric(c(input$radio_melp_003)),
#     #   "value_melp_004" = as.numeric(c(input$radio_melp_004)),
#     #   "value_melp_005" = as.numeric(c(input$radio_melp_005)),
#     #   "value_melp_006" = as.numeric(c(input$radio_melp_006)),
#     #   "value_melp_el7" = as.numeric(c(input$radio_melp_el7)),
#     #   "value_melp_007" = as.numeric(c(input$radio_melp_007)),
#     #   "value_melp_008" = as.numeric(c(input$radio_melp_008)),
#     #   "value_melp_el10" = as.numeric(c(input$radio_melp_el10)),
#     #   "value_melp_009" = as.numeric(c(input$radio_melp_009)),
#     #   "value_melp_el11" = as.numeric(c(input$radio_melp_el11)),
#     #   "value_melp_010" = as.numeric(c(input$radio_melp_010)),
#     #   "value_melp_el15" = as.numeric(c(input$radio_melp_el15)),
#     #   "value_melp_011" = as.numeric(c(input$radio_melp_011)),
#     #   "value_melp_el16" = as.numeric(c(input$radio_melp_el16)),
#     # 
#     #   "notes_melp_001" = as.numeric(c(input$text_melp_001)),
#     #   "notes_melp_002" = as.numeric(c(input$text_melp_002)))
#     # 
#     # 
#     # melp_data$sum <- rowSums(melp_data %>% select(starts_with("value_melp_0")), na.rm = TRUE) * NA^!rowSums(!is.na(melp_data %>% select(starts_with("value_0"))))
# 
#   #melp_combined <- cbind(melp_data, melp_examiner_data)
#   
#   #return(melp_data)#combined)
# 
# })
#   
#   output$test <- renderTable({
#     melp_values()
#   })
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
#       )
#     
#     lwl_data$sum <- rowSums(lwl_data %>% select(starts_with("value_")), na.rm = TRUE) * NA^!rowSums(!is.na(lwl_data %>% select(starts_with("value_"))))
#     
#     percent_correct <- round((lwl_data$sum / 8)*100, 2)
#     
#     paste0(percent_correct, "%")
#   
#     })
#   
#   output$lwl_score <- renderText({
#     lwl_values()
#   })
#   
# 
# }

# shinyApp(ui, server)


## The following is example code for testing if the API established with Azure works
## Currently not working, so code is commented out 

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

