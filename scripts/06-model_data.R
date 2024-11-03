#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)
library(broom)
library(modelsummary)
library(rstanarm)
library(splines)
library(here)

#### Read data ####
data <- read_csv("data/analysis_data/analysis_data.csv")

just_harris_high_quality <- read.csv("data/analysis_data/just_harris_high_quality.csv")
just_harris_high_quality <- just_harris_high_quality %>%
  drop_na(end_date_num, pollster, state, sample_size)

#### Exploratory Data Visualization ####
# Base plot for Harris polling percentage over time
base_plot <- ggplot(just_harris_high_quality, aes(x = end_date, y = pct)) +
  theme_classic() +
  labs(y = "Harris Percent", x = "Date")

# Plot the base data and apply smoothing
base_plot + geom_point() + geom_smooth() +
  ggtitle("Polling Estimates Over Time")

# Plot colored by pollster
base_plot + geom_point(aes(color = pollster)) + geom_smooth() +
  theme(legend.position = "bottom") + ggtitle("Polling by Pollster")

#### Bayesian Models ####
# Convert 'pollster' and 'state' to factor variables for Bayesian models
just_harris_high_quality <- just_harris_high_quality %>%
  mutate(
    pollster = factor(pollster),
    state = factor(state)
  )

# Define priors
priors <- normal(0, 2.5, autoscale = TRUE)

# Bayesian Model 1: Random intercept for pollster
model_formula_1 <- cbind(num_harris, sample_size - num_harris) ~ (1 | pollster)
bayesian_model_1 <- stan_glmer(
  formula = model_formula_1,
  data = just_harris_high_quality,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  seed = 123,
  cores = 4,
  adapt_delta = 0.99
)

# Bayesian Model 2: Random intercept for pollster and state
model_formula_2 <- cbind(num_harris, sample_size - num_harris) ~ (1 | pollster) + (1 | state)
bayesian_model_2 <- stan_glmer(
  formula = model_formula_2,
  data = just_harris_high_quality,
  family = binomial(link = "logit"),
  prior = priors,
  prior_intercept = priors,
  seed = 123,
  cores = 4,
  adapt_delta = 0.99
)

# Summarize Bayesian models
summary(bayesian_model_1)
summary(bayesian_model_2)

# Posterior predictive checks
pp_check(bayesian_model_1)
pp_check(bayesian_model_2)

#### Bayesian Splines Model ####
# Convert date to numeric for splines
just_harris_high_quality <- just_harris_high_quality %>%
  mutate(end_date_num = as.numeric(end_date - min(end_date)))

# Fit Bayesian model with spline for end_date
spline_model <- stan_glm(
  pct ~ ns(end_date_num, df = 5) + pollster,
  data = just_harris_high_quality,
  family = gaussian(),
  prior = normal(0, 5),
  prior_intercept = normal(50, 10),
  seed = 1234,
  iter = 2000,
  chains = 4,
  refresh = 0
)

# Summarize and check posterior of spline model
summary(spline_model)
pp_check(spline_model)

new_data <- data.frame(
  end_date_num = seq(
    min(just_harris_high_quality$end_date_num),
    max(just_harris_high_quality$end_date_num),
    length.out = 100
  ),
  pollster = factor("YouGov", levels = levels(just_harris_high_quality$pollster))
)

# Predict posterior draws
posterior_preds <- posterior_predict(spline_model, newdata = new_data)

# Summarize predictions
pred_summary <- new_data |>
  mutate(
    pred_mean = colMeans(posterior_preds),
    pred_lower = apply(posterior_preds, 2, quantile, probs = 0.025),
    pred_upper = apply(posterior_preds, 2, quantile, probs = 0.975)
  )

# Plot the spline fit
ggplot(just_harris_high_quality, aes(x = end_date_num, y = pct, color = pollster)) +
  geom_point() +
  geom_line(
    data = pred_summary,
    aes(x = end_date_num, y = pred_mean),
    color = "blue",
    inherit.aes = FALSE
  ) +
  geom_ribbon(
    data = pred_summary,
    aes(x = end_date_num, ymin = pred_lower, ymax = pred_upper),
    alpha = 0.2,
    inherit.aes = FALSE
  ) +
  labs(
    x = "Days since earliest poll",
    y = "Percentage",
    title = "Poll Percentage over Time with Spline Fit"
  ) +
  theme_minimal()

# Multiple Linear Regression Model for Predicting Support Precentages

just_harris_high_quality <- just_harris_high_quality %>%
  mutate(
    pollster = as.factor(pollster),
    state = as.factor(state),
    end_date_num = as.numeric(end_date - min(end_date))  # Convert date to a numeric variable representing days since start
  )

linear_model <- lm(
  pct ~ end_date_num + pollster + state + sample_size,
  data = just_harris_high_quality
)

summary(linear_model)

just_harris_high_quality <- just_harris_high_quality %>%
  mutate(predicted_pct = predict(linear_model))

# Plot actual vs. predicted values
ggplot(just_harris_high_quality, aes(x = end_date_num)) +
  geom_point(aes(y = pct, color = "Actual")) +
  geom_line(aes(y = predicted_pct, color = "Predicted")) +
  labs(
    y = "Polling Percentage (pct)",
    x = "Days since Start",
    title = "Actual vs. Predicted Polling Percentages for Kamala Harris",
    color = "Legend"
  ) +
  theme_minimal()


#### Save Key Results ####
write_csv(just_harris_high_quality, "data/02-analysis_data/just_harris_high_quality.csv")
saveRDS(bayesian_model_1, "models/bayesian_model_1.rds")
saveRDS(bayesian_model_2, "models/bayesian_model_2.rds")
saveRDS(spline_model, "models/spline_model.rds")



