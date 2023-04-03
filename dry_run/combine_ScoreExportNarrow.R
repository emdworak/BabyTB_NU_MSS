# install.packages("psych", repos = "http://personality-project.org/r", type = "source")
# install.packages("psychTools", repos = "http://personality-project.org/r", type = "source")

# Load the relevant libraries --------------------------
library(psych)
library(psychTools)
library(tidyverse)
library(readxl)

# Make sure you're running the most recent version of psych
sessionInfo()

# Load the functions and data --------------------------
`%nin%` <- Negate(`%in%`)

# These are the IDs we care about for analysis
ids_for_analysis <- read_csv("dry_run/data/2023-03-22T172307_shouldHavecorrected2.csv") %>% 
  rename(PIN = PINsago)

dim(ids_for_analysis)

# Load in a file to fix duplicates 
# pin_check <- read.csv("dry_run/data/2023-03-22T130920_scrsFileInstrumentStatusC2.csv") %>% 
#   select(PIN, PID, RegistrationID) %>% 
#   unique()

pin_check <- read_xlsx("dry_run/data/20230323_corrected_pins.xlsx")

## Find the file path
# temp <- file.choose()

## In order to run this code, you need to be connected to the R drive and have permission to access the BabyTB folder
folder <- paste0("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/NBT_Norming_2023/misc/")
files <- list.files(folder, pattern = "^ScoresExportNarrowStructure")

length(files) # There should be 175 cases

combine_ScoreExportNarrow <- list()
  


for(i in 1:length(files)){
  folder_path <- str_c(folder, files[i])
  
  item_info <- read.csv(folder_path)
  
  item_info <- data.frame(item_info, "import_value" = i)
  
  combine_ScoreExportNarrow[[i]] <- item_info
}

dryRun_ScoreExportNarrow <- bind_rows(combine_ScoreExportNarrow)
dim(dryRun_ScoreExportNarrow)
colnames(dryRun_ScoreExportNarrow)

## QA the data -----
dryRun_ScoreExportNarrow %>% 
  count(import_value) %>% 
  arrange(desc(n))

dryRun_ScoreExportNarrow %>% 
  count(PID) %>% 
  arrange(desc(n))

dryRun_ScoreExportNarrow %>% 
  count(PID, import_value) %>% 
  arrange(import_value) ## Something is wrong with i = 31

temp_path <- str_c(folder, files[31])

temp_info <- read.csv(temp_path)

temp_info %>% 
  count(PID) ## Why does this switch in the middle of testing?

## One possible reason is that more than one 
dryRun_ScoreExportNarrow %>% 
  count(PID, import_value) %>% 
  arrange(PID) %>% 
  count(PID)

dryRun_ScoreExportNarrow %>% 
  count(PID, import_value) %>% 
  arrange(PID) %>% 
  count(PID) %>% 
  filter(n!=2)

### Look at dups ----
dryRun_ScoreExportNarrow %>% 
  count(PID, import_value) %>% 
  arrange(PID) %>% 
  count(PID) %>% 
  filter(n>2) ## There are 4 IDs that have duplicate information


#### Look for true dups ----
dryRun_ScoreExportNarrow %>% 
  count(RegistrationID, import_value) %>% 
  arrange(RegistrationID) %>% 
  count(RegistrationID) %>% 
  filter(n >1)

## This is a true duplicate (uploaded twice)
dryRun_ScoreExportNarrow %>% 
  filter(PID == "DRMIN016") %>% 
  distinct(PID, RegistrationID, import_value) ## We should drop import_value == 115

## This is also a true duplicate (uploaded twice)
dryRun_ScoreExportNarrow %>% 
  filter(RegistrationID == "B4BC6D35-6F96-461C-9B21-7F4DC0D951A8") %>% 
  count(PID, import_value) ## We can also drop import_value == 123

#### Look at non-true dups ----
full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
          suffix = c("_check", ""), multiple = "all") %>% 
  select(PIN, PID_check, PID, RegistrationID, everything()) %>% 
  filter(PID %in% c("DRMIN035", "DRSTL004")) %>% 
  count(PIN, PID_check, PID, RegistrationID, import_value) 


##### DRSTL004 ----
### According to Hugh, “DRSTL004” is actually “DRSTL006” for Assessment 2.
full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
          suffix = c("_check", ""), multiple = "all") %>% 
  select(PIN, PID_check, PID, RegistrationID, everything()) %>% 
  filter(PID %in% c("DRSTL004")) %>% 
  count(PIN, PID, RegistrationID, import_value, AssessmentName) %>% 
  arrange(import_value)

