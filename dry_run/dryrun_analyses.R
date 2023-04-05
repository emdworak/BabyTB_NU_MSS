# install.packages("psych", repos = "http://personality-project.org/r", type = "source")
# install.packages("psychTools", repos = "http://personality-project.org/r", type = "source")

# Load the relevant libraries --------------------------
library(psych)
library(psychTools)
library(tidyverse)
library(janitor)
library(readxl)
library(ggpubr)

# Make sure you're running the most recent version of psych
sessionInfo()

# Load the functions and data --------------------------
`%nin%` <- Negate(`%in%`)

## Load in the score data 
dryRun_ScoreExportNarrow <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_ScoreExportNarrow_20230323.csv") %>% 
  janitor::clean_names()

dim(dryRun_ScoreExportNarrow)
colnames(dryRun_ScoreExportNarrow)

## Load in the item data 
dryRun_ItemExportNarrow <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_ItemExportNarrow_20230323.csv") %>% 
  janitor::clean_names()

dim(dryRun_ItemExportNarrow)
colnames(dryRun_ItemExportNarrow)

## Load in the age data 
dryRun_Registration_Age <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_Registration_Age_20230323.csv") %>% 
  janitor::clean_names()

dim(dryRun_Registration_Age)
colnames(dryRun_Registration_Age)

## Load in the DP4 data 
dryRun_dp4 <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_DP4_20230323.csv") %>% 
  janitor::clean_names()

dim(dryRun_dp4) 
colnames(dryRun_dp4)

# These are the IDs we care about for analysis
ids_for_analysis <- read_csv("dry_run/data/2023-03-22T172307_shouldHavecorrected2.csv") %>% 
  rename(PIN = PINsago)

dim(ids_for_analysis)

analysis_ids <- ids_for_analysis %>% 
  pull(PIN)


# EF Cog -----
# See if anything exploded for EF Cog 16 to 24 months (Touch & Gaze)
ef_names <- c("ExecutiveFunction", "TouchTutorial", #"MVR",
              "MemTaskLearn", "VDRTouch", "MemTaskTest")

ef_cog_df <- dryRun_ScoreExportNarrow %>% 
  filter(test_name %in% ef_names) %>% 
  filter(pin %in% analysis_ids) 

# ef_cog_df %>% 
#   count(test_name, instrument_title)
# 
# ef_cog_df %>% 
#   count(instrument_title, key)
# 
# ef_cog_df %>% 
#   count(test_name, key)

ef_cog_age_df <- full_join(ef_cog_df, dryRun_Registration_Age, 
                           by = c("pin", "pid", "registration_id", "assessment_name"),
                           multiple = "all")


## Pivot the table ------
ef_cog_pivot <- ef_cog_age_df %>% 
  filter(!is.na(instrument_title)) %>% 
  filter(key %nin% c("Language", "InstrumentSandSReason", 
                     "InstrumentRCReasonOther", "InstrumentBreakoff",
                     "InstrumentStatus2")) %>% 
  pivot_wider(id_cols = c(pin, pid, registration_id,
                          assessment_name, #instrument_title,
                          total_age_in_months),
              names_from = c("test_name", "key"),
              values_from = "value") %>% 
  select(pin:total_age_in_months, starts_with("TouchTutorial_"),
         starts_with("MemTaskLearn_"), starts_with("MemTaskTest_"),
         starts_with("VDRTouch_"), starts_with("ExecutiveFunction_"),
         everything()) %>% 
  type_convert()




## Understanding the Data -----

### How many children took each task? -----


ef_cog_age_df %>% 
  filter(!is.na(test_name)) %>% 
  select(pin, test_name, total_age_in_months) %>% 
  unique() %>% 
  group_by(test_name) %>% 
  mutate(min_age = min(total_age_in_months),
         max_age = max(total_age_in_months)) %>% 
  ungroup() %>% 
  count(test_name, min_age, max_age) %>% 
  rename("Test Name" = test_name,
         "Min Age" = min_age,
         "Max Age" = max_age) %>% 
  kbl(caption = "Number of participants and age range by task") %>% 
  kable_styling()


