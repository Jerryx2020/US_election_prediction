#### Preamble ####
# Purpose: To load polling data from FiveThirtyEight for the 2024 U.S. presidential election.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure that the 'tidyverse' and 'here' packages are installed for data manipulation.
# - The raw data ('president_polls.csv') should be manually added to the project folder.

#### Workspace setup ####
library(tidyverse)
library(here)

#### Load data ####
# Load the manually provided raw data
the_raw_data <- read_csv(here("data/president_polls.csv"))
