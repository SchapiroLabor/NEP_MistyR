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

my_mysty <- function(path, out){
  # Get name
  name <- basename(path)
  print(name)
  
  # Read data and split positions and counts
  data <- read.csv(file=path, header=TRUE) %>% as_tibble()
  pos <- data %>% select("X_centroid", "Y_centroid")
  count <- data %>% select(starts_with("final_cell_type"))
  
  # Find the k nearest neighbors 
  neighbors <- nearest_neighbor_search(distances(as.matrix(pos)), k = 5)[-1, ]
  nnexpr <- seq_len(nrow(count)) %>% map_dfr(~ count %>% slice(neighbors[, .x]) %>% colSums())
  nn.view <- create_view("nearest", nnexpr, "nn")
  
  # Try to run misty
  count %>% 
    create_initial_view() %>% 
    add_views(nn.view) %>% 
    run_misty(results.folder = paste0(out_dir, .Platform$file.sep, name), bypass.intra = TRUE)
}

###############################
###############################


# Read in datafile
input_folder <- "/Users/miguelibarra/PycharmProjects/MI_misty_and_symdata/data/ohe"
out_dir <- "/Users/miguelibarra/PycharmProjects/MI_misty_and_symdata/output_knn_5/"


# Get the list of all files in the input folder
file_list = input_folder %>% list.files(full.names = TRUE)

# Run misty
results_folders <- file_list %>% map_chr(my_mysty, out_dir)



