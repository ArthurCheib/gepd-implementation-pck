### Libraries
library(tidyverse)

## Function that will be used on the 1st-stage stratified sample (with proportional allocation)
stratify_sample <- function(data, strata_cols, total_sample_size) {
  ## This will ensure that strata cols is a character vector
  strata_cols <- as.character(strata_cols)
  
  # This calculates the size of each stratum and its proportion
  strata_sizes <- data %>%
    group_by(across(all_of(strata_cols))) %>%
    summarise(count = n(), .groups = 'drop') %>%
    mutate(prop = count / sum(count))
  
  # This auxiliary function calculates sample size for each stratum
  calc_stratum_sample_size <- function(stratum_size, total_population_size, total_sample_size) {
    round(stratum_size / total_population_size * total_sample_size)
  }
  
  # Calculating the sample sizes for each stratum
  strata_sizes$sample_size <- pmin(map2_dbl(strata_sizes$count, strata_sizes$prop, ~calc_stratum_sample_size(.x, sum(strata_sizes$count), total_sample_size)), strata_sizes$count)
  
  # Initializing an empty dataframe to store sampled data
  sampled_data <- data[FALSE, ]
  
  # Iterating over each stratum and sample
  for (i in seq_len(nrow(strata_sizes))) {
    stratum_data <- data
    for (col in strata_cols) {
      stratum_data <- stratum_data[stratum_data[[col]] == strata_sizes[[col]][i], ]
    }
    sample_size <- min(nrow(stratum_data), strata_sizes$sample_size[i])
    
    # Sampling from the stratum
    if (nrow(stratum_data) > 0 && sample_size > 0) {
      stratum_sample <- stratum_data[sample(nrow(stratum_data), size = sample_size, replace = FALSE), ]
      sampled_data <- rbind(sampled_data, stratum_sample)
    }
  }
  ## Creating column indicating TRUE for a school that was selected in the sampling process
  sampled_data$selected <- TRUE
  return(sampled_data)
}