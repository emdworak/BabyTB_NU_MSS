library(tidyverse)
library(jsonlite)

#### Get Data ####

set1 <- read_json("./GazeChecking/AssessmentGazeData_2023-05-03T224707.json", simplifyVector = TRUE)
set2 <- read_json("./GazeChecking/AssessmentGazeData_2023-05-05T011125.json", simplifyVector = TRUE)

#### Set 1 ####

sapply(set1, dim) # 13 columns but some are sub-pairs

set1_dataPairs <- lapply(set1, \(x){ x$dataPairs })
set1_mainData <- lapply(set1, \(x){ as_tibble(x) |> select(-dataPairs)} )

sapply(set1_dataPairs, dim) # 10 columns
sapply(set1_mainData, dim) # 12 columns

set1_dataPairs <- set1_dataPairs %>%
  bind_rows(.id="setOrder") %>%
  filter(!is.na(registrationID))

set1_allData <- set1_mainData %>%
  bind_rows(.id="setOrder")

set1_allData <- set1_allData[,colSums(is.na(set1_allData))<nrow(set1_allData)]

set1_faceVertices <- set1_allData %>%
  filter(eventName == "faceVerticesChanged")

set1_faceVertices |>
  count(setOrder) # similar, but different by up to 17

set1_faceVertices <- set1_faceVertices |>
  group_by(setOrder) |>
  mutate(catchN = row_number()) |>
  ungroup()

set1_faceVertices_wide <- set1_faceVertices |>
  select(setOrder, catchN, lookAtPointX, lookAtPointY) |>
  pivot_longer(cols = c(lookAtPointX, lookAtPointY)) |>
  pivot_wider(id_cols=catchN, names_from = c(setOrder, name), values_from = value)

set1_faceVertices_wide |>
  select(ends_with("PointX")) |>
  (\(x){irr::icc(x, model="oneway", type="agreement", unit="average")})() # left-right values

set1_faceVertices_wide |>
  select(ends_with("PointY")) |>
  (\(x){irr::icc(x, model="oneway", type="agreement", unit="average")})() # top-bottom values

apply(set1_faceVertices_wide[,str_detect(colnames(set1_faceVertices_wide),"PointX")],
      1,
      function(x) max(c(dist(as.vector(x))))) |>
  quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T) |>
  round(3)


apply(set1_faceVertices_wide[,str_detect(colnames(set1_faceVertices_wide),"PointY")],
      1,
      function(x) max(c(dist(as.vector(x))))) |>
  quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T) |>
  round(3)

#### Set 2 ####

sapply(set2, dim) # 13 columns but some are sub-pairs

set2_dataPairs <- lapply(set2, \(x){ x$dataPairs })
set2_mainData <- lapply(set2, \(x){ as_tibble(x) |> select(-dataPairs)} )

sapply(set2_dataPairs, dim) # 10 columns
sapply(set2_mainData, dim) # 12 columns

set2_dataPairs <- set2_dataPairs %>%
  bind_rows(.id="setOrder") %>%
  filter(!is.na(registrationID))

set2_allData <- set2_mainData %>%
  bind_rows(.id="setOrder")

set2_allData <- set2_allData[,colSums(is.na(set2_allData))<nrow(set2_allData)]

set2_faceVertices <- set2_allData %>%
  filter(eventName == "faceVerticesChanged")

set2_faceVertices |>
  count(setOrder) # similar, but different by up to 74

set2_faceVertices <- set2_faceVertices |>
  group_by(setOrder) |>
  mutate(catchN = row_number()) |>
  ungroup()

set2_faceVertices_wide <- set2_faceVertices |>
  select(setOrder, catchN, lookAtPointX, lookAtPointY) |>
  pivot_longer(cols = c(lookAtPointX, lookAtPointY)) |>
  pivot_wider(id_cols=catchN, names_from = c(setOrder, name), values_from = value)

set2_faceVertices_wide |>
  select(ends_with("PointX")) |>
  (\(x){irr::icc(x, model="oneway", type="agreement", unit="average")})() # left-right values

set2_faceVertices_wide |>
  select(ends_with("PointY")) |>
  (\(x){irr::icc(x, model="oneway", type="agreement", unit="average")})() # top-bottom values

