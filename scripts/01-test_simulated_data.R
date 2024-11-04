#### Preamble ####
# Purpose: To generate and validate simulated polling data for Donald Trump and Kamala Harris,
#          including basic checks on data structure, ranges, and consistency of values.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# License: None
# Pre-requisites:
# - Ensure that 'tidyverse' is installed for data manipulation.
# - This script will validate the integrity and consistency of the simulated data.

#### Workspace setup ####
library(tidyverse)

# Load the simulated data
test_data <- read_csv("data/00-simulated_data/simulated_data.csv")

#### Test data ####

# Test if the dataset has 100 rows
if (nrow(test_data) == 100) {
  message("Test Passed: The dataset has 100 rows.")
} else {
  stop("Test Failed: The dataset does not have 100 rows.")
}

# Check if the dataset has all the expected columns
expected_columns <- c("poll_id", "candidate", "state", "pollster", "sample_size", "pct")
if (all(expected_columns %in% colnames(test_data))) {
  message("Test Passed: The dataset has all the expected columns.")
} else {
  stop("Test Failed: The dataset does not have all the expected columns.")
}

# Test if data types are correct
if (is.character(test_data$candidate) &&
    is.character(test_data$state) &&
    is.character(test_data$pollster) &&
    is.numeric(test_data$sample_size) &&
    is.numeric(test_data$pct)) {
  message("Test Passed: Data types are correct for 'test_data'.")
} else {
  stop("Test Failed: One or more columns in 'test_data' have incorrect data types.")
}

# Test if 'candidate' only contains "Donald Trump" and "Kamala Harris"
if (all(test_data$candidate %in% c("Donald Trump", "Kamala Harris"))) {
  message("Test Passed: 'candidate' only contains 'Donald Trump' and 'Kamala Harris'.")
} else {
  stop("Test Failed: 'candidate' contains values other than 'Donald Trump' and 'Kamala Harris'.")
}

# Test if 'state' contains only valid U.S. state names
if (all(test_data$state %in% state.name)) {
  message("Test Passed: 'state' only contains valid U.S. state names.")
} else {
  stop("Test Failed: 'state' contains invalid U.S. state names.")
}

# Test if 'pct' is within the range 40 to 60
if (all(test_data$pct >= 40 & test_data$pct <= 60)) {
  message("Test Passed: 'pct' values are within the range 40 to 60.")
} else {
  stop("Test Failed: 'pct' values are outside the range 40 to 60.")
}

# Test if 'sample_size' is between 500 and 1000
if (all(test_data$sample_size >= 500 & test_data$sample_size <= 3000)) {
  message("Test Passed: 'sample_size' values are within the range 500 to 3000.")
} else {
  stop("Test Failed: 'sample_size' values are outside the range 500 to 3000.")
}
