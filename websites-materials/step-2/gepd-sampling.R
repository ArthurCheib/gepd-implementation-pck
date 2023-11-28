### Libraries
library(tidyverse)
url <- 'https://raw.githubusercontent.com/ArthurCheib/gepd-implementation-pck/main/websites-materials/step-2/stratify_sample.R'
source(url)

# If you want more information about the sampling process done in R, access the `url` above

## Data
file <- 'your_file_name'

## Reading the data (the only two options you will have is a .csv or a .xlsx file)
ext <- tools::file_ext(file$name)
if (ext == "csv") {
  
  data <- read.csv(file$datapath, stringsAsFactors = FALSE)
  
} else if (ext == "xlsx") {
  
  data <- read_excel(file$datapath)
  
}

## Choosing columns for stratification + sample size
# Make sure you notice, the default sample size is 200
strata_cols <- c('col1', 'col2')
sample_size <- 200

# Stratification logic
if (length(strata_cols) == 2) {
  
  # Stratify by two columns
  stratified_data <- stratify_sample(data, strata_cols, sample_size)
  
} else if (input$strata1 != "") {
  
  # Stratify by one column
  data <- stratify_sample(data, strata_cols, sample_size)
  
}