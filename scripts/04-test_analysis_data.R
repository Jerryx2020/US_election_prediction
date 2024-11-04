#### Preamble ####
# Purpose: To test the integrity and structure of the cleaned data from the 2024 U.S. presidential election polling.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the 'tidyverse' and 'testthat' packages are installed for data manipulation and testing.
# - The cleaned data must be available in 'data/02-analysis_data/analysis_data.parquet'.

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the cleaned data
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Test data ####

# Test 1: Check that the dataset has the expected columns
test_that("dataset has required columns", {
  required_columns <- c("candidate_name", "pollster", "sample_size", "end_date", "state", "pct")
  expect_true(all(required_columns %in% colnames(analysis_data)))
})

# Test 2: Validate data types for key columns
test_that("data types are correct for key columns", {
  expect_type(analysis_data$candidate_name, "character")
  expect_type(analysis_data$pollster, "character")
  expect_type(analysis_data$sample_size, "double")  # Use "integer" if sample_size is converted to integer
  expect_type(analysis_data$pct, "double")
})

# Test 3: Check `pct` is within valid range (0 to 100)
test_that("'pct' values are within the valid range (0 to 100)", {
  expect_true(all(analysis_data$pct >= 0 & analysis_data$pct <= 100))
})

# Test 4: Check `state` contains valid U.S. states or "National"
test_that("'state' column contains valid U.S. states or 'National'", {
  valid_states <- c(state.name, "National")
  expect_true(all(analysis_data$state %in% valid_states))
})

# Test 5: Check for missing values
test_that("no missing values in key columns", {
  key_columns <- c("candidate_name", "pollster", "sample_size", "end_date", "state", "pct")
  expect_true(all(complete.cases(analysis_data[key_columns])))
})
