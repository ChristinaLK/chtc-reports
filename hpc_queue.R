library(dplyr)
library(tidyr)

filename <- 'hpc_queue_2017-06-01_month_users.csv'
infile <- paste0('data/',filename)
data <- read.csv(infile)

block <- data %>% 
  filter(X.Node == 1) %>% 
  filter(X.Job > 4) %>%
  select(User, X.CPU, X.Job) %>%
  spread(X.CPU, X.Job)

#block[is.na(block)] <- '-'

outfile <- paste0('clean/',filename)
write.csv(x = block, file = outfile, quote = FALSE)

names(block) <- c('User','one','four','sixteen','twenty')
block %>% 
  select(User, sixteen) %>%
  filter(!is.na(sixteen)) %>%
  arrange(desc(sixteen)) %>%
  select(User)


data %>% 
  filter(X.Node == 1) %>% 
  #filter(X.Job > 2) %>%
  select(Project, X.Job) %>%
  group_by(Project) %>%
  summarize(Total = sum(X.Job)) %>%
  arrange(desc(Total))

offenders <- data %>% 
  filter(X.Node == 1) %>% 
  #filter(X.Job > 2) %>%
  select(Project, X.CPU, X.Job) %>%
  group_by(Project) %>%
  summarize(Total = sum(X.Job)) %>%
  filter(Total >= 10) %>%
  select(Project)

offenders <- as.vector(offenders)

block[offenders]

data %>%
  filter(X.Job > 4) %>%
  