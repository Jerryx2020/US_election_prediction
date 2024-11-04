#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)
library(broom)
library(modelsummary)
library(rstanarm)
library(splines)
library(here)

#### Read data ####
data <- read_csv("data/02-analysis_data/analysis_data.csv")

just_harris_high_quality <- read.csv("data/02-analysis_data/just_harris_high_quality.csv")

just_harris_high_quality <- just_harris_high_quality %>%
  mutate(
    pollster = as.factor(pollster),
    state = as.factor(state),
    methodology = factor(methodology),
    numeric_grade = as.numeric(numeric_grade),
    transparency_score = as.numeric(transparency_score),
    sample_size = as.numeric(sample_size),
    end_date = as.Date(end_date),
    start_date = as.Date(start_date)
  )


linear_model <- lm(
  pct ~ pollscore + numeric_grade + sample_size + state + end_date, 
  data = just_harris_high_quality
)


#### Save Key Results ####

write_csv(just_harris_high_quality, "data/02-analysis_data/just_harris_high_quality.csv")
saveRDS(linear_model, "models/linear_model.rds")



