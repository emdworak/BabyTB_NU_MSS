# Load the relevant libraries --------------------------
library(psych)
library(psychTools)
library(tidyverse)
library(janitor)
library(readxl)
library(ggpubr)
library(kableExtra)
library(writexl)

setwd("~/Desktop/MSS/BabyTB/BabyTB_Github/BabyTB_NU_MSS/dry_run")

# Load the functions and data --------------------------
`%nin%` <- Negate(`%in%`)

## Load in the score data 
dryRun_ScoreExportNarrow <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_ScoreExportNarrow_20230323.csv") %>% 
  janitor::clean_names()

# dim(dryRun_ScoreExportNarrow)
# colnames(dryRun_ScoreExportNarrow)

## Load in the item data 
dryRun_ItemExportNarrow <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_ItemExportNarrow_20230323.csv") %>%
  janitor::clean_names()

# dim(dryRun_ItemExportNarrow)
# colnames(dryRun_ItemExportNarrow)

## Load in the age data 
dryRun_Registration_Age <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_Registration_Age_20230323.csv") %>% 
  janitor::clean_names()

# dim(dryRun_Registration_Age)
# colnames(dryRun_Registration_Age)

## Load in the DP4 data 
dryRun_dp4 <- read_csv("/Volumes/fsmresfiles/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/dryRun_DP4_20230323.csv") %>% 
  janitor::clean_names()

# dim(dryRun_dp4) 
# colnames(dryRun_dp4)

# These are the IDs we care about for analysis
ids_for_analysis <- read_csv("data/2023-03-22T172307_shouldHavecorrected2.csv") %>% 
  rename(PIN = PINsago)

# dim(ids_for_analysis)

analysis_ids <- ids_for_analysis %>% 
  pull(PIN)

# Transform the data ------
scores_long_df <- dryRun_ScoreExportNarrow %>% 
  filter(pin %in% analysis_ids) 

scores_long_age_df <- full_join(scores_long_df, dryRun_Registration_Age, 
                                by = c("pin", "pid", "registration_id", "assessment_name"),
                                multiple = "all")


## Pivot the data ----
scores_pivot <- scores_long_age_df %>% 
  filter(!is.na(instrument_title)) %>% 
  filter(key %nin% c("Language", "InstrumentSandSReason", 
                     "InstrumentRCReasonOther", "InstrumentBreakoff",
                     "InstrumentStatus2")) %>% 
  pivot_wider(id_cols = c(pin, #pid, registration_id,
                          #assessment_name, #instrument_title,
                          total_age_in_months),
              names_from = c("test_name", "key"),
              values_from = "value") %>% 
  select(pin:total_age_in_months, everything()) %>% 
  type_convert() %>% 
  full_join(., dryRun_dp4, 
            by = "pin") %>% 
  select(-c(child_id, age, gender, age_at_testing, administration_form_id)) %>% 
  janitor::clean_names()

## Limit the data ----
social_obs_df <- scores_pivot %>% 
  select(-c(ends_with("item_count"), 
            social_observation_social_communication1, 
            social_observation_social_communication2)) %>%
  select(total_age_in_months, starts_with("growth"),
         starts_with("social_observation"),
         starts_with("cbq"),
         starts_with("caregiver"),
         starts_with("ibq"),
         promis_peer_t_score,
         promis_caregiver_t_score
  ) %>% 
  rename(age = total_age_in_months)


# Request 1 -----
## Part 1 ----
### i) SOM subscale scores and Caregiver checklist (CC) Raw scores 

### Part 1a ----
#### 1.	SOM younger and CC 6-11 months; CC 12-17 months; CC 18-23 months
temp <- social_obs_df %>% 
  filter(between(age, 9, 11)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), starts_with("shares"), play) %>% 
  cor(., use = "pairwise", method = "spearman") 

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMy_CC_9_11mo_subscales.xlsx")


