library(tidyverse)

fileList <- list.files("R:/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/")

scoresNarrow <- read_csv(paste0("R:/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/",
                                fileList[which(str_detect(fileList, "ScoreExport"))]))


scoresNarrow %>%
  count(InstrumentTitle) %>%
  print(n=50)


socialData <- scoresNarrow %>%
  filter(InstrumentTitle %in% c("Caregiver Checklist", "Social Observation")) %>%
  pivot_wider(id_cols=PIN:InstrumentTitle, names_from = Key, values_from = Value) %>%
  filter(InstrumentBreakoff == 2) %>%
  pivot_longer(cols=8:25, names_to = 'Key', values_to = 'Value') %>%
  filter(!Key %in% c("Language","ItemCount","InstrumentStatus2", "InstrumentBreakoff",
                     "InstrumentRCReasonOther","InstrumentSandSReason",
                     "SocialCommunication1","SocialCommunication2") &
           !is.na(Value)) %>%
  type_convert()

#### Score Summary ####

socialData_summary <- socialData %>%
  filter(Key != "Total") %>%
  group_by(TestName, Key) %>%
  summarise(N=n(),
            mean=mean(Value,na.rm=T),
            sd=sd(Value,na.rm=T),
            median=median(Value,na.rm=T),
            min=min(Value,na.rm=T),
            max=max(Value,na.rm=T))

#### Score Histograms ####

library(patchwork)

caregiverChecklist <- socialData %>%
  filter(TestName == "CaregiverChecklist") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,50,2.5)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Caregiver Checklist")

socObs1a <- socialData %>%
  filter(Key == "JointAttention") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,6,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Joint Attention")

socObs1b <- socialData %>%
  filter(Key == "Play") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,20,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Play")

socObs1c <- socialData %>%
  filter(Key == "PretendPlay") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,5,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Pretend Play")

socObs1d <- socialData %>%
  filter(Key == "ProsocialBehavior") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,6,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Prosocial Behavior")

socPlot1 <- ( socObs1a + socObs1b ) / ( socObs1c + socObs1d ) + 
  plot_annotation(title="Social Observation Younger")



socObs2a <- socialData %>%
  filter(Key == "SharesAttention") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,16,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Shares Attention")

socObs2b <- socialData %>%
  filter(Key == "SharesEnjoyment") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,11,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Shares Enjoyment")

socObs2c <- socialData %>%
  filter(Key == "SharesInterests") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,12,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Shares Interests")

socObs2d <- socialData %>%
  filter(Key == "SocialCommunicationSum") %>%
  ggplot(aes(x=Value)) + geom_histogram(breaks=seq(0,9,1)) + 
  xlab("Raw Score") + ylab("Count") + ggtitle("Social Communication Combined")

socPlot2 <- ( socObs2a + socObs2b ) / ( socObs2c + socObs2d ) + 
  plot_annotation(title="Social Observation Older")

ggsave("caregiverChecklistHist.png", caregiverChecklist, device='png', dpi=300)
ggsave("SocObsYoungerHist.png", socPlot1, device='png', dpi=300)
ggsave("SocObsOlderHist.png", socPlot2, device='png', dpi=300)

#### Scores and Other Variables ####


regAge <- read_csv(paste0("R:/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/",
                          fileList[which(str_detect(fileList, "Registration_Age"))]))
dp4 <- read_csv(paste0("R:/MSS/Research/Projects/Baby_Toolbox/Data/Combined_Dry_Run_Data/",
                       fileList[which(str_detect(fileList, "DP4_"))]))


socialData_wide <- socialData %>%
  pivot_wider(id_cols=PIN:InstrumentTitle, names_from = Key, values_from = Value) %>%
  left_join(regAge, by=c("RegistrationID","PIN","PID","AssessmentName")) %>%
  left_join(dp4, by=c("PIN" = "pin"))

cor(socialData_wide[,c(8:17)], socialData_wide[,c(19,25:29)], 
    use='pairwise', method='spearman') %>%
  as_tibble(rownames="Score") # %>% write_csv("socCors.csv") # remove the first hash to ouput this


cor(socialData_wide[,c(8:17)], 
    use='pairwise', method='spearman') %>%
  as_tibble(rownames="Score") # %>% write_csv("socCors_internal.csv") # remove the first hash to ouput this
