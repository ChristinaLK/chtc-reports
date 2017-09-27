## R script to check queue reports

suppressWarnings(suppressMessages(library(dplyr)))
library(tidyr)

args <- commandArgs(trailingOnly = TRUE)

#filename <- 'data/hpc/2017-09-17_to_2017-09-24_users.csv'
filename <- args[1]
data <- read.csv(filename)

cutoff_num_cpus <- 32
cutoff_num_jobs <- 5

offenders <- data %>% 
  filter(X.CPU < cutoff_num_cpus) %>% 
  select(User, X.Job) %>%
  group_by(User) %>%
  summarize(Total = sum(X.Job)) %>%
  filter(Total > cutoff_num_jobs) %>%
  arrange(desc(Total))

offenders %>%
  left_join(data) %>%
  filter(X.CPU < cutoff_num_cpus) %>%
  select(User,X.Job,X.CPU,AvgRunTime)
