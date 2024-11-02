#### Preamble ####
# Purpose: To generate and validate simulated polling data for Donald Trump and Kamala Harris,
#          including basic checks on data structure, ranges, and consistency of values.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 01 November 2024
# License: None
# Pre-requisites:
# - Ensure that 'tidyverse' is installed for data manipulation.
# - The 'Analysis_data' dataset should be loaded with valid pollster data.
# - This script will output a CSV file of the simulated data in the "data/00-simulated_data" directory.
# - Run this script after generating simulated data to validate its integrity and consistency.

#### Workspace setup ####
library(tidyverse)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 100 rows
if (nrow(analysis_data) == 100) {
  message("Test Passed: The dataset has 100 rows.")
} else {
  stop("Test Failed: The dataset does not have 100 rows.")
}

# Check if the dataset has all the columns
expected_columns <- c("poll_id", "candidate", "state", "pollster", "sample_size", "pct")
if (all(expected_columns %in% colnames(simulated_data))) {
  message("Test Passed: The dataset has all the columns.")
} else {
  stop("Test Failed: The dataset does not have 3 columns.")
}

# Test if data types are correct
if (is.integer(simulated_data$poll_id) &&
    is.character(simulated_data$candidate) &&
    is.character(simulated_data$state) &&
    is.character(simulated_data$pollster) &&
    is.integer(simulated_data$sample_size) &&
    is.numeric(simulated_data$pct)) {
  message("Test Passed: Data types are correct for 'simulated_data'.")
} else {
  stop("Test Failed: One or more columns in 'simulated_data' have incorrect data types.")
}

# Test if candidate only contains "Donald Trump" and "Kamala Harris"
if (all(simulated_data$candidate %in% c("Donald Trump", "Kamala Harris"))) {
  message("Test Passed: 'candidate' only contains 'Donald Trump' and 'Kamala Harris'.")
} else {
  stop("Test Failed: 'candidate' contains values other than 'Donald Trump' and 'Kamala Harris'.")
}

# Test if state contains only valid U.S. state names
if (all(simulated_data$state %in% state.name)) {
  message("Test Passed: 'state' only contains valid U.S. state names.")
} else {
  stop("Test Failed: 'state' contains invalid U.S. state names.")
}

# Test if pct is within the range 40 to 60
if (all(simulated_data$pct >= 40 & simulated_data$pct <= 60)) {
  message("Test Passed: 'pct' values are within the range 40 to 60.")
} else {
  stop("Test Failed: 'pct' values are outside the range 40 to 60.")
}

# Test if total_votes is non-negative
if (all(stimulated_votes$total_votes >= 0)) {
  message("Test Passed: 'total_votes' is non-negative.")
} else {
  stop("Test Failed: 'total_votes' contains negative values.")
}

