#### Preamble ####
# Purpose: Downloads and saves the data from 
# Author: Group 15
# Date: 11 February 2023 
# Contact: rohan.alexander@utoronto.ca 
# License: MIT
# Pre-requisites: 
# Any other information needed? 


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Save data ####
write_csv(the_raw_data, "inputs/data/raw_data.csv") 

         