temp <- social_obs_df %>% 
  filter(between(age, 12, 17)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), starts_with("shares"), play) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMy_CC_12_17mo_subscales.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 18, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), starts_with("shares"), play) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMy_CC_18_23mo_subscales.xlsx")

### Part 1b ----
#### 2.	SOM Older and CC 24-29 months; CC 30-35 months; CC 36-41 months; CC 42-48 months
temp <- social_obs_df %>% 
  filter(between(age, 24, 29)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum
  ) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_24_29mo_subscales.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 30, 35)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum
  ) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_30_35mo_subscales.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 36, 41)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum
  ) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_36_41mo_subscales.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 42, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("caregiver_checklist"), joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum
  ) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_42_48mo_subscales.xlsx")

## Part 2 ----
### ii) SOM Total scores and Caregiver checklist (CC) Raw scores; (please do separate matrices for subscales and Total scores)

### Part 2a ----
#### 1.	SOM younger and CC 6-11 months; CC 12-17 months; CC 18-23 months
temp <- social_obs_df %>% 
  filter(between(age, 9, 11)) %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMy_CC_9_11mo_total.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 12, 17)) %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>%  
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMy_CC_12_17mo_total.xlsx")


temp <- social_obs_df %>% 
  filter(between(age, 18, 23)) %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>%  
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMy_CC_18_23mo_total.xlsx")


### Part 2b ----
#### 2.	SOM Older and CC 24-29 months; CC 30-35 months; CC 36-41 months; CC 42-48 months
temp <- social_obs_df %>% 
  filter(between(age, 24, 29))  %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>%  
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_24_29mo_total.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 30, 35))  %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>%  
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_30_35mo_total.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 36, 41))  %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>%  
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_36_41mo_total.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 42, 48))  %>% 
  select(starts_with("caregiver_checklist"), social_observation_total) %>%  
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r1_SOMo_CC_42_48mo_total.xlsx")

# Request 2 -----
## Part 1 ----
### i) SOM subscale scores and PROMIS 13-42 months (T scores) 

