#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 26 September 2024 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(testthat)

analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")


#### Test data ####

# Test 1: Check that the dataset has the expected columns
test_that("dataset has required columns", {
  required_columns <- c("candidate_name", "pollster", "sample_size", "end_date", 
                        "numeric_grade", "methodology", "state", "pct", "pollscore")
  expect_true(all(required_columns %in% colnames(analysis_data)))
})

# Test 3: Validate data types for key columns
test_that("data types are correct for key columns", {
  expect_type(analysis_data$candidate_name, "character")
  expect_type(analysis_data$pollster, "character")
  expect_type(analysis_data$sample_size, "double")  # Use "integer" if sample_size is converted to integer
  expect_type(analysis_data$pct, "double")
})

# Test 4: Check `pct` is within valid range (0 to 100)
test_that("'pct' values are within the valid range (0 to 100)", {
  expect_true(all(analysis_data$pct >= 0 & analysis_data$pct <= 100))
})

# Test 5: Check that `numeric_grade` is within expected range (1.0 to 5.0)
test_that("'numeric_grade' is within the expected range", {
  expect_true(all(analysis_data$numeric_grade >= 1.0 & analysis_data$numeric_grade <= 5.0))
})

# Test 6: Check `state` contains valid U.S. states or "National"
test_that("'state' column contains valid U.S. states or 'National'", {
  valid_states <- c(state.name, "National")
  expect_true(all(analysis_data$state %in% valid_states))
})

