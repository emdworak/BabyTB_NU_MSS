# Load the libraries -----
library(psych)
library(psychTools)
library(tidyverse)
library(janitor)
library(readxl)
library(ggpubr)
library(kableExtra)

# Load the functions and data --------------------------
`%nin%` <- Negate(`%in%`)

# These are the IDs we care about for analysis
ids_for_analysis <- read_csv("data/2023-03-22T172307_shouldHavecorrected2.csv") %>% 
  rename(PIN = PINsago)

# dim(ids_for_analysis)

analysis_ids <- ids_for_analysis %>% 
  pull(PIN)

## Load in the item data 
dryRun_ItemExportNarrow <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_ItemExportNarrow_20230323.csv") %>%
  janitor::clean_names() %>% 
  filter(pin %in% analysis_ids) %>% 
  select(-c(pid))

# dim(dryRun_ItemExportNarrow)
# colnames(dryRun_ItemExportNarrow)

## Load in the age data 
dryRun_Registration_Age <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_Registration_Age_20230323.csv") %>% 
  janitor::clean_names() %>% 
  filter(pin %in% analysis_ids) %>% 
  select(-c(pid, age))

# dim(dryRun_Registration_Age)
# colnames(dryRun_Registration_Age)

## Load in the DP4 data 
dryRun_dp4 <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_DP4_20230323.csv") %>% 
  janitor::clean_names() %>% 
  filter(pin %in% analysis_ids) %>% 
  select(-c(child_id, age, gender, age_at_testing, administration_form_id))

# dim(dryRun_dp4) 
# colnames(dryRun_dp4)

# Work with the data ----
## Filter out the stuff we don't need
item_df <- dryRun_ItemExportNarrow %>% 
  filter(key %in% c("Response", "ResponseTime", "Score")) %>% #, 
                    # "Theta", "ThetaStandardError")) %>% 
  filter(str_detect(item_id, "[tT]itle", negate = TRUE)) %>% 
  filter(str_detect(item_id, "\\_[iI][nN][tT][rR][oO]", negate = TRUE)) %>% 
  filter(str_detect(item_id, "\\_[iI]nstruction", negate = TRUE)) %>% 
  filter(str_detect(item_id, "_Instruct1", negate = TRUE)) %>% 
  filter(str_detect(item_id, "Calibration", negate = TRUE)) %>% 
  filter(str_detect(item_id, "Head", negate = TRUE)) %>% 
  filter(str_detect(item_id, "Vid", negate = TRUE)) %>% 
  filter(str_detect(item_id, "_image", negate = TRUE)) %>% 
  filter(str_detect(item_id, "_Tutorial", negate = TRUE)) %>% 
  filter(str_detect(item_id, "Transition", negate = TRUE)) %>% 
  filter(str_detect(item_id, "VOCAB_INSTR", negate = TRUE)) %>% 
  filter(str_detect(item_id, "VOCAB_PRACT", negate = TRUE)) 

dim(item_df)

age_df <- dryRun_Registration_Age %>% 
  select(pin, total_age_in_months) %>% 
  unique()

dim(age_df)

external_df <- full_join(age_df, dryRun_dp4, by = "pin")

dim(external_df)


## Create domain specific dataframe ----

### Motor -----
motor_df <- item_df %>% 
  filter(instrument_title %in% c("Get Up and Go", "Sit and Stand",
                                 "Reach To Eat")) %>% 
  pivot_wider(id_cols = pin,
              names_from = c(instrument_title, item_id, key),
              values_from = value) %>%
  type_convert()

dim(motor_df)

