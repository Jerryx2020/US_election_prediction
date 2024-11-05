# Predicting the 2024 U.S. Presidential Election

## Overview

This repository offers forecasts for the 2024 U.S. presidential election using a "poll of polls" approach, aggregating data from multiple polling sources to enhance prediction accuracy. By integrating different polling datasets, this project aims to provide a comprehensive analysis of electoral trends and forecast potential outcomes.

The raw polling data was obtained from FiveThirtyEight, which aggregates national polling data for the 2024 presidential election. The original data is available here: [FiveThirtyEight Poll Aggregation](https://projects.fivethirtyeight.com/polls/president-general/2024/national/).

## File Structure

The repository is organized as follows:

- `data/00-simulated_data` - Contains simulated polling data used to support robustness checks and sensitivity analyses.
- `data/01-raw_data` - Contains the raw polling data obtained from FiveThirtyEight.
- `data/02-analysis_data` - Contains the cleaned dataset that has been processed and prepared for analysis.
- `data/03-analysis_summary` - Contains summary datasets generated during the analysis, including pollster credibility and support statistics.
- `data/04-electoral_college_estimate` - Includes datasets related to electoral college estimates and state-level support.
- `data/05-model_results` - Contains summary results from the models, including coefficient estimates and performance metrics.
- `models` - Contains the fitted models developed during the forecasting process.
- `figures` - Stores graphs and visualizations generated as part of the analysis, such as model coefficient plots and pollster support comparisons.
- `paper` - Contains the Quarto document used to generate the research paper, along with the references in `references.bib` and the resulting PDF.
- `scripts` - Contains the R scripts used for various steps of the project, including simulating data, downloading raw data, cleaning data, exploratory data analysis, pollster analysis, and modeling.
- `other` - Includes sketches of visualizations, survey documentation, and LLM usage logs.

## Statement on LLM Usage

The code in this repository was partially developed with the assistance of ChatGPT-4o. Specifically, the LLM was consulted during the data simulation process, for assistance with visualizations, and for refining some modeling approaches. Detailed transcripts of interactions with ChatGPT-4o are available in `other/llm_usage`. These records ensure transparency regarding the contributions of AI to this project.

## Instructions

1. **Data Preparation**: Begin by running the scripts in `scripts/` to simulate, download, and clean the polling data. The sequence of scripts is numbered to guide the user through the data preparation steps.
2. **Analysis**: Use the cleaned data in `data/02-analysis_data` for exploratory analysis and summary statistics. The exploratory data analysis script can be found in `scripts/05-exploratory_data_analysis.R`.
3. **Modeling**: Execute the modeling scripts in `scripts/` to build predictive models. The fitted models are saved in the `models/` directory, and summary results are located in `data/05-model_results`.
4. **Paper Generation**: To generate the final paper, use the Quarto document (`paper.qmd`) in the `paper/` directory. The document can be rendered to PDF to produce a complete report of the analysis.

## Citation

If you use this repository, please cite it accordingly. Additionally, cite FiveThirtyEight as the source for polling data, as well as any other sources referenced in `references.bib`.

