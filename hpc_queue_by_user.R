library(dplyr)
library(tidyr)

filename <- 'data/hpc_queue_users_2017-06-18.csv'
data <- read.csv(filename)

data %>% 
  filter(X.Node == 1) %>% 
  #filter(X.Job > 2) %>%
  select(User, X.Job) %>%
  group_by(User) %>%
  summarize(Total = sum(X.Job)) %>%
  arrange(desc(Total))

offenders <- data %>% 
  filter(X.Node == 1) %>% 
  #filter(X.Job > 2) %>%
  select(User, X.CPU, X.Job) %>%
  group_by(User) %>%
  summarize(Total = sum(X.Job)) %>%
  filter(Total >= 10) %>%
  select(User)

offenders <- as.vector(offenders)

block[offenders]