motor_export <- full_join(external_df, motor_df, by = "pin") %>% 
  janitor::clean_names() %>% 
  rename_with(stringr::str_replace, 
              pattern = "\\_sa\\_s\\_", replacement = "_sas_", 
              matches("\\_sa\\_s\\_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "gu\\_g", replacement = "gug", 
              matches("gu\\_g")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "rt\\_e", replacement = "rte", 
              matches("rt\\_e")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "st\\_d", replacement = "std", 
              matches("st\\_d"))%>% 
  rename_with(stringr::str_replace, 
              pattern = "pt\\_s", replacement = "pts", 
              matches("pt\\_s"))%>% 
  rename_with(stringr::str_replace, 
              pattern = "ft\\_a", replacement = "fta", 
              matches("ft\\_a"))%>% 
  rename_with(stringr::str_replace, 
              pattern = "spn\\_t", replacement = "spnt", 
              matches("spn\\_t")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "\\_r\\_", replacement = "r_", 
              matches("\\_r\\_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "\\_l\\_", replacement = "l_", 
              matches("\\_l\\_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "\\_stair\\_", replacement = "_stair", 
              matches("\\_stair\\_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "\\_tra\\_", replacement = "_tra", 
              matches("\\_tra\\_")) %>% 
  select(pin:growth_communication, starts_with("get"), starts_with("sit"), 
         starts_with("reach"))


dim(motor_export)
colnames(motor_export)

write_csv(motor_export, "data/for_sharepoint/20230418_dryRun_motor_data.csv")

### Language -----
lang_df <- item_df %>% 
  filter(instrument_title %in% c("Mullen Expressive Observational",
                                 "Mullen Expressive Prompted",
                                 "Mullen Receptive",
                                 "Looking While Listening",
                                 "Picture Vocabulary",
                                 "CDI: Expressive",
                                 "CDI: Receptive")) %>% 
  pivot_wider(id_cols = pin,
              names_from = c(instrument_title, item_id, key),
              values_from = value) %>%
  type_convert()

dim(lang_df)

lang_export <- full_join(external_df, lang_df, by = "pin") %>% 
  janitor::clean_names() %>% 
  select(pin:growth_communication, starts_with("mullen_re"), starts_with("mullen_expressive_p"),
         starts_with("mullen_expressive_o"), starts_with("looking"), starts_with("picture"),
         starts_with("cdi_r"), starts_with("cdi_e"))

dim(lang_export)
colnames(lang_export)

write_csv(lang_export, "data/for_sharepoint/20230418_dryRun_language_data.csv")

### Cognition / Executive Function ----
ef_cog_df <- item_df %>% 
  filter(instrument_title %in% c("Mullen Visual Reception",
                                 "Executive Function",
                                 "Memory Task Learning",
                                 "Memory Task Test",
                                 "Visual Delayed Response",
                                 "NBT Touch Screen Tutorial")) %>% 
  pivot_wider(id_cols = pin,
              names_from = c(instrument_title, item_id, key),
              values_from = value) %>%
  type_convert()

dim(ef_cog_df)

ef_cog_export <- full_join(external_df, ef_cog_df, by = "pin") %>% 
  janitor::clean_names() %>% 
  select(pin:growth_communication, starts_with("mullen_"), starts_with("memory_task_l"),
         starts_with("memory_task_t"), starts_with("executive_"), starts_with("visual_delayed"),
         everything())

dim(ef_cog_export)
colnames(ef_cog_export)

write_csv(ef_cog_export, "data/for_sharepoint/20230418_dryRun_ef_cog_data.csv")

### Social Functioning -----

soc_fun_df <- item_df %>% 
  filter(instrument_title %in% c("Social Observation",
                                 "Caregiver Checklist",
                                 "PROMIS EC Parent-Report SF v1.0 - Social Relationships - Child-Caregiver Interactions 5a",
                                 "PROMIS EC Parent-Report SF v1.0 - Social Relationships - Peer Relationships 4a")) %>% 
  pivot_wider(id_cols = pin,
              names_from = c(instrument_title, item_id, key),
              values_from = value) %>%
  type_convert()

dim(soc_fun_df)

soc_fun_export <- full_join(external_df, soc_fun_df, by = "pin") %>% 
  janitor::clean_names() %>% 
  select(pin:growth_communication, starts_with("social_observation_so_9_23"), 
         starts_with("social_observation_so_24_48"),
         starts_with("social_observation_"),
         starts_with("caregiver_checklist"), 
         starts_with("promis_ec_parent_report_sf_v1_0_social_relationships_c"), 
         starts_with("promis_ec_parent_report_sf_v1_0_social_relationships_p"))

dim(soc_fun_export)
colnames(soc_fun_export)

write_csv(soc_fun_export, "data/for_sharepoint/20230418_dryRun_social_functioning_data.csv")

### Self-Regulation -----

self_reg_df <- item_df %>% 
  filter(instrument_title %in% c("Infant Behavior Questionnaire - Revised - Very Short Form",
                                 "Children's Behavior Questionnaire - Very Short Form",
                                 "PROMIS Early Childhood Parent-Report Bank v1.0 - Anger/Irritability",
                                 "PROMIS Early Childhood Parent-Report Bank v1.0 - Anxiety",
                                 "PROMIS Early Childhood Parent-Report Bank v1.0 - Depressive Symptoms",
                                 "PROMIS Early Childhood Parent-Report Bank v1.0 - Positive Affect",
                                 "PROMIS Early Childhood Parent-Report Scale v1.0 - Self-Regulation - Flexibility 5a",
                                 "PROMIS Early Childhood Parent-Report Scale v1.0 - Self-Regulation - Frustration Tolerance 6a")) %>% 
  pivot_wider(id_cols = pin,
              names_from = c(instrument_title, item_id, key),
              values_from = value) %>%
  type_convert()

dim(self_reg_df)

self_reg_export <- full_join(external_df, self_reg_df, by = "pin") %>% 
  janitor::clean_names() %>% 
  select(pin:growth_communication, starts_with("infant_"), 
         starts_with("childrens_behavior"),
         starts_with("promis_early_childhood_parent_report_bank_v1_0_dep"),
         starts_with("promis_early_childhood_parent_report_bank_v1_0_anx"),
         starts_with("promis_early_childhood_parent_report_bank_v1_0_ang"),
         starts_with("promis_early_childhood_parent_report_bank_v1_0_pos"),
         starts_with("promis_early_childhood_parent_report_scale_v1_0_self_"),
         everything())

dim(self_reg_export)
colnames(self_reg_export)

write_csv(self_reg_export, "data/for_sharepoint/20230418_dryRun_self_regulation_data.csv")

### Numeracy -----

num_df <- item_df %>% 
  filter(instrument_title %in% c("Spatial Change Detection",
                                 "Numerical Change Detection",
                                 "Verbal Counting",
                                 "Who Has More",
                                 "Subitizing",
                                 "Object Counting",
                                 "Verbal Arithmetic"
                                 )) %>% 
  pivot_wider(id_cols = pin,
              names_from = c(instrument_title, item_id, key),
              values_from = value) %>%
  type_convert()

dim(num_df)

num_export <- full_join(external_df, num_df, by = "pin") %>% 
  janitor::clean_names() %>% 
  select(pin:growth_communication, starts_with("spatial_"), 
         starts_with("numerical_"),
         starts_with("verbal_counting"),
         starts_with("object_counting"),
         starts_with("subitizing"),
         starts_with("who_has_more"),
         starts_with("verbal_arithmetic"),
         everything())

dim(num_export)
colnames(num_export)

write_csv(num_export, "data/for_sharepoint/20230418_dryRun_numeracy_data.csv")

# write_csv(item_export, "data/for_sharepoint/20230417_dryRun_item_data.csv")





