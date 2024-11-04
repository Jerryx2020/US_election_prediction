#### Preamble ####
# Purpose: To analyze the pollsters used in the 2024 U.S. presidential election polling data, evaluating credibility and identifying patterns or biases.
# Authors: Peter Fan, Jerry Xia, Jason Yang
# Date: 04 November 2024
# Contact: 
# License: None
# Pre-requisites: 
# - Ensure the 'tidyverse' package is installed for data manipulation.
# - The cleaned data must be available in 'data/02-analysis_data/analysis_data.csv'.

#### Workspace setup ####
library(tidyverse)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Pollster Analysis ####
# Summary statistics by pollster
df_pollster_summary <- analysis_data %>%
  group_by(pollster) %>%
  summarise(
    avg_support = mean(pct, na.rm = TRUE),
    sd_support = sd(pct, na.rm = TRUE),
    total_polls = n(),
    avg_sample_size = mean(sample_size, na.rm = TRUE)
  ) %>%
  arrange(desc(total_polls))

# Get the top 10 pollsters by number of polls
top_10_pollsters <- df_pollster_summary %>%
  top_n(10, total_polls)

# Plot average support by the top 10 pollsters
plot_pollster_support_top_10 <- top_10_pollsters %>%
  ggplot(aes(x = reorder(pollster, -avg_support), y = avg_support)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(
    title = "Average Candidate Support by Top 10 Pollsters",
    x = "Pollster",
    y = "Average Support (%)"
  ) +
  theme_minimal()

# Save the updated plot
ggsave("figures/pollster_support_analysis_top_10.png", plot_pollster_support_top_10, width = 10, height = 8)

# Save summary statistics
write_csv(df_pollster_summary, "data/03-analysis_summary/pollster_summary.csv")