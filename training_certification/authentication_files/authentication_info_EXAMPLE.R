tenant <- "ADD DETAILS  HERE"
app_id <- "ADD DETAILS  HERE"
shiny_app_url <- "ADD DETAILS  HERE"
secret <- "ADD DETAILS  HERE"



save(tenant, app_id, shiny_app_url, secret, 
     file = "authentication_files/authentication_info.rdata")
