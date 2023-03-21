##################################
# Misty script for ct from Miguel
##################################

# Script source (adapted): https://github.com/SchapiroLabor/hanover_liver_cancer/blob/main/R/hanover_liver_data_misty_CT_margin.R

########## Did run, but id not provie auto-importance cell types

# Import libraries
# MISTy
library (mistyR)
library(future)

# data manipulation
library(dplyr)
library(purrr)
library(distances)
library(tidyverse)

# plotting
library(ggplot2)

# Multisession for parallel computing
plan(multisession)

###################
# Define function
###################
my_mysty <- function(path, out){
  # Get name
  name <- basename(path) 
  
  # Read data and split positions and counts
  data <- read.csv(file=path, header=TRUE) %>% as_tibble()
  pos <- data %>% select("x", "y")
  #count <- data %>% select(-c("X", "Y"))
  
  my_vec = data$ct
  uniq_entries <- unique(my_vec)
  
  # Create a matrix of 0s with the same number of rows as the vector and the
  # same number of columns as the unique entries
  my_matrix <- matrix(0, nrow = length(my_vec), ncol = length(uniq_entries),
                      dimnames = list(NULL, uniq_entries))
  
  # Use a loop to set the elements of the matrix to 1s where the vector matches the column name
  for (i in 1:length(uniq_entries)) {
    my_matrix[my_vec == uniq_entries[i], i] <- 1
  }
  
  count = as.data.frame.matrix(my_matrix)
  colnames(count) = paste0("X", colnames(count))
  
  count2 = count
  colnames(count2) = paste0("juxta_", colnames(count))
  
  count = cbind(count, count2)
  
  # Create initial view, paraview.30, paraview.120 and run misty
  count %>% 
    create_initial_view() %>%
    add_juxtaview(pos, neighbor.thr = 15) %>%
    add_juxtaview(pos, neighbor.thr = 30) %>%
    run_misty(#results.folder = paste0(out, .Platform$file.sep, name),
              results.folder = paste0(out, name),
              bypass.intra = TRUE)
  
}
####################
# run functino for complete folder
####################

#results_folders <- file_list %>% map_chr(my_mysty, out_dir)

####################
# Normal tissue
####################
in_dir = "./../../../../data" #--> with or without line?
out_dir = "./../output/"
fig_dir = "./../images/"


file_list = in_dir %>% list.files(full.names = TRUE, pattern = ".csv")
results_folders <- file_list %>% map_chr(my_mysty, out_dir)

# Show results
misty.results <- collect_results(results_folders)

# Summary results
summary(misty.results)

#################### Improvement stats ########################################
# Plot improvement stats
misty.results %>% plot_improvement_stats("gain.R2")
ggsave(paste0(fig_dir, .Platform$file.sep, "gainR2-margin.png"))

misty.results %>% plot_improvement_stats("gain.RMSE")
ggsave(paste0(fig_dir, .Platform$file.sep, "gainRMSE-margin.png"))

# Organize by R2
misty.results$improvements %>%
  filter(measure == "p.R2") %>%
  group_by(target) %>% 
  summarize(mean.p = mean(value)) %>%
  arrange(mean.p)

#################### Contributions ############################################
# Plot contributions
misty.results %>% plot_view_contributions()
ggsave(paste0(fig_dir, .Platform$file.sep, "contributions-intra-margin.png"))


#################### Interaction heatmap ######################################
# Plot interaction heatmap for intra,  paraview.30 and  paraview.120
# misty.results %>% plot_interaction_heatmap(view = "intra", cutoff = 0)
# ggsave(paste0(out_dir, .Platform$file.sep, "interaction-intra-margin.png"))

misty.results %>% plot_interaction_heatmap(view = "juxta.15", cutoff = 0)
ggsave(paste0(fig_dir, .Platform$file.sep, "interaction-para30-margin.png"))

misty.results %>% plot_interaction_heatmap(view = "juxta.30", cutoff = 0)
ggsave(paste0(fig_dir, .Platform$file.sep, "interaction-para120-margin.png"))

#################### Contrast heatmap ########################################
# Plot contrast interactions between intra an paraview.10
# misty.results %>% plot_contrast_heatmap("intra", "para.30", cutoff = 0)
# ggsave(paste0(out_dir, .Platform$file.sep, "contrast-intra_para30-margin.png"))

#misty.results %>% plot_contrast_heatmap("intra", "para.120", cutoff = 0)
#ggsave(paste0(fig_dir, .Platform$file.sep, "contrast-intra_para120-margin.png"))

misty.results %>% plot_contrast_heatmap("para.30", "para.120", cutoff = 0)
ggsave(paste0(fig_dir, .Platform$file.sep, "contrast-para30_para120-margin.png"))

##################### Communities  ############################################
# Plot Interaction communities
# png(file=paste0(fig_dir, .Platform$file.sep, "communities-intra-margin.png"), width=500, height=500)
# misty.results %>% plot_interaction_communities("intra", cutoff = 0.0)
# dev.off()

png(file=paste0(fig_dir, .Platform$file.sep, "communities-para30-margin.png"), width=500, height=500)
misty.results %>% plot_interaction_communities("para.30", cutoff = 0.0)
dev.off()

png(file=paste0(fig_dir, .Platform$file.sep, "communities-para120-margin.png"), width=500, height=500)
misty.results %>% plot_interaction_communities("para.120", cutoff = 0.0)
dev.off()
