#### Preamble ####
# Purpose: To build and analyze a linear model for Kamala Harris's polling performance in the 2024 U.S. presidential election.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the necessary packages ('tidyverse', 'broom') are installed for data manipulation and model analysis.
# - The cleaned data must be available in 'data/02-analysis_data/analysis_data.parquet'.

#### Workspace setup ####
library(tidyverse)
library(broom)
library(arrow)

#### Read data ####
# Load cleaned dataset for Kamala Harris's polling performance
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Filter data for Kamala Harris
just_harris_high_quality <- analysis_data %>%
  filter(candidate_name == "Kamala Harris") %>%
  mutate(
    pollster = as.factor(pollster),
    state = as.factor(state),
    sample_size = as.numeric(sample_size),
    end_date = as.Date(end_date)
  )

#### Build Linear Model ####
linear_model <- lm(
  pct ~ sample_size + state + end_date, 
  data = just_harris_high_quality
)

#### Save Model ####
saveRDS(linear_model, "models/linear_model.rds")

#### Model Analysis ####
# Get a tidy summary of the linear model
model_summary <- tidy(linear_model)

# Print model summary to console
print(model_summary)

# Save model summary as CSV
write_csv(model_summary, "data/05-model_results/linear_model_summary.csv")

# Create a visual summary of the model coefficients
plot_model <- ggplot(model_summary, aes(x = term, y = estimate)) +
  geom_point() +
  geom_errorbar(aes(ymin = estimate - std.error, ymax = estimate + std.error), width = 0.2) +
  coord_flip() +
  labs(
    title = "Linear Model Coefficients for Kamala Harris Polling Performance",
    x = "Predictor",
    y = "Estimate"
  ) +
  theme_minimal()

# Save plot
ggsave("figures/linear_model_coefficients.png", plot_model, width = 10, height = 8)

# Save model summary as a text file for easier inclusion in reports
write.table(model_summary, file = "data/05-model_results/linear_model_summary.txt", sep = "\t", row.names = FALSE, quote = FALSE)