##### DRMIN035 ------
### There are two child and two parent questionnaires
### This is a true duplicate based on the registration file, 
#### As of 2023/03/23 we have the true PIN
full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
          suffix = c("_check", ""), multiple = "all") %>% 
  select(PIN, PID_check, PID, RegistrationID, everything()) %>% 
  filter(PID %in% c("DRMIN035")) %>% 
  count(PIN, PID_check, PID, RegistrationID, import_value, AssessmentName)


# full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
#           suffix = c("_check", ""), multiple = "all") %>% 
#   select(PIN, PID_check, PID, RegistrationID, everything()) %>% 
#   filter(PID %in% c("DRMIN035")) %>% 
#   count(PIN, PID_check, PID, RegistrationID, import_value, InstrumentTitle) %>% 
#   arrange(InstrumentTitle) %>% 
#   count(InstrumentTitle)


### Check the PINs vs the PIDs ----
# full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
#           suffix = c("_check", ""), multiple = "all") %>% 
#   select(PIN, PID_check, PID, RegistrationID, everything()) %>% 
#   mutate(PID_upper = toupper(PID)) %>% 
#   filter(PIN != PID_upper) %>% 
#   count(PIN, PID_check, PID, RegistrationID, import_value) 
# 
# pins <- read.csv("dry_run/data/2023-03-22T172307_shouldHavecorrected2.csv")
# temp <- pins %>% 
#   pull(PINsago) 
# 
# length(temp) # There are 82 PINs
# 
# full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
#           suffix = c("_check", ""), multiple = "all") %>% 
#   select(PIN, PID_check, PID, RegistrationID) %>% 
#   unique() %>% 
#   filter(PIN %in% temp) %>% 
#   count(PIN) # Only 80 of the 82 IDs appear in the data
# 
# temp2 <- full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
#                    suffix = c("_check", ""), multiple = "all") %>% 
#   select(PIN) %>% 
#   unique() %>% 
#   pull(PIN)
# 
# ## These are the 2 PINs missing from the dataframe
# pins %>% 
#   filter(PINsago %nin% temp2) 

### What about IDs that are in the dataset, but not in the list of PINs?
# full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
#           suffix = c("_check", ""), multiple = "all") %>% 
#   select(PIN, PID_check, PID, RegistrationID) %>% 
#   unique() %>% 
#   filter(PIN %nin% temp) %>% 
#   count(PIN) # These IDs aren't in the list provided by Hugh
# 
# temp_path <- str_c(folder, files[162])
# 
# temp_info <- read.csv(temp_path)

#### Remove the 2 duplicate cases ----
full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
          suffix = c("_check", ""), multiple = "all") %>% 
  select(PIN, PID_check, PID, RegistrationID, everything()) %>% 
  filter(import_value %nin% c(115, 123)) %>% 
  count(PIN, import_value) %>% 
  arrange(PIN) %>% 
  count(PIN) %>% 
  filter(n>2) 

dryRun_ScoreExportNarrow_nodups <- full_join(pin_check, dryRun_ScoreExportNarrow, by = c("RegistrationID"),
          suffix = c("_check", ""), multiple = "all") %>% 
  select(PIN, PID, RegistrationID, everything()) %>% 
  filter(import_value %nin% c(115, 123)) ## This needs to be updated to account for DRMIN035

### IDs with info only uploaded once ----
dryRun_ScoreExportNarrow_nodups %>% 
  count(PIN, import_value) %>% 
  arrange(PIN) %>% 
  count(PIN) %>% 
  filter(n==1) ## There are 6 IDs that only have 1 file

dryRun_ScoreExportNarrow_nodups %>% 
  count(PIN, PID, import_value) %>% 
  count(PIN, PID) %>% 
  filter(n==1)

## Final file ----
analysis_ids <- ids_for_analysis %>% 
  pull(PIN)

final_dryRun_ScoreExportNarrow <- dryRun_ScoreExportNarrow_nodups %>% 
  filter(PIN %in% analysis_ids) %>% 
  select(-c(import_value, PID_check))

final_dryRun_ScoreExportNarrow %>% 
  count(PIN)

write_csv(final_dryRun_ScoreExportNarrow, 
          file = "/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_ScoreExportNarrow_20230323.csv")

