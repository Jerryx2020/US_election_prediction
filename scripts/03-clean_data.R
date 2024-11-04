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
library(arrow)

#### Read raw data ####
raw_data <- read_csv("data/01-raw_data/president_polls.csv") |>
  clean_names()

#### Data Cleaning ####
# Select and clean relevant columns for analysis
analysis_data <- raw_data %>% 
  select(candidate_name, pollster, sample_size, end_date, state, pct) %>%
  mutate(
    end_date = mdy(end_date),
    state = case_when(
      state == "Nebraska CD-2" ~ "Nebraska",
      state == "Maine CD-1" ~ "Maine", 
      state == "Maine CD-2" ~ "Maine",
      TRUE ~ state
    )
  ) %>%
  filter(candidate_name %in% c("Donald Trump", "Kamala Harris")) %>%
  drop_na()

# Filter observations to include only recent polling data (after Harris was declared)
# cutoff_date <- as.Date("2024-07-21")
# analysis_data <- analysis_data %>%
# filter(end_date >= cutoff_date)

# Calculate poll recency to enhance depth of analysis
reference_date <- max(analysis_data$end_date, na.rm = TRUE)
analysis_data <- analysis_data %>%
  mutate(recency = as.numeric(reference_date - end_date))

# Remove pollsters with fewer than 5 polls to ensure data reliability
analysis_data <- analysis_data %>%
  group_by(pollster) %>%
  filter(n() >= 5) %>%
  ungroup()

#### Save cleaned dataset ####
write_parquet(analysis_data, "data/02-analysis_data/analysis_data.parquet")