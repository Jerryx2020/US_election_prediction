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
  drop_na(pollster, state, sample_size)

just_harris_high_quality <- just_harris_high_quality %>%
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    methodology = factor(methodology),
    numeric_grade = as.numeric(numeric_grade),
    transparency_score = as.numeric(transparency_score),
    sample_size = as.numeric(sample_size),
    end_date = as.Date(end_date),
    start_date = as.Date(start_date)
  )


linear_model <- lm(
  pct ~ numeric_grade + sample_size + transparency_score + state + end_date, 
  data = just_harris_high_quality
)

summary(linear_model)

just_harris_high_quality <- just_harris_high_quality %>%
  mutate(predicted_pct = predict(linear_model, newdata = just_harris_high_quality))

# Plot actual vs. predicted values
ggplot(just_harris_high_quality, aes(x = end_date)) +
  geom_point(aes(y = pct, color = "Actual")) +
  geom_line(aes(y = predicted_pct, color = "Predicted")) +
  labs(
    y = "Polling Percentage (pct)",
    x = "Days since Start",
    title = "Actual vs. Predicted Polling Percentages for Kamala Harris",
    color = "Legend"
  ) +
  theme_minimal()


#### Save Key Results ####
write_csv(just_harris_high_quality, "data/02-analysis_data/just_harris_high_quality.csv")
saveRDS(linear_model, "models/linear_model.rds")