### Part 1a ----
#### 1. SOM younger and SOM older with PROMIS EC Parent-Report SF v1.0 - Social Relationships - Child- Caregiver Interactions 5a
temp <- social_obs_df %>% 
  filter(between(age, 13, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>%
  select(promis_caregiver_t_score, starts_with("shares"), play) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMy_PROMIS_SR_CI_13_23mo_subscale.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 24, 42)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>%
  select(promis_caregiver_t_score, joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMo_PROMIS_SR_CI_24_42mo_subscale.xlsx")

### Part 1b ----
#### 2.	SOM younger and SOM older with PROMIS EC Parent-Report SF v1.0 - Social Relationships - Peer Relationships 4a
temp <- social_obs_df %>% 
  filter(between(age, 13, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>%
  select(promis_peer_t_score, starts_with("shares"), play) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMy_PROMIS_SR_Peer_13_23mo_subscale.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 24, 42)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>%
  select(promis_peer_t_score, joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMo_PROMIS_SR_Peer_24_42mo_subscale.xlsx")

## Part 2 ----
### ii) SOM Total scores and PROMIS 13-42 months (T scores)

### Part 2a ----
#### 1. SOM younger and SOM older with PROMIS EC Parent-Report SF v1.0 - Social Relationships - Child- Caregiver Interactions 5a
temp <- social_obs_df %>% 
  filter(between(age, 13, 23)) %>% 
  select(promis_caregiver_t_score, social_observation_total) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMy_PROMIS_SR_CI_13_23mo_total.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 24, 42)) %>% 
  select(promis_caregiver_t_score, social_observation_total) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMo_PROMIS_SR_CI_24_42mo_total.xlsx")

### Part 2b ----
#### 2.	SOM younger and SOM older with PROMIS EC Parent-Report SF v1.0 - Social Relationships - Peer Relationships 4a
temp <- social_obs_df %>% 
  filter(between(age, 13, 23)) %>% 
  select(promis_peer_t_score, social_observation_total) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMy_PROMIS_SR_Peer_13_23mo_total.xlsx")

temp <- social_obs_df %>% 
  filter(between(age, 24, 42)) %>% 
  select(promis_peer_t_score, social_observation_total) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r2_SOMo_PROMIS_SR_Peer_24_42mo_total.xlsx")

# Request 3 -----
## Part 1 ----
### i) SOM subscale scores and Temperament measures Raw scores;  

### Part 1a ----
#### 1.	SOM Younger and Infant Behavior Questionnaire (3-12 months)
temp <- social_obs_df %>% 
  filter(between(age, 9, 12)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  select(starts_with("ibq"), starts_with("shares"), play) %>% 
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r3_SOMy_IBQ_9_12mo_subscale.xlsx")

### Part 1b ----
#### 2.	SOM Younger and Early Childhood Behavior Questionnaire (13-36 months)

### ECB was not administered during dry run

### Part 1c ----
#### 3.	SOM Older and Early Childhood Behavior Questionnaire (13-36 months)

### ECB was not administered during dry run

### Part 1d ----
#### 4.	SOM Older and Children’s Behavior Questionnaire (37-42 months)

temp <- social_obs_df %>%
  filter(between(age, 37, 42)) %>%
  rename_with(stringr::str_replace,
              pattern = "social\\_observation\\_", replacement = "",
              matches("social\\_observation\\_")) %>%
  select(starts_with("cbq"), joint_attention,
         pretend_play, prosocial_behavior, social_communication_sum) %>%
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r3_SOMo_CBQ_37_42mo_subscale.xlsx")

## Part 2 ----
### ii)SOM Total scores and Temperament measures Raw scores

### Part 2a ----
#### 1.	SOM Younger and Infant Behavior Questionnaire (3-12 months)
temp <- social_obs_df %>% 
  filter(between(age, 3, 12)) %>% 
  select(starts_with("ibq"), social_observation_total) %>% 
  cor(., use = "pairwise", method = "spearman")


temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r3_SOMy_IBQ_9_12mo_total.xlsx")

### Part 2b ----
#### 2.	SOM Younger and Early Childhood Behavior Questionnaire (13-36 months)

### ECB was not administered during dry run

### Part 2c ----
#### 3.	SOM Older and Early Childhood Behavior Questionnaire (13-36 months)

### ECB was not administered during dry run

### Part 2d ----
#### 4.	SOM Older and Children’s Behavior Questionnaire (37-42 months)

temp <- social_obs_df %>%
  filter(between(age, 37, 42)) %>%
  select(starts_with("cbq"), social_observation_total) %>%
  cor(., use = "pairwise", method = "spearman")

temp <- data.frame(n = colnames(temp), temp)
rownames(temp) <- NULL

write_xlsx(temp, "output/SOM_output/r3_SOMo_CBQ_37_42mo_total.xlsx")

# Request 4 ------
## 4.	Scatterplots of correlations 

## Part 1 ------
### a.	Between SOM Younger subscales: SharesAttention, SharesEnjoyment, SharesInterests, Play 

# social_obs_df %>% 
#   filter(between(age, 9, 23)) %>% 
#   rename_with(stringr::str_replace, 
#               pattern = "social\\_observation\\_", replacement = "", 
#               matches("social\\_observation\\_")) %>% 
#   select(starts_with("shares"), play) %>% 
#   pairs.panels()


social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_attention, y = shares_enjoyment)) +
    geom_point() +
    geom_smooth(method = "lm") +
  labs(title = "SOM Younger subscales",
       x = "Shares Attention",
       y = "Shares Enjoyment") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,17), breaks = seq(0,17,2),
                     labels = seq(0,17,2))+ 
  scale_y_continuous(limits = c(0,20), breaks = seq(0,20,2),
                     labels = seq(0,20,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_attention, y = shares_interests)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Younger subscales",
       x = "Shares Attention",
       y = "Shares Interests") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,17), breaks = seq(0,17,2),
                     labels = seq(0,17,2))+ 
  scale_y_continuous(limits = c(0,20), breaks = seq(0,20,2),
                     labels = seq(0,20,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_attention, y = play)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Younger subscales",
       x = "Shares Attention",
       y = "Play") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,17), breaks = seq(0,17,2),
                     labels = seq(0,17,2))+ 
  scale_y_continuous(limits = c(0,20), breaks = seq(0,20,2),
                     labels = seq(0,20,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_interests, y = shares_enjoyment)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Younger subscales",
       x = "Shares Interests",
       y = "Shares Enjoyment") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,17), breaks = seq(0,17,2),
                     labels = seq(0,17,2))+ 
  scale_y_continuous(limits = c(0,20), breaks = seq(0,20,2),
                     labels = seq(0,20,2))



