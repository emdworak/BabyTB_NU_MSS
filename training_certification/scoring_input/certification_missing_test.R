temp <- cert_df_wide_NA %>% 
  filter(name == "NAME") %>% 
  t() %>% 
  data.frame()

colnames(temp) <- "V1"

temp2 <- temp %>% filter(is.na(V1)) %>% rownames() %>% data.frame()
colnames(temp2) <- "V1"

temp2 %>% 
  mutate(value = ifelse(str_detect(V1, "rte_v1"), "rte_v1", 
                 ifelse(str_detect(V1, "rte_v2"), "rte_v2", 
                 ifelse(str_detect(V1, "gug_v1"), "gug_v1",
                 ifelse(str_detect(V1, "gug_v2"), "gug_v2",
                 ifelse(str_detect(V1, "sas_v1"), "sas_v1",
                 ifelse(str_detect(V1, "sas_v2"), "sas_v2",
                 ifelse(str_detect(V1, "sas_v3"), "sas_v3",
                 ifelse(str_detect(V1, "sas_v4"), "sas_v4",
                 ifelse(str_detect(V1, "sobY_v1"), "sobY_v1",
                 ifelse(str_detect(V1, "sobY_v2"), "sobY_v2",
                 ifelse(str_detect(V1, "sobO_v1"), "sobO_v1",
                 ifelse(str_detect(V1, "sobO_v2"), "sobO_v2",
                               NA))))))))))))) %>% 
  select(value) %>% 
  unique()

# temp %>% filter(!is.na(V1)) %>% View()
