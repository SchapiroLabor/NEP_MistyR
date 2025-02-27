# Import libraries
# MISTy
library (mistyR)
library(future)

# data manipulation
library(dplyr)
library(purrr)
library(distances)

# plotting
library(ggplot2)

# Multisession for parallel computing
plan(multisession)

#######################################
my_mysty <- function(path, out){
  # Get name
  name <- basename(path) 
  
  # Read data and split positions and counts
  data <- read.csv(file=path, header=TRUE) %>% as_tibble()
  pos <- data %>% select("x", "y")
  count <- data %>% select(starts_with("ct_"))
  
  # Create MISTy view
  count %>% 
    create_initial_view() %>% 
    add_juxtaview(pos, neighbor.thr=40, prefix = "p") %>% 
    run_misty(results.folder = paste0(out, .Platform$file.sep, name), bypass.intra = TRUE)
  
}


#######################################

# Read in datafile
input_folder <- "/Users/miguelibarra/PycharmProjects/MI_misty_and_symdata/data/20250217_sym00_nbh2_1000dim_grid200_300iter_50swaps_ohe"
out_dir <- "/Users/miguelibarra/PycharmProjects/MI_misty_and_symdata/output_delaunay/20250217_sym00_nbh2_1000dim_grid200_300iter_50swaps_ohe/"


# Get the list of all files in the input folder
file_list = input_folder %>% list.files(full.names = TRUE)

# Run misty
results_folders <- file_list %>% map_chr(my_mysty, out_dir)
  