social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_interests, y = play)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Younger subscales",
       x = "Shares Interests",
       y = "Play") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,17), breaks = seq(0,17,2),
                     labels = seq(0,17,2))+ 
  scale_y_continuous(limits = c(0,20), breaks = seq(0,20,2),
                     labels = seq(0,20,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_enjoyment, y = play)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Younger subscales",
       x = "Shares Enjoyment",
       y = "Play") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,17), breaks = seq(0,17,2),
                     labels = seq(0,17,2))+ 
  scale_y_continuous(limits = c(0,20), breaks = seq(0,20,2),
                     labels = seq(0,20,2))


## Part 2 ------
### b.	Between SOM Older Subscales: JointAttention,  PretendPlay, ProsocialBehavior, SocialCommunicationSum 


# social_obs_df %>%
#   filter(between(age, 24, 48)) %>%
#   rename_with(stringr::str_replace,
#               pattern = "social\\_observation\\_", replacement = "",
#               matches("social\\_observation\\_")) %>%
#   select(joint_attention, pretend_play, prosocial_behavior, social_communication_sum) %>%
#   pairs.panels()


social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = joint_attention, y = prosocial_behavior)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Older subscales",
       x = "Joint Attention",
       y = "Prosocial Behavior") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))+ 
  scale_y_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = joint_attention, y = social_communication_sum)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Older subscales",
       x = "Joint Attention",
       y = "Social Communication (sum)") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))+ 
  scale_y_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = joint_attention, y = pretend_play)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Older subscales",
       x = "Joint Attention",
       y = "Pretend Play") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))+ 
  scale_y_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = social_communication_sum, y = prosocial_behavior)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Older subscales",
       x = "Social Communication (sum)",
       y = "Prosocial Behavior") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))+ 
  scale_y_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))



social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = social_communication_sum, y = pretend_play)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Older subscales",
       x = "Social Communication (sum)",
       y = "Pretend Play") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))+ 
  scale_y_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = prosocial_behavior, y = pretend_play)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "SOM Older subscales",
       x = "Prosocial Behavior",
       y = "Pretend Play") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) + 
  scale_x_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))+ 
  scale_y_continuous(limits = c(0,8), breaks = seq(0,8,2),
                     labels = seq(0,8,2))



# Request 5 ------

# 5.	Age distributions of total scores
## a.	Caregiver checklists
social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  select(starts_with("caregiver_checklist")) %>% 
  ggplot(mapping = aes(x = caregiver_checklist_raw_score)) +
    geom_histogram()  +
  labs(title = "Distribution of CC Scores (9-23 months)",
       x = "Caregiver Checklist (Raw score)",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))


social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  select(starts_with("caregiver_checklist")) %>% 
  ggplot(mapping = aes(x = caregiver_checklist_raw_score)) +
  geom_histogram()  +
  labs(title = "Distribution of CC Scores (24-48 months)",
       x = "Caregiver Checklist (Raw score)",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))



