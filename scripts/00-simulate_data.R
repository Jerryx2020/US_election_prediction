#### Preamble ####
# Purpose: To simulate plausible polling data for Kamala Harris's performance in the 
#          2024 U.S. presidential election.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites:
# - Ensure the 'tidyverse' and 'here' packages are installed for data manipulation 
#   and file path management.

#### Workspace setup ####
library(tidyverse)
library(here)
set.seed(666)

#### Simulate data ####
states <- state.name
n_polls <- 100  # Number of polls to simulate
candidates <- c("Donald Trump", "Kamala Harris")

# Extract unique pollsters from the existing analysis dataset
pollsters <- Analysis_data %>% distinct(pollster) %>% pull(pollster)

# Generate simulated data
simulated_data <- tibble(
  poll_id = 1:n_polls,
  candidate = sample(candidates, n_polls, replace = TRUE),
  state = sample(states, n_polls, replace = TRUE),
  pollster = sample(pollsters, n_polls, replace = TRUE),
  sample_size = sample(500:1000, n_polls, replace = TRUE),  # Random sample sizes between 500 and 1000
  pct = round(runif(n_polls, 40, 60), 1)  # Random polling percentage between 40% and 60%
)

# Adjust polling percentages to ensure each candidate has plausible values
simulated_votes <- simulated_data %>%
  mutate(votes = round((pct / 100) * sample_size)) %>%  # Calculate number of votes per poll
  group_by(candidate, state) %>%                        # Group by candidate and state
  summarize(total_votes = sum(votes, na.rm = TRUE)) %>%  # Sum votes within each group
  ungroup()                                              # Remove grouping for a clean data frame

# Save simulated data
write_csv(simulated_data, here("data/00-simulated_data/simulated_data.csv"))