#### Preamble ####
# Purpose: To simulate plausible polling data for Kamala Harris and Donald Trump in the 
#          2024 U.S. presidential election, supporting a poll of polls approach.
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
set.seed(304)

#### Simulate data ####
# Define parameters based on real data structure, keeping only relevant variables
states <- state.name
n_polls <- 100  # Number of polls to simulate
candidates <- c("Donald Trump", "Kamala Harris")
pollsters <- c("YouGov", "Ipsos", "CNN", "Gallup", "Emerson")  # Realistic pollster names

# Generate simulated data relevant for the poll-of-polls approach
simulated_data <- tibble(
  candidate = sample(candidates, n_polls, replace = TRUE),
  state = sample(states, n_polls, replace = TRUE),
  pollster = sample(pollsters, n_polls, replace = TRUE),
  sample_size = sample(500:3000, n_polls, replace = TRUE),  # Sample sizes between 500 and 3000
  pct = round(runif(n_polls, 40, 60), 1),  # Polling percentage between 40% and 60%
  start_date = sample(seq(as.Date("2024-01-01"), as.Date("2024-10-01"), by = "day"), n_polls, replace = TRUE),
  end_date = sample(seq(as.Date("2024-01-02"), as.Date("2024-10-02"), by = "day"), n_polls, replace = TRUE)
)

# Save the simulated data to CSV
write_csv(simulated_data, here("data/00-simulated_data/simulated_data.csv"))
