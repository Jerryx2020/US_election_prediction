#### Preamble ####
# Purpose: To estimate the electoral college outcome for the 2024 U.S. presidential election using polling data, propagating uncertainty.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the 'tidyverse' package is installed for data manipulation.
# - The cleaned data must be available in 'data/02-analysis_data/analysis_data.csv'.

#### Workspace setup ####
library(tidyverse)

#### Create necessary directories ####
if (!dir.exists("data/04-electoral_college_estimate")) {
  dir.create("data/04-electoral_college_estimate", recursive = TRUE)
}

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Electoral College Estimate with Uncertainty ####
# Assign electoral votes to each state
# Updated electoral vote data
electoral_votes <- tibble(
  state = c(state.name, "District of Columbia"),
  electoral_votes = c(9, 3, 11, 6, 54, 10, 7, 3, 30, 16, 4, 4, 19, 11, 6, 6, 8, 10, 4, 10, 11, 16, 10, 11, 3, 4, 14, 5, 6, 28, 16, 3, 17, 7, 8, 19, 4, 9, 3, 11, 40, 6, 3, 13, 12, 4, 9, 3, 11, 10, 3)
)

# Calculate average polling support and standard deviation by state for each candidate
state_support_stats <- analysis_data %>%
  group_by(state, candidate_name) %>%
  summarise(
    avg_support = mean(pct, na.rm = TRUE),
    sd_support = sd(pct, na.rm = TRUE)
  ) %>%
  ungroup()

# Join electoral votes data
state_support_stats <- state_support_stats %>%
  left_join(electoral_votes, by = "state")

# Set number of simulations
n_simulations <- 1000

# Run Monte Carlo simulations for electoral college estimate
set.seed(853)
sim_results <- replicate(n_simulations, {
  # Simulate support for each candidate in each state
  simulated_support <- state_support_stats %>%
    mutate(simulated_pct = rnorm(n(), mean = avg_support, sd = sd_support)) %>%
    group_by(state) %>%
    filter(simulated_pct == max(simulated_pct)) %>%
    ungroup()
  
  # Calculate electoral votes for each candidate
  simulated_electoral_votes <- simulated_support %>%
    group_by(candidate_name) %>%
    summarise(total_electoral_votes = sum(electoral_votes, na.rm = TRUE)) %>%
    arrange(desc(total_electoral_votes))
  
  return(simulated_electoral_votes)
}, simplify = FALSE)

# Combine simulation results
sim_results_df <- bind_rows(sim_results, .id = "simulation") %>%
  group_by(candidate_name) %>%
  summarise(
    mean_electoral_votes = mean(total_electoral_votes, na.rm = TRUE),
    sd_electoral_votes = sd(total_electoral_votes, na.rm = TRUE)
  ) %>%
  arrange(desc(mean_electoral_votes))

# Save electoral college estimate with uncertainty
write_csv(sim_results_df, "data/04-electoral_college_estimate/electoral_college_totals_with_uncertainty.csv")