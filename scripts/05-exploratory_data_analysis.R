#### Preamble ####
# Purpose: To model the 2024 U.S. presidential election polling data to predict support for candidates.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the 'tidyverse' and 'arrow' packages are installed for data manipulation and modeling.
# - The cleaned data must be available in 'data/02-analysis_data/analysis_data.parquet'.

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Model data ####
# Fit a model to predict support for the candidates using polling data
support_model <-
  lm(
    formula = pct ~ candidate_name + state + sample_size + pollster,
    data = analysis_data
  )

#### Save model ####
saveRDS(
  support_model,
  file = "models/support_model.rds"
)
