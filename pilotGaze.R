
library(tidyverse)
library(jsonlite)

miscFolder <- list.files("R:/MSS/Research/Projects/Baby_Toolbox/NBT_Norming_2023/misc", pattern="json")

allJSON <- lapply(miscFolder, function(y) read_json(paste0("R:/MSS/Research/Projects/Baby_Toolbox/NBT_Norming_2023/misc/",y),
                                                    simplifyVector = FALSE))

tmp <- bind_rows(lapply(allJSON[[1]][[1]], function(y) as_tibble(t(unlist(y))))) %>% mutate(fileName = miscFolder[1])

# this is a mess and will take  along time to run, but it will prevent problems.
for(k in 2:length(allJSON)){
  for(m in 1:length(allJSON[[k]])){
    tmp <- bind_rows(tmp, bind_rows(lapply(allJSON[[k]][[m]], function(y) as_tibble(t(unlist(y))))) %>% mutate(fileName = miscFolder[k]))
  }
}

table(tmp$fileName)

saveRDS(tmp, "DryRunGaze.rds")

#### Pick up here ####

gazeRecords <- readRDS("DryRunGaze.rds")

gazeRecords <- gazeRecords %>%
  mutate(instrument_calc = case_when(str_detect(itemID, "Mem|Hab|EXF|EFX|VDR") ~ "ExecutiveFunctioning",
                                     str_detect(itemID, "_G|LWL") ~ "LookingWhileListening",
                                     str_detect(itemID, "NCD") ~ "NumericalChange",
                                     str_detect(itemID, "SCD") ~ "SpatialChange",
                                     itemID %in% paste0("Filler",1:9) ~ "LookingWhileListening",
                                     TRUE ~ "Other")) # should be no `Other`

gazeRecords_data <- gazeRecords %>%
  filter(eventName == "data") %>%
  pivot_wider(id_cols=c(fileName, instrument_calc),
              names_from=dataKey, values_from=dataValue, values_fn = 'min')

gazeRecords_v2 <- gazeRecords %>%
  filter(eventName != "data") %>%
  left_join(gazeRecords_data, by=c('fileName', 'instrument_calc')) %>%
  select(fileName, instrument, registrationID, userPIN, assessmentName,
         elapsedTime, itemID, gazeEngineState, eventName, lookAtPointX, lookAtPointY,
         gazeLocationOnScreen, gazeLocationName, calibrationFocalPoint, 
         dataValue.averageX, dataValue.averageY, dataKey, dataValue, cameraImageFilename,
         arFramesPerSecond_calibration_actual, arFramesPerSecond_test_actual,
         cameraFramesPerSecond_calibration_actual, cameraFramesPerSecond_test_actual,
         everything())

endCalibrationRows <- which(gazeRecords_v2$eventName == "completedCalibration")
lastEvent <- endCalibrationRows - 1

gazeRecords_v2 %>% 
  slice(lastEvent) %>%
  select(2,4,6,7,8,9) %>%
  print(n=50)

summary_x1 <- gazeRecords_v2 %>% 
  slice(lastEvent) %>%
  filter(fileName != "2023-03-08 17.20.28 Assessment Gaze Data.json" &
           userPIN != "drorl002") %>% # prevent a double-upload issue 
  pivot_wider(id_cols=c(userPIN, registrationID), names_from=instrument, values_from = eventName)

summary_x2 <- gazeRecords_v2 %>% 
  slice(lastEvent) %>%
  filter(userPIN == "drorl002") %>%
  pivot_wider(id_cols=c(userPIN, registrationID, elapsedTime), names_from=instrument, values_from = eventName)
summary_x2[1,5:7] <- c(summary_x2[3,5],summary_x2[4,6], summary_x2[7,7])
summary_x2[2,5:6] <- c(summary_x2[6,5],summary_x2[5,6])
summary_x2 <- summary_x2[1:2,]

gazeSummary <- bind_rows(summary_x1, summary_x2 %>% select(-elapsedTime))

apply(gazeSummary[,3:6], 2, table, useNA='ifany')
