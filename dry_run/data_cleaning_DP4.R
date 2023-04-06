# install.packages("psych", repos = "http://personality-project.org/r", type = "source")
# install.packages("psychTools", repos = "http://personality-project.org/r", type = "source")

# Load the relevant libraries --------------------------
library(psych)
library(psychTools)
library(tidyverse)
library(janitor)
library(readxl)
library(writexl)

# Make sure you're running the most recent version of psych
sessionInfo()

# Load the functions and data --------------------------
`%nin%` <- Negate(`%in%`)

dryRun_dp4 <- read_delim("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/DP-4 Dry Run Data/dp-4_export_2023-03-01_2023-03-13_550b82df-c610-4885-b149-58600e8a49e6.txt", trim_ws = TRUE) %>% 
  janitor::clean_names() %>% 
  select(child_id, age, gender, age_at_testing, administration_form_id,
         starts_with("growth_")) %>% 
  select(-c(growth_general_development_score)) %>% 
  mutate(pin = toupper(child_id), 
         pin = ifelse(pin == "DRDAL016", "DRDAL015", 
                    ifelse(pin == "CDRDAL002", "DRDAL002",
                    ifelse(pin == "DAL009", "DRDAL009",
                    ifelse(pin == "DALDAL010", "DRDAL010",
                    ifelse(pin == "DRD011", "DRDAL011",
                    ifelse(pin == "DRMIN34", "DRMIN034",
                    ifelse(pin == "DROR17", "DRORL017",
                    ifelse(pin == "DRMIN035" & age == "7 months", "DRMIN036",
                    ifelse(pin == "DRMIN035" & administration_form_id == "3083996", "DRMIN038",
                           pin)))))))))
         ) %>% 
  filter(pin != "DRMIN035") %>% 
  select(pin, everything())

dim(dryRun_dp4) 
colnames(dryRun_dp4)

pull_dp4_data_ids <- dryRun_dp4 %>% 
  pull(pin)


# These are the IDs we care about for analysis
ids_for_analysis <- read_csv("dry_run/data/2023-03-22T172307_shouldHavecorrected2.csv") %>% 
  rename(PIN = PINsago)

dim(ids_for_analysis)

analysis_ids <- ids_for_analysis %>% 
  pull(PIN)

dp4_ids <- read_xlsx("dry_run/data/dp4_ids.xlsx") %>% 
  as_tibble() %>% 
  mutate(child_id = toupper(child_id),
         child_id = ifelse(child_id == "DRDAL015 – CHILD/DRDAL016 - PARENT", "DRDAL015", child_id))

dim(dp4_ids) # There should be 83 participants

pull_dp4_ids <- dp4_ids %>% 
  pull(child_id)

ids_for_analysis <- read_csv("dry_run/data/2023-03-22T172307_shouldHavecorrected2.csv") %>% 
  rename(PIN = PINsago)

dim(ids_for_analysis)

## Check the dp4 ids ----
dp4_ids %>% 
  filter(child_id %nin% pull_dp4_data_ids) %>% 
  arrange(child_id) # 

dryRun_dp4 %>% 
  filter(pin %nin% pull_dp4_ids) %>% 
  count(pin) %>% 
  arrange(pin)

final_dp4 <- dryRun_dp4 %>% 
  filter(pin %in% analysis_ids) 

final_dp4 %>% 
  count(pin) ## We're missing 4 participants

write_csv(final_dp4,
          file = "/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_DP4_20230323.csv")

## For ID tracking
tracking_dp4 <- final_dp4 %>% 
  select(pin, child_id, administration_form_id)

write_xlsx(tracking_dp4, "dry_run/data/20230324_corrected_pins_dp4.xlsx")