ef_cog_age_df %>% 
  filter(total_age_in_months < 25) %>% 
  filter(!is.na(test_name)) %>% 
  select(pin, test_name, total_age_in_months) %>% 
  unique() %>% 
  count(test_name) %>% 
  rename("Test Name" = test_name) %>% 
  kbl(caption = "Number of participants by task (<25 months)") %>% 
  kable_styling()



### Who got through touch? ------


ef_cog_age_df %>% 
  filter(total_age_in_months < 25) %>% 
  filter(key == "InstrumentBreakoff") %>% 
  count(test_name, value) %>% 
  filter(value == 1) %>% 
  select(-c(value)) %>% 
  rename("Test Name" = test_name) %>% 
  kbl(caption = "Whose instrument’s administration was interrupted? (<25 months)") %>% 
  kable_styling()




ef_cog_age_df %>% 
  filter(total_age_in_months < 25) %>% 
  filter(key == "InstrumentStatus2") %>% 
  count(test_name, value) %>% 
  filter(value == 4) %>% 
  select(-c(value)) %>% 
  rename("Test Name" = test_name) %>% 
  kbl(caption = "Who did not complete the assessment? (<25 months)") %>% 
  kable_styling()




ef_cog_age_df %>% 
  filter(total_age_in_months < 25) %>% 
  filter(key == "InstrumentRCReasonOther") %>% 
  count(test_name, value) %>% 
  filter(test_name != "ExecutiveFunction") %>% 
  rename("Test Name" = test_name) %>% 
  kbl(caption = "Reason for interuption on touch tasks (<25 months)") %>% 
  kable_styling()



## Correlations -----

### Touch ------


ef_cog_pivot %>% 
  select(total_age_in_months, starts_with("TouchTutorial_"), starts_with("MemTaskLearn_"), starts_with("MemTaskTest_"), 
         starts_with("VDRTouch_")) %>% 
  select(-c(ends_with("_ItemCount"))) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  cor.plot(., xlas = 3)


#### Touch Tutorial -----


