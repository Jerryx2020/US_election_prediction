#### Preamble ####
# Purpose: To read and clean data on 2024 U.S. presidential election polling 
#          from the FiveThirtyEight poll aggregation at 
#          https://projects.fivethirtyeight.com/polls/president-general/2024/national/.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the 'tidyverse' and 'janitor' packages are installed for data manipulation.
# - Data should be downloaded and saved in the local project directory in a 'data/01-raw_data' folder.

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)

#### Clean data ####

# Load raw data
raw_data <- read_csv("data/01-raw_data/president_polls.csv") |>
  clean_names()

# Select and clean relevant columns
analysis_data <- raw_data %>% 
  select(candidate_name, pollster, sample_size, end_date, state, pct) %>%
  mutate(end_date = mdy(end_date)) %>%
  filter(candidate_name %in% c("Donald Trump", "Kamala Harris"))

# Adjust state names for Nebraska and Maine districts
analysis_data <- analysis_data %>%
  mutate(state = case_when(
    state == "Nebraska CD-2" ~ "Nebraska",
    state == "Maine CD-1" ~ "Maine", 
    state == "Maine CD-2" ~ "Maine",
    TRUE ~ state  # Keeps all other values as they are
  ))

# Drop rows with missing values
analysis_data <- analysis_data %>% drop_na()

# Save cleaned dataset
write_csv(analysis_data, "data/02-analysis_data/analysis_data.csv")