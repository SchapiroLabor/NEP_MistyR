### Run Misty from github Fig2
# https://github.com/saezlab/misty_pipelines/blob/master/insilico/structure_pipeline.R

library(mistyR)
library(tidyverse)
library(magrittr)
library(future)
library(ggvoronoi)
library(cowplot)
library(pheatmap)

# Run MISTy on simulated samples to downstream extract importance value per sample

# Run MISTy
in_dir = "./../../../../data/Sim_nbh15_asym01_1000_grid0.2_1kiter_025kswap/"
out_dir = "./../../output/4ct_check_asym/"


data = in_dir %>% list.files(full.names = TRUE, pattern = ".csv")

#data <- list.files("data/insilico/structure", "tissue.*\\.csv", full.names = TRUE)
plan(multisession)

# set juxta view parameter, indicating distance in which neighbors are still seen as neighbors
l <- 30

data = data %>% walk(\(path){
  all <- read_csv(path)
  all$cell_id = paste0(rownames(all), basename(data))
  all$tissue_id = rep(basename(path), length(all$cell_id))
  pos <- all %>% select(x, y)
  
  ctype <- all %>% select(cell_id, ct) %>% mutate(value = 1) %>%
    group_by(cell_id) %>%
    pivot_wider(names_from = "ct", names_prefix = "ct", values_from = "value") %>%
    ungroup() %>%
    select(-cell_id) %>% replace(is.na(.),0)
  
  ctype.views <- create_initial_view(ctype) %>%
    add_juxtaview(pos, neighbor.thr = l, prefix = "juxta_")
  
  run_misty(ctype.views, bypass.intra = TRUE,
            results.folder = paste0(out_dir, 
                                    basename(path)
                                    #str_extract(path, "\\d")
            ))
})

###

#create standard comparison matrix
csv_dir <- "./../../output/4ct_check_asym/"

# Recursively list all .csv files in the directory and its subdirectories

#data <- list.files(path = csv_dir, recursive = TRUE, pattern = "\\juxta.30.txt$")

data <- list.files(path = csv_dir, recursive = TRUE, pattern = "\\juxta.30.txt$")

all = list()

for (i in data){
  all[[i]] <- read_csv(paste0(csv_dir,i))
}

#all[[1000]]

tab = data.frame(target = character(),
                 imp = double(),
                 label1 = character(),
                 sample = character())

names = unique(sub("/.*", "", data))
subnames = unique(sub("^.*/", "", data))
for (i in names){
  for (x in subnames){
    dat = all[[paste(i, x, sep = "/")]]
    dat$label1 = rep(str_extract(x, "ct\\d+"), times= length(nrow(dat)))
    dat$sample = rep(i, times= length(nrow(dat)))
    tab = rbind(tab, dat)
  }
}
back = tab
# create labels for interactinos
tab$interaction =  paste(tab$target, tab$label1, sep = "_")
tab = tab %>% select(-target, -label1)
tab$sample = sub("4ct_self_delaunay", "", tab$sample)

try = as.data.frame(spread(tab, key = interaction, value = imp))
rownames(try) = try$sample
try = try[,-1]

#save table

write.csv(try,"./../../../Comparison/results_4ct_asym_0.2grid_self/MistyCheck_juxta30_delaunay_4ct_cross01.csv")

# Look at heatmap
pheatmap(try)
colnames(try) = sub("juxta_", "", colnames(try))
colnames(try) = sub("ct", "", colnames(try))

pheatmap(try, treeheight_row = 0, treeheight_col = 0, show_rownames = FALSE)

sessionInfo()

