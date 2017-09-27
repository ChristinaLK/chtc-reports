library(dplyr)
library(lubridate)
library(tidyr)
library(ggplot2)

filename <- 'data/usertable20170217.csv'
data <- read.csv(filename)

select_list <- c(User,Uniq.Job.Ids,ShortJobStarts,
                 All.Starts,X72.Hour,Min,X25,
                 Median,X75,Max,Mean,Std)

data %>%
  select(User,Uniq.Job.Ids,
         All.Starts,X72.Hour,Min,
         Median,Max,Mean,Std) %>%
  mutate(Min = hm(Min),
         Median = hm(Median),
         Max = hm(Max),
         Mean = hm(Mean),
         Std = hm(Std))

binning_fcn <- function(row) {
  print(row)
  converted_time <- hm(row)
  print(converted_time)
  hrs <- hour(converted_time)
  #ifelse((minute(converted_time > 30)), hrs <- hrs+1, hrs)
  if (minute(converted_time) > 30)
  { hrs <- hrs + 1 }
  while (hrs %% 6 != 0) {
    hrs <- hrs + 1
  }
  if (hrs > 72) 
  {hrs <- 72}  
  print(hrs)
  return(hrs)
}

clean_data <- data %>%
  filter(User != 'Totals') %>%
  select(User,Uniq.Job.Ids,X25.,
         Median,X75.,Max) %>%
  gather(Type,Times, X25., Median, X75., Max) %>% 
  mutate(Uniq.Job.Ids = round(Uniq.Job.Ids/4)) %>%
  #mutate(Times = hm(Times)) %>%
  #mutate(Bin = binning_fcn(Times)) %>%
  arrange(Times) %>%
  filter(User == 'megarcia@chtc.wisc.edu' | 
           User == 'cvoter@chtc.wisc.edu')

clean_data <- clean_data %>% mutate(Bin = binning_fcn(Times))

clean_data %>% 
  group_by(Bin) %>% summarize(Total = sum(Uniq.Job.Ids)) %>%
  filter(Bin <= 72 & Bin > 0) %>%
  ggplot(aes(x = Bin)) + 
  geom_bar(stat = 'identity', 
           aes(y = Total)) + 
  theme_minimal()

