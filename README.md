# Forecasting the 2024 U.S. Presidential Election: Polling Trends and Dynamics Based on National General Election Polls

## Overview

This GitHub repository contains all the files used to generate the paper Forecasting the 2024 U.S. Presidential Election: Polling Trends and Dynamics Based on National General Election Polls.

The study analyzes national and state-level polling data aggregated from FiveThirtyEight to forecast the 2024 U.S. Presidential Election between Kamala Harris and Donald Trump. A multiple linear regression model was developed, incorporating variables such as candidate support percentages, pollster reliability, sample size, poll end dates, and geographic distribution. Recency weighting was applied to emphasize current voter sentiment. Monte Carlo simulations were conducted to estimate the distribution of possible Electoral College outcomes, accounting for state-level variations and uncertainties in polling data.


## File Structure

The repo is structured as:

-   `data/raw_data` Includes the raw polling data obtained from FiveThirtyEight.
-   `data/analysis_data` Contains the cleaned dataset used in the analysis after processing and filtering.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

This project utilized ChatGPT for assistance with code suggestions, explanations, refining data visualizations, and enhancing the writing of the paper. Comments detailing the specific instances where language models were used have been included directly in the relevant code scripts. A complete overview of the LLM usage is provided in usage.txt located in other/llm.

This project was completed primarily using R for data analysis, processing, and visualization. All necessary scripts, data, and references are included in the Repository to ensure reproducibility.