apply(set2_faceVertices_wide[,str_detect(colnames(set2_faceVertices_wide),"PointX")],
      1,
      function(x) max(c(dist(as.vector(x))))) |>
  quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T) |>
  round(3)


apply(set2_faceVertices_wide[,str_detect(colnames(set2_faceVertices_wide),"PointY")],
      1,
      function(x) max(c(dist(as.vector(x))))) |>
  quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T) |>
  round(3)

#### Contrast to Live Data - set 1 ####

set1_original <- read_json("./GazeChecking/set1_original.json", simplifyVector = TRUE)

set1_original_dataPairs <- lapply(set1_original, \(x){ x$dataPairs })
set1_original_allData <- lapply(set1_original, \(x){ as_tibble(x) |> select(-dataPairs)} ) %>%
  bind_rows()

sapply(set1_original_dataPairs, dim) # 10 columns

set1_original_dataPairs <- set1_original_dataPairs %>%
  bind_rows(.id="setOrder") %>%
  filter(!is.na(registrationID))

set1_original_allData <- set1_original_allData[,colSums(is.na(set1_original_allData))<nrow(set1_original_allData)]

set1_original_faceVertices <- set1_original_allData |>
  bind_rows() |>
  filter(eventName == "faceVerticesChanged") |>
  mutate(catchN = row_number()) |>
  select(catchN, lookAtPointX, lookAtPointY)

set1_wideComp <- set1_original_faceVertices |>
  left_join(set1_faceVertices_wide, by="catchN") |>
  mutate(xDiff1 = `1_lookAtPointX` - lookAtPointX,
         xDiff2 = `2_lookAtPointX` - lookAtPointX,
         xDiff3 = `3_lookAtPointX` - lookAtPointX,
         xDiff4 = `4_lookAtPointX` - lookAtPointX,
         xDiff5 = `5_lookAtPointX` - lookAtPointX,
         xDiff6 = `6_lookAtPointX` - lookAtPointX,
         xDiff7 = `7_lookAtPointX` - lookAtPointX,
         xDiff8 = `8_lookAtPointX` - lookAtPointX,
         xDiff9 = `9_lookAtPointX` - lookAtPointX,
         xDiff10 = `10_lookAtPointX` - lookAtPointX,
         yDiff1 = `1_lookAtPointY` - lookAtPointY,
         yDiff2 = `2_lookAtPointY` - lookAtPointY,
         yDiff3 = `3_lookAtPointY` - lookAtPointY,
         yDiff4 = `4_lookAtPointY` - lookAtPointY,
         yDiff5 = `5_lookAtPointY` - lookAtPointY,
         yDiff6 = `6_lookAtPointY` - lookAtPointY,
         yDiff7 = `7_lookAtPointY` - lookAtPointY,
         yDiff8 = `8_lookAtPointY` - lookAtPointY,
         yDiff9 = `9_lookAtPointY` - lookAtPointY,
         yDiff10 = `10_lookAtPointY` - lookAtPointY)


bind_rows(apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                2,
                function(x) IQR(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
          apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                2,
                function(x) median(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
          apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                2,
                function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
          apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                2,
                function(x) max(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
          .id="Prob") 

bind_rows(apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                2,
                function(x) IQR(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
          apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                2,
                function(x) median(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
          apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                2,
                function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
          apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                2,
                function(x) max(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
          .id="Prob") 

#### Contrast to Live Data - set 2 ####

set2_original <- read_json("./GazeChecking/set2_original.json", simplifyVector = TRUE)

set2_original_dataPairs <- lapply(set2_original, \(x){ x$dataPairs })
set2_original_allData <- lapply(set2_original, \(x){ as_tibble(x) |> select(-dataPairs)} ) %>%
  bind_rows()

sapply(set2_original_dataPairs, dim) # 10 columns

set2_original_dataPairs <- set2_original_dataPairs %>%
  bind_rows(.id="setOrder") %>%
  filter(!is.na(registrationID))

set2_original_allData <- set2_original_allData[,colSums(is.na(set2_original_allData))<nrow(set2_original_allData)]

set2_original_faceVertices <- set2_original_allData |>
  bind_rows() |>
  filter(eventName == "faceVerticesChanged") |>
  mutate(catchN = row_number()) |>
  select(catchN, lookAtPointX, lookAtPointY)

set2_wideComp <- set2_original_faceVertices |>
  left_join(set2_faceVertices_wide, by="catchN") |>
  mutate(xDiff1 = `1_lookAtPointX` - lookAtPointX,
         xDiff2 = `2_lookAtPointX` - lookAtPointX,
         xDiff3 = `3_lookAtPointX` - lookAtPointX,
         xDiff4 = `4_lookAtPointX` - lookAtPointX,
         xDiff5 = `5_lookAtPointX` - lookAtPointX,
         xDiff6 = `6_lookAtPointX` - lookAtPointX,
         xDiff7 = `7_lookAtPointX` - lookAtPointX,
         xDiff8 = `8_lookAtPointX` - lookAtPointX,
         xDiff9 = `9_lookAtPointX` - lookAtPointX,
         xDiff10 = `10_lookAtPointX` - lookAtPointX,
         yDiff1 = `1_lookAtPointY` - lookAtPointY,
         yDiff2 = `2_lookAtPointY` - lookAtPointY,
         yDiff3 = `3_lookAtPointY` - lookAtPointY,
         yDiff4 = `4_lookAtPointY` - lookAtPointY,
         yDiff5 = `5_lookAtPointY` - lookAtPointY,
         yDiff6 = `6_lookAtPointY` - lookAtPointY,
         yDiff7 = `7_lookAtPointY` - lookAtPointY,
         yDiff8 = `8_lookAtPointY` - lookAtPointY,
         yDiff9 = `9_lookAtPointY` - lookAtPointY,
         yDiff10 = `10_lookAtPointY` - lookAtPointY)


bind_rows(apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                2,
                function(x) IQR(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
          apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                2,
                function(x) median(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
          apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                2,
                function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
          apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                2,
                function(x) max(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
          .id="Prob") 

bind_rows(apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                2,
                function(x) IQR(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
          apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                2,
                function(x) median(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
          apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                2,
                function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
          apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                2,
                function(x) max(abs(x),na.rm=T)) %>%
            quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
          .id="Prob") 


#### All Comparisons ####


SummaryDifferences <- bind_rows(
  bind_rows(apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                  2,
                  function(x) IQR(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
            apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                  2,
                  function(x) median(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
            apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                  2,
                  function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
            apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"xDiff")],
                  2,
                  function(x) max(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
            .id="Prob"),
  bind_rows(apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                  2,
                  function(x) IQR(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
            apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                  2,
                  function(x) median(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
            apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                  2,
                  function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
            apply(set1_wideComp[,str_detect(colnames(set1_wideComp),"yDiff")],
                  2,
                  function(x) max(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
            .id="Prob"),
  bind_rows(apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                  2,
                  function(x) IQR(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
            apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                  2,
                  function(x) median(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
            apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                  2,
                  function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
            apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"xDiff")],
                  2,
                  function(x) max(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
            .id="Prob"),
  bind_rows(apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                  2,
                  function(x) IQR(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # Inter-Quantile Range
            apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                  2,
                  function(x) median(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T), # median difference
            apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                  2,
                  function(x) quantile(abs(x), probs=.75,na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # 75th percentile difference
            apply(set2_wideComp[,str_detect(colnames(set2_wideComp),"yDiff")],
                  2,
                  function(x) max(abs(x),na.rm=T)) %>%
              quantile(probs=c(0,.05,.1,.25,.5,seq(.75,1,.05)),na.rm=T),  # maximum difference
            .id="Prob"),
  .id="Comparison") %>%
  mutate(Comparison = case_when(Comparison == 1 ~ "Set 1 lookAtPointX",
                                Comparison == 2 ~ "Set 1 lookAtPointY",
                                Comparison == 3 ~ "Set 2 lookAtPointX",
                                Comparison == 4 ~ "Set 2 lookAtPointY"),
         Prob = case_when(Prob == 1 ~ "IQR",
                          Prob == 2 ~ "Median",
                          Prob == 3 ~ "75th Percentile",
                          Prob == 4 ~ "Maximum")) %>%
  rename(Minimum = `0%`, Perc5 = `5%`, Perc10 = `10%`, Perc25 = `25%`, Perc50 = `50%`,
         Perc75 = `75%`, Perc80 = `80%`, Perc85 = `85%`, Perc90 = `90%`, Perc95 = `95%`, Maximum = `100%`)

SummaryDifferences
