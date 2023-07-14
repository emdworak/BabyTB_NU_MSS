
library(tidyverse)
library(arrow)

fileList <- list.files("R:/MSS/Research/Projects/Baby_Toolbox/MediaReviewOutput/code/Reports",
                       pattern = ".parq")

NBT_dataLink <- open_dataset(paste("R:/MSS/Research/Projects/Baby_Toolbox/MediaReviewOutput/code/Reports",
                                   fileList[1], sep="/"))
NBT_dataLink # view schema

NBT_dataLink |>
  count(InstrumentTitle) |>
  collect() |>
  print(n=100) # more than we need, but see all instruments

checkSpeededMatching <- NBT_dataLink |>
  filter(str_detect(InstrumentTitle, "Speeded")) |>
  collect() 

checkSpeededMatching

checkSpeededMatching_wide <- checkSpeededMatching |>
  select(-`__index_level_0__`) |>
  filter(Key %in% c("Response", "Score")) |>
  pivot_wider(names_from = c(ItemID, Key), values_from = Value)
# this seems to work, but requires higher filtering than we'd like.

checkSpeededMatching_wide2 <- checkSpeededMatching |>
  select(-`__index_level_0__`, -TestName) |>
  pivot_wider(names_from = c(ItemID, Key), values_from = Value) |>
  select_if(function(x){sum(!is.na(x)) > 0}) # this still gives multiple rows per person
