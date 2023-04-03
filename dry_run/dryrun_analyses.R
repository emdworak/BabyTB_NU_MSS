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
         "Max Age" = max_age)%>% 
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
  filter(test_name != "ExecutiveFunction")  %>% 
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


temp_wide <- dryRun_ItemExportNarrow %>% 
  filter(key == "Score") %>% 
  pivot_wider(id_cols = c(pin, instrument_title),
              names_from = item_id,
              values_from = value)

describeBy(temp_wide[,-c(1)], group = "instrument_title", skew = FALSE, mat = TRUE) %>% 
  filter(max == 1)

  # item_spearman 
  
  # item_tetra

sb_assessment <- statsBy(temp_wide[,-c(1)], group = temp_wide$instrument_title, 
                         use = "pairwise", method = "spearman",
                         cors = TRUE)



# Scores & Age Correlation ----
#Find the correlations between BBTB scores and age (Hugh should have the score file)


# Run the DP4 cors -----
#Correlation the growth scale values with BBTB scores
dryRun_dp4 %>% 
  count(child_id) %>% 
  filter(n >1) ## DRMIN035 shows up here too

# Assessment Times ----
# Find the assessment times of each battery



