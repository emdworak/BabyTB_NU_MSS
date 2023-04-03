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
files <- list.files(folder, pattern = "^RegistrationExportNarrowStructure")

length(files) # There should be 175 cases

combine_RegistrationExportNarrow <- list()



for(i in 1:length(files)){
  folder_path <- str_c(folder, files[i])
  
  item_info <- read.csv(folder_path)
  
  item_info <- data.frame(item_info, "import_value" = i)
  
  combine_RegistrationExportNarrow[[i]] <- item_info
}

dryRun_RegistrationExportNarrow <- bind_rows(combine_RegistrationExportNarrow)
dim(dryRun_RegistrationExportNarrow)
colnames(dryRun_RegistrationExportNarrow)

## QA the data -----
dryRun_Registration_Age <- dryRun_RegistrationExportNarrow %>% 
  filter(Key %in% c("TotalAgeInMonths", "Age")) %>% 
  pivot_wider(id_cols = c(PID, RegistrationID, AssessmentName, import_value),
              names_from = Key,
              values_from = Value) %>% 
  unique() 

## Save the dataset -----
analysis_ids <- ids_for_analysis %>% 
  pull(PIN)

final_dryRun_Registration_Age <- full_join(pin_check, dryRun_Registration_Age, by = c("RegistrationID"),
          suffix = c("_check", ""), multiple = "all") %>% 
  filter(import_value %nin% c(115, 123)) %>% 
  select(-c(PID_check, import_value)) %>% 
  arrange(PIN) %>% 
  filter(PIN %in% analysis_ids)

final_dryRun_Registration_Age %>% 
  count(PIN)

write_csv(final_dryRun_Registration_Age, 
          file = "/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_Registration_Age_20230323.csv")
