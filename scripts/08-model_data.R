#### Preamble ####
# Purpose: To analyze the results of the linear model for Kamala Harris's polling performance in the 2024 U.S. presidential election.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the necessary packages ('tidyverse', 'broom', 'modelsummary') are installed for data manipulation and model analysis.
# - The linear model must be available in 'models/linear_model.rds'.

#### Workspace setup ####
library(tidyverse)
library(broom)
library(modelsummary)

#### Read model ####
linear_model <- readRDS("models/linear_model.rds")

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

# Create a summary table for the model
modelsummary(linear_model, output = "data/05-model_results/linear_model_summary.html")
