#### Preamble ####
# Purpose: To read and clean data on 2024 U.S. presidential election polling 
#          from the FiveThirtyEight poll aggregation at 
#          https://projects.fivethirtyeight.com/polls/president-general/2024/national/.
# Author: Peter Fan, Jerry Xia, Jason Yang
# Date: 01 November 2024
# Contact: 
# License: None
# - Ensure the 'tidyverse' and 'janitor' packages are installed for data manipulation.
# - Data should be downloaded and saved in the local project directory in a 'data/01-raw_data' folder.

#### Workspace setup ####
library(tidyverse)

#### Clean data ####

raw_data <- read_csv("data/01-raw_data/president_polls.csv") |>
  clean_names()

Analysis_data <- raw_data |> 
  filter(numeric_grade >= 3.0) %>% 
  select(candidate_name, pollster, sample_size, end_date, numeric_grade, methodology, state, pct, pollscore, transparency_score, start_date) %>%
  mutate(
    end_date = mdy(end_date),
    state = if_else(is.na(state), "National", state)
  ) %>%
  filter(candidate_name %in% c("Donald Trump", "Kamala Harris"))

Analysis_data <- Analysis_data %>%
  mutate(state = case_when(
    state == "Nebraska CD-2" ~ "Nebraska",
    TRUE ~ state  # Keeps all other values as they are
  ))

just_harris_high_quality <- Analysis_data |>
  filter(
    candidate_name == "Kamala Harris",
    end_date >= as.Date("2024-07-21"))  |> 
  mutate(
    num_harris = round((pct / 100) * sample_size, 0) 
  )

write_csv(Analysis_data, "data/02-analysis_data/Analysis_data.csv")
write_csv(just_harris_high_quality, "data/02-analysis_data/just_harris_high_quality.csv")