## b.	SOMs
### Younger
social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
ggplot(mapping = aes(x = shares_attention)) +
  geom_histogram()  +
  labs(title = "Distribution of Shares Attention Scores (9-23 months)",
       x = "Shares Attention",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_enjoyment)) +
  geom_histogram()  +
  labs(title = "Distribution of Shares Enjoyment Scores (9-23 months)",
       x = "Shares Enjoyment",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = shares_interests)) +
  geom_histogram()  +
  labs(title = "Distribution of Shares Interests Scores (9-23 months)",
       x = "Shares Interests",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = play)) +
  geom_histogram()  +
  labs(title = "Distribution of Play Scores (9-23 months)",
       x = "Play",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = total)) +
  geom_histogram()  +
  labs(title = "Distribution of SOM Total Scores (9-23 months)",
       x = "Total",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,55,2), labels = seq(0,55,2))


### Older

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = joint_attention)) +
  geom_histogram()  +
  labs(title = "Distribution of Joint Attention Scores (24-48 months)",
       x = "Joint Attention",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = prosocial_behavior)) +
  geom_histogram()  +
  labs(title = "Distribution of Prosocial Behavior Scores (24-48 months)",
       x = "Prosocial Behavior",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = social_communication_sum)) +
  geom_histogram()  +
  labs(title = "Distribution of Social Communication (sum) Scores (24-48 months)",
       x = "Social Communication (sum)",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = pretend_play)) +
  geom_histogram()  +
  labs(title = "Distribution of Pretend Play Scores (24-48 months)",
       x = "Pretend Play",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,48,2), labels = seq(0,48,2))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "social\\_observation\\_", replacement = "", 
              matches("social\\_observation\\_")) %>% 
  ggplot(mapping = aes(x = total)) +
  geom_histogram()  +
  labs(title = "Distribution of SOM Total Scores (24-48 months)",
       x = "Total",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(0,55,2), labels = seq(0,55,2))


## c.	DP4
### Younger
social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = physical)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Physical Growth Scores (9-23 months)",
       x = "DP4 Physical Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = adaptive_behavior)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Adaptive Behavior Growth Scores (9-23 months)",
       x = "DP4 Adaptive Behavior Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = social_emotional)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Social Emotional Growth Scores (9-23 months)",
       x = "DP4 Social Emotional Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = cognitive)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Cognitive Growth Scores (9-23 months)",
       x = "DP4 Cognitive Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 9, 23)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = communication)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Communication Growth Scores (9-23 months)",
       x = "DP4 Communication Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))


### Older

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = physical)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Physical Growth Scores (24-48 months)",
       x = "DP4 Physical Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = adaptive_behavior)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Adaptive Behavior Growth Scores (24-48 months)",
       x = "DP4 Adaptive Behavior Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = social_emotional)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Social Emotional Growth Scores (24-48 months)",
       x = "DP4 Social Emotional Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = cognitive)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Cognitive Growth Scores (24-48 months)",
       x = "DP4 Cognitive Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))


social_obs_df %>% 
  filter(between(age, 24, 48)) %>% 
  rename_with(stringr::str_replace, 
              pattern = "growth\\_", replacement = "", 
              matches("growth\\_")) %>% 
  ggplot(mapping = aes(x = communication)) +
  geom_histogram()  +
  labs(title = "Distribution of DP4 Communication Growth Scores (24-48 months)",
       x = "DP4 Communication Growth Score",
       y = "Count") +
  theme_bw() +
  theme(axis.text.x = element_text(size=14),
        axis.text.y = element_text(size=14),
        axis.title.x = element_text(size=16),
        axis.title.y = element_text(size=16),
        plot.title = element_text(hjust = 0.5,
                                  size = 18),
        strip.text.x = element_text(size = 16)
  ) +
  scale_x_continuous(breaks = seq(200,625,25), labels = seq(200,625,25))