ef_cog_pivot %>% 
  select(total_age_in_months, starts_with("TouchTutorial_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  kbl(caption = "Correlations of Age and Touch Tutorial") %>% 
  kable_styling()


#### Memory Task (Learning) -----

ef_cog_pivot %>% 
  select(total_age_in_months,  starts_with("MemTaskLearn_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  kbl(caption = "Correlations of Age and Memorty Task (Learning)") %>% 
  kable_styling()


#### Memory Task (Testing) -----


ef_cog_pivot %>% 
  select(total_age_in_months,  starts_with("MemTaskTest_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  kbl(caption = "Correlations of Age and Memorty Task (Test)") %>% 
  kable_styling()


#### VDR -----


ef_cog_pivot %>% 
  select(total_age_in_months,  
         starts_with("VDRTouch_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  kbl(caption = "Correlations of Age and VDR") %>% 
  kable_styling()


### Gaze ------


ef_cog_pivot %>% 
  select(total_age_in_months, starts_with("ExecutiveFunction_")) %>% 
  select(-c(ends_with("_ItemCount"))) %>% 
  rename_with(stringr::str_replace, 
              pattern = "ExecutiveFunction\\_", replacement = "", 
              matches("ExecutiveFunction\\_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  cor.plot(., xlas = 3)




ef_cog_pivot %>% 
  select(total_age_in_months, starts_with("ExecutiveFunction_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "ExecutiveFunction\\_", replacement = "", 
              matches("ExecutiveFunction\\_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  kbl(caption = "Correlations of Age and Gaze") %>% 
  kable_styling()



## Linear Plots (All Ages) -----

### Touch -----


lapply(
  names(ef_cog_pivot)[c(7, 9, 11:14)], 
  function(n) 
    ggplot(data = ef_cog_pivot, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw() +
    scale_x_continuous(breaks = seq(2, 50, 2), labels = seq(2, 50, 2))
)


### Gaze ------


lapply(
  names(ef_cog_pivot)[16:26], 
  function(n) 
    ggplot(data = ef_cog_pivot, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw() +
    scale_x_continuous(breaks = seq(2, 50, 2), labels = seq(2, 50, 2))
)


## Non-Linear Plots (All Ages) -------

### Touch ------


lapply(
  names(ef_cog_pivot)[c(7, 9, 11:14)], 
  function(n) 
    ggplot(data = ef_cog_pivot, aes_string(x = "total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(se = FALSE, color = "red") +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw() +
    scale_x_continuous(breaks = seq(2, 50, 2), labels = seq(2, 50, 2))
)


### Gaze ------


lapply(
  names(ef_cog_pivot)[16:26], 
  function(n) 
    ggplot(data = ef_cog_pivot, aes_string(x = "total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(se = FALSE, color = "red") +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw() +
    scale_x_continuous(breaks = seq(2, 50, 2), labels = seq(2, 50, 2))
)


## Linear Plots (16 to 21 month olds) -----


limitedAge_ef_cog_pivot <- ef_cog_pivot %>% 
  filter(between(total_age_in_months, 16, 21))



### Touch -----


lapply(
  names(limitedAge_ef_cog_pivot)[c(7, 9, 11:14)], 
  function(n) 
    ggplot(data = limitedAge_ef_cog_pivot, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw()
)


### Gaze -----


lapply(
  names(limitedAge_ef_cog_pivot)[16:26], 
  function(n) 
    ggplot(data = limitedAge_ef_cog_pivot, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw()
)


## Non-Linear Plots (16 to 21 month olds) -----

### Touch -----


lapply(
  names(limitedAge_ef_cog_pivot)[c(7, 9, 11:14)], 
  function(n) 
    ggplot(data = limitedAge_ef_cog_pivot, aes_string(x = "total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(se = FALSE, color = "red") +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw()
)


### Gaze -------


lapply(
  names(limitedAge_ef_cog_pivot)[16:26], 
  function(n) 
    ggplot(data = limitedAge_ef_cog_pivot, aes_string(x = "total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(se = FALSE, color = "red") +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw()
)



## Familiarization without outliers -------

### Remove the outlier ------

ef_cog_pivot_2 <- ef_cog_pivot %>% 
  filter(ExecutiveFunction_FamiliarizationRound2 < 6000)

limitedAge_ef_cog_pivot2 <- limitedAge_ef_cog_pivot %>% 
  filter(ExecutiveFunction_FamiliarizationRound2 < 6000)



### All ages -----

#### Correlations -----


ef_cog_pivot_2 %>% 
  select(total_age_in_months, starts_with("ExecutiveFunction_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "ExecutiveFunction\\_", replacement = "", 
              matches("ExecutiveFunction\\_")) %>% 
  select(total_age_in_months, starts_with("Familiarization")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  cor.plot(., xlas = 3)


#### Linear Plots ------


lapply(
  names(ef_cog_pivot_2)[17:19], 
  function(n) 
    ggplot(data = ef_cog_pivot_2, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw() +
    scale_x_continuous(breaks = seq(2, 50, 2), labels = seq(2, 50, 2))
)


#### Non- Linear Plots ------


lapply(
  names(ef_cog_pivot_2)[17:19], 
  function(n) 
    ggplot(data = ef_cog_pivot_2, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(color = "red", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw() +
    scale_x_continuous(breaks = seq(2, 50, 2), labels = seq(2, 50, 2))
)


### 16 to 21 month olds ------

#### Correlations ------


limitedAge_ef_cog_pivot2 %>% 
  select(total_age_in_months, starts_with("ExecutiveFunction_")) %>% 
  rename_with(stringr::str_replace, 
              pattern = "ExecutiveFunction\\_", replacement = "", 
              matches("ExecutiveFunction\\_")) %>% 
  select(total_age_in_months, starts_with("Familiarization")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., 3) %>% 
  cor.plot(., xlas = 3)


#### Linear Plots ------


lapply(
  names(limitedAge_ef_cog_pivot2)[17:19], 
  function(n) 
    ggplot(data = limitedAge_ef_cog_pivot2, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(method = "lm", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw()
)


#### Non- Linear Plots ------


lapply(
  names(limitedAge_ef_cog_pivot2)[17:19], 
  function(n) 
    ggplot(data = limitedAge_ef_cog_pivot2, aes_string(x="total_age_in_months", y = n)) + 
    geom_point() + 
    geom_smooth(color = "red", se = FALSE) +
    stat_cor(method = "spearman",
             aes(label = ..r.label..)) +
    theme_bw()
)



# Item to Item Correlation ----
# Using the combined ItemExportNarrow file, find the item-to-item correlation within measure (preferably Spearman)
dryRun_ItemExportNarrow %>% 
  filter(key == "Score") %>% 
  count(instrument_title)

dryRun_ItemExportNarrow %>% 
  filter(key == "Score") %>% 
  count(instrument_title, item_id)


item_wide <- dryRun_ItemExportNarrow %>% 
  filter(key == "Score") %>% 
  pivot_wider(id_cols = c(pin, instrument_title),
              names_from = item_id,
              values_from = value) %>% 
  type_convert()

temp_wide %>% 
  count(instrument_title)

pull_instrument <- item_wide %>% 
  count(instrument_title) %>% 
  pull(instrument_title)

# Create a list that to save the variables into it
describe_df <- data.frame(instrument_title = NA,
                          item_id = NA,
                          n = NA,
                          mean = NA,
                          sd = NA,
                          min = NA,
                          max = NA)

# Determine if variables are poly or tetrachoric
for(i in 1:length(pull_instrument)) {
  df <- item_wide %>% 
    filter(instrument_title %in% paste(pull_instrument[i])) %>% 
    select(-c(pin))
  
  df <- df[,colSums(is.na(df))<nrow(df)]
  
  temp_describe <- describe(df, skew = FALSE) %>% 
    data.frame() %>% 
    select(-c(vars, range, se)) %>% 
    mutate(instrument_title = paste(pull_instrument[i]), 
           item_id = rownames(describe(df, skew = FALSE))) %>% 
    select(item_id, everything())
  
  row.names(temp_describe) <- NULL
  
  describe_df <- bind_rows(describe_df, temp_describe)         
  
}

describe_df <- describe_df %>% 
  filter(!is.na(instrument_title))


pull_poly <- describe_df %>% 
  filter(max > 1) %>% 
  count(instrument_title) %>% 
  # Verbal Counting only contains 1 scored item and therefore can't get a correlation
  filter(instrument_title != "Verbal Counting") %>% 
  pull(instrument_title)

pull_tetra <- describe_df %>% 
  filter(instrument_title %nin% pull_poly) %>% 
  filter(max == 1) %>% 
  filter(min == 0) %>% 
  count(instrument_title) %>% 
  pull(instrument_title)

### Do all the polychoric measures ----

for(i in 1:length(pull_poly)) {
  df <- item_wide %>% 
    filter(instrument_title %in% paste(pull_poly[i])) %>% 
    select(-c(pin, instrument_title))
  
  df <- df[,colSums(is.na(df))<nrow(df)]
  
  cor_matrix <- df %>% 
    cor(., use = "pairwise", method = "spearman") %>% 
    round(., digits = 3)  
  
  
  cor_matrix %>% 
    cor.plot(., xlas = 3, main = paste(pull_poly[i]))
  
  print(cor_matrix)
}

### Do the tetrachoric matrices ----

for(i in 1:length(pull_tetra)) {
  df <- item_wide %>% 
    filter(instrument_title %in% paste(pull_tetra[i])) %>% 
    select(-c(pin, instrument_title))
  
  df <- df[,colSums(is.na(df))<nrow(df)]
  
  cor_matrix_all <- df %>% 
    tetrachoric(., delete = FALSE, correct = FALSE) 
  
  cor_matrix <- round(cor_matrix_all$rho, digits = 3)
  
  cor_matrix %>% 
    cor.plot(., xlas = 3, main = paste(pull_tetra[i]))
  
  print(cor_matrix)
}


# Scores & Age Correlation ----
scores_long_df <- dryRun_ScoreExportNarrow %>% 
  filter(pin %in% analysis_ids) 

scores_long_age_df <- full_join(scores_long_df, dryRun_Registration_Age, 
                                by = c("pin", "pid", "registration_id", "assessment_name"),
                                multiple = "all")


## Pivot the table ------
scores_age_pivot <- scores_long_age_df %>% 
  filter(!is.na(instrument_title)) %>% 
  filter(key %nin% c("Language", "InstrumentSandSReason", 
                     "InstrumentRCReasonOther", "InstrumentBreakoff",
                     "InstrumentStatus2")) %>% 
  pivot_wider(id_cols = c(pin, pid, registration_id,
                          assessment_name, #instrument_title,
                          total_age_in_months),
              names_from = c("test_name", "key"),
              values_from = "value") %>% 
  select(pin:total_age_in_months, everything()) %>% 
  type_convert()

scores_age_filtered_pivot <- scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount")))

colnames(scores_age_filtered_pivot)


## Understanding the Data -----

### How many children took each task? -----

scores_long_age_df %>% 
  filter(!is.na(test_name)) %>% 
  select(pin, test_name, total_age_in_months) %>% 
  unique() %>% 
  group_by(test_name) %>% 
  mutate(min_age = min(total_age_in_months),
         max_age = max(total_age_in_months)) %>% 
  ungroup() %>% 
  count(test_name, min_age, max_age) %>% 
  arrange(min_age, max_age) %>% 
  rename("Test Name" = test_name,
         "Min Age" = min_age,
         "Max Age" = max_age) %>% 
  kbl(caption = "Number of participants and age range by task") %>% 
  kable_styling()

### Descriptive Statistics by test -----

describe_scores_df <- scores_age_pivot %>% 
  select(-c(pin, pid, registration_id, assessment_name, total_age_in_months,
            ends_with("_ItemCount"))) %>% 
  describe(., skew = FALSE)  

scores_summary <- describe_scores_df %>% 
  mutate(across(where(is.numeric), round, digits = 2)) %>% 
  data.frame() %>% 
  select(-c(vars, range, se)) %>% 
  mutate(item_id = rownames(describe_scores_df)) %>% 
  select(item_id, everything()) 

rownames(scores_summary) <- NULL

#### Age -----
scores_age_pivot %>% 
  select(pin, total_age_in_months) %>% 
  unique() %>% 
  #select(total_age_in_months) %>% #For some reason it won't run if I have select
  describe(., skew = FALSE) %>% 
  mutate(across(where(is.numeric), round, digits = 2)) %>% 
  data.frame() %>% 
  filter(vars == "2") %>% 
  select(-c(vars, range, se))

#### Parent Measures -----
##### Not PROMIS 
scores_summary %>% 
  filter(str_detect(item_id, "CBQ") | 
           str_detect(item_id, "CDI") | 
           str_detect(item_id, "Caregiver") | 
           str_detect(item_id, "IBQ")) %>% 
  arrange(item_id)

##### PROMIS
scores_summary %>% 
  filter(str_detect(item_id, "PROMIS")) %>% 
  arrange(item_id)

#### Child Measures -----

### Executive Function 
scores_summary %>% 
  filter(str_detect(item_id, "ExecutiveFunction") |
           str_detect(item_id, "Touch") |
           str_detect(item_id, "MemTask")
         ) %>% 
  arrange(item_id)
  
### Other Gaze Measures
scores_summary %>% 
  filter(str_detect(item_id, "LookListening") |
           str_detect(item_id, "ChangeDetect_")
         ) %>% 
  arrange(item_id)

### Math/Counting
scores_summary %>% 
  filter(str_detect(item_id, "Counting_") |
           str_detect(item_id, "Arithmetic_") |
           str_detect(item_id, "NumRecogSubitizing") |
           str_detect(item_id, "WhoHasMore")
  ) %>% 
  arrange(item_id)

### Social
scores_summary %>% 
  filter(str_detect(item_id, "SocialObservation")
  ) %>% 
  arrange(item_id)

### Mullen 
scores_summary %>% 
  filter(str_detect(item_id, "Mullen_") |
           str_detect(item_id, "MVR_")) %>% 
  arrange(item_id)

### NIHTB
scores_summary %>% 
  filter(str_detect(item_id, "SM_") | 
  str_detect(item_id, "PV_")) %>% 
arrange(item_id)

## Correlations ----

#### Parent Measures -----
##### Not PROMIS 
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("CBQ"),  
         contains("CDI"),  
         starts_with("Caregiver"),  
         contains("IBQ")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("CBQ"),  
         contains("CDI"),  
         starts_with("Caregiver"),  
         contains("IBQ")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Parent Measures (not PROMIS)")  

##### PROMIS
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("PROMIS")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("PROMIS")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Parent Measures (PROMIS)")   

#### Child Measures -----

### Executive Function 
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("ExecutiveFunction"), 
         contains("Touch"), 
         contains("MemTask")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("ExecutiveFunction"), 
         contains("Touch"), 
         contains("MemTask")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "EF Measures")

### Other Gaze Measures
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("LookListening"), 
         contains("ChangeDetect_")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3) 

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("LookListening"), 
         contains("ChangeDetect_")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Gaze Measures")

### Math/Counting
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("Counting_"), 
         contains("Arithmetic_"), 
         contains("NumRecogSubitizing"), 
         contains("WhoHasMore")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("Counting_"), 
         contains("Arithmetic_"), 
         contains("NumRecogSubitizing"), 
         contains("WhoHasMore")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Numeracy Measures")


### Social
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("SocialObservation")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3) 

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("SocialObservation")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Social Observation")

### Motor Item Count
scores_age_pivot %>% 
  select(total_age_in_months, 
         starts_with("Sit"), starts_with("Get"),
         starts_with("Reach")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_age_pivot %>% 
  select(total_age_in_months, starts_with("Sit"), starts_with("Get"),
         starts_with("Reach")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Motor (Item Counts)")


### Mullen 
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("MVR_"), contains("Mullen_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("MVR_"), contains("Mullen_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Mullen") 

### NIHTB
scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("SM_"),  
         contains("PV_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_age_pivot %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(total_age_in_months, contains("SM_"),  
         contains("PV_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "NIHTB") 




# Run the DP4 cors -----
#Correlation the growth scale values with BBTB scores
dryRun_dp4 %>% 
  colnames()

scores_DP4_df <- full_join(scores_age_pivot, dryRun_dp4, 
                                by = "pin") %>% 
  select(-c(child_id, age, gender, age_at_testing, administration_form_id))


## Correlations ----

#### Parent Measures -----
##### Not PROMIS 
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("CBQ"),  
         contains("CDI"),  
         starts_with("Caregiver"),  
         contains("IBQ")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("CBQ"),  
         contains("CDI"),  
         starts_with("Caregiver"),  
         contains("IBQ")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Parent Measures (not PROMIS)")  

##### PROMIS
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("PROMIS")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("PROMIS")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Parent Measures (PROMIS)")   

#### Child Measures -----

### Executive Function 
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("ExecutiveFunction"), 
         contains("Touch"), 
         contains("MemTask")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("ExecutiveFunction"), 
         contains("Touch"), 
         contains("MemTask")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "EF Measures")

### Other Gaze Measures
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("LookListening"), 
         contains("ChangeDetect_")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3) 

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("LookListening"), 
         contains("ChangeDetect_")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Gaze Measures")

### Math/Counting
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("Counting_"), 
         contains("Arithmetic_"), 
         contains("NumRecogSubitizing"), 
         contains("WhoHasMore")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("Counting_"), 
         contains("Arithmetic_"), 
         contains("NumRecogSubitizing"), 
         contains("WhoHasMore")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Numeracy Measures")


### Social
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("SocialObservation")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3) 

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("SocialObservation")
  ) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Social Observation")

# ### Motor Item Count
# scores_DP4_df %>% 
#   select(starts_with("growth"), 
#          starts_with("Sit"), starts_with("Get"),
#          starts_with("Reach")) %>% 
#   cor(., use = "pairwise", method = "spearman") %>% 
#   round(., digits = 3)  
# 
# scores_DP4_df %>% 
#   select(starts_with("growth"), starts_with("Sit"), starts_with("Get"),
#          starts_with("Reach")) %>% 
#   cor(., use = "pairwise", method = "spearman") %>% 
#   cor.plot(., xlas = 3, main = "Motor (Item Counts)")


### Mullen 
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("MVR_"), contains("Mullen_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("MVR_"), contains("Mullen_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "Mullen") 

### NIHTB
scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("SM_"),  
         contains("PV_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  round(., digits = 3)  

scores_DP4_df %>% 
  select(-c(ends_with("_ItemCount"))) %>%
  select(starts_with("growth"), contains("SM_"),  
         contains("PV_")) %>% 
  cor(., use = "pairwise", method = "spearman") %>% 
  cor.plot(., xlas = 3, main = "NIHTB") 


# Assessment Times ----
## Code what the assessment was
pull_parent_assessments <- scores_long_df %>% 
  select(test_name) %>% 
  filter(str_detect(test_name, "CBQ") |  
         str_detect(test_name, "CDI") |  
         str_detect(test_name, "Caregiver") |  
         str_detect(test_name, "IBQ") | 
           str_detect(test_name, "PROMIS")) %>% 
  unique() %>% 
  pull(test_name)

# Create a DF that will allow us to know the type of assessment
child_parent_assessment <- scores_long_df %>% 
  select(pin, registration_id, test_name, instrument_title) %>% 
  unique() %>% 
  mutate(type = ifelse(test_name %in% pull_parent_assessments, "Parent",
                       "Child")) %>% 
  select(pin, registration_id, type) %>% 
  unique()

# Figure out the 16-21 battery 
touch_gaze_df <- dryRun_ItemExportNarrow %>% 
  filter(pin %in% analysis_ids) %>% 
  filter(key == "Score") %>% 
  select(pin, registration_id, instrument_title) %>% 
  unique() %>% 
  full_join(., child_parent_assessment, by = c("pin", "registration_id")) %>%  
  filter(type == "Child") %>% 
  select(-c(type)) %>% 
  filter(instrument_title %in% c("Executive Function", "NBT Touch Screen Tutorial",
                                 "Memory Task Learning", "Memory Task Test")) %>% 
  filter(!is.na(instrument_title)) %>% 
  arrange(pin) %>% 
  mutate(battery = ifelse(instrument_title == "Executive Function", "Gaze",
                          ifelse(instrument_title == "NBT Touch Screen Tutorial", "Touch", 
                                 ifelse(instrument_title == "Memory Task Learning", "Touch", 
                                        ifelse(instrument_title == "Memory Task Test", "Touch", 
                                        NA))))) %>% 
  select(-c(instrument_title)) %>% 
  unique()

# Find the assessment times of each battery
all_battery_times <- dryRun_ItemExportNarrow %>% 
  filter(pin %in% analysis_ids) %>% 
  filter(key == "DateCreated") %>% 
  group_by(pin, registration_id) %>% 
  mutate(min_time = min(value), 
         max_time = max(value)) %>% 
  select(pin, registration_id, min_time, max_time) %>% 
  unique() %>% 
  mutate(min_time = lubridate::as_datetime(min_time),
         max_time = lubridate::as_datetime(max_time),
         diff = difftime(max_time, min_time, units = "mins")) %>% 
  ungroup() %>% 
  mutate(diff_min = str_remove(diff, " min"),
         diff_min = as.numeric(diff_min)) %>% 
  full_join(., dryRun_Registration_Age, 
          by = c("pin", "registration_id"),
          multiple = "all") %>% 
  select(pin, registration_id, total_age_in_months, min_time, max_time, diff_min) %>% 
  full_join(., child_parent_assessment, by = c("pin", "registration_id")) %>% 
  full_join(., touch_gaze_df, by = c("pin", "registration_id")) %>% 
  mutate(parent_battery = ifelse(between(total_age_in_months, 3,5), "3-5 Month", 
                                 ifelse(total_age_in_months == 6, "6 Month", 
                                        ifelse(between(total_age_in_months, 7,8), "7-8 Month", 
                                               ifelse(between(total_age_in_months, 9,12), "9-12 Month", 
                                                      ifelse(between(total_age_in_months, 13,18), "13-18 Month", 
                                                             ifelse(between(total_age_in_months, 19,30), "19-30 Month", 
                                                                    ifelse(between(total_age_in_months, 31,36), "31-36 Month", 
                                                                           ifelse(total_age_in_months >= 37, "37+ Month", NA)))))))),
         parent_battery = ifelse(type == "Parent", parent_battery, NA),
         parent_battery = as.factor(parent_battery),
         parent_battery = fct_relevel(parent_battery, "3-5 Month","6 Month", 
                                      "7-8 Month", "9-12 Month", "13-18 Month", 
                                      "19-30 Month", "31-36 Month","37+ Month"),
         child_battery = ifelse(between(total_age_in_months, 1,5), "1-5 Month",
                                ifelse(between(total_age_in_months, 6,8), "6-8 Month", 
                               ifelse(between(total_age_in_months, 9,15), "9-15 Month", 
                                ifelse(battery == "Gaze" & between(total_age_in_months, 16,21), "16-21 Month with gaze",
                                 ifelse(battery == "Touch" & between(total_age_in_months, 16,21), "16-21 Month with touch",
                                 ifelse(between(total_age_in_months, 22,24), "22-24 Month", 
                                  ifelse(between(total_age_in_months, 25,36), "25-36 Month", 
                                   ifelse(total_age_in_months >= 37, "37+ Month", NA)))))))),
         child_battery = ifelse(type == "Child", child_battery, NA),
         child_battery = as.factor(child_battery),
         child_battery = fct_relevel(child_battery, "1-5 Month", "6-8 Month", "9-15 Month",  
                                     "16-21 Month with gaze", "16-21 Month with touch", 
                                     "22-24 Month",  "25-36 Month", "37+ Month")
         ) %>% 
  arrange(pin) %>% 
  select(-c(battery))

battery_times_child <- all_battery_times %>% 
  filter(type == "Child") %>% 
  select(-c(type)) 

battery_times_parent <- all_battery_times %>% 
  filter(type == "Parent") %>% 
  select(-c(type))

all_battery_times %>% 
  ggplot(aes(x = diff_min)) +
  geom_histogram() +
  facet_wrap(~type)


## Child Battery -----
battery_times_child %>% 
  ggplot(aes(x = diff_min)) +
  geom_histogram() +
  facet_wrap(~child_battery) +
  labs(title = "Distribution of Timing on Child Batteries",
       x = "Time on Battery (min)",
       y = "Count")

child_battery_times <- describeBy(battery_times_child$diff_min, group = battery_times_child$child_battery,
           mat = TRUE, skew = FALSE) %>% 
  select(-c(item, vars))

rownames(child_battery_times) <- NULL

child_battery_times %>% 
  kbl(caption = "Descriptive Statistics of Child Batteries") %>% 
  kable_styling()
  
## Parent Battery -----
battery_times_parent %>% 
  ggplot(aes(x = diff_min)) +
  geom_histogram() +
  facet_wrap(~parent_battery) +
  labs(title = "Distribution of Timing on Parent Batteries",
       x = "Time on Battery (min)",
       y = "Count")

parent_battery_times <- describeBy(battery_times_parent$diff_min, group = battery_times_parent$parent_battery,
           mat = TRUE, skew = FALSE) %>% 
  select(-c(item, vars))

rownames(parent_battery_times) <- NULL

parent_battery_times %>% 
  kbl(caption = "Descriptive Statistics of Parent Batteries") %>% 
  kable_styling()


