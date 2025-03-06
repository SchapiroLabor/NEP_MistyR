### Reshape Misty_output from misty_mi_knn5.R

#load packages
library(tidyverse)

### PATHS
input_dir = "./../../20250225_output_Miguel_misty/output_knn_5/"
output_path = "./../../../Comparison/20250218_results_MI/MI_Misty_knn5.csv"
data <- list.files(path = input_dir, recursive = TRUE, pattern = "nn.txt")


## LOAD DATA
all = list()

for (i in data){
  all[[i]] <- read_csv(paste0(input_dir,i))
}

tab = data.frame(target = character(),
                 imp = double(),
                 label1 = character(),
                 sample = character())

names = unique(sub("/.*", "", data))
subnames = unique(sub("^.*/", "", data))
for (i in names){
  for (x in subnames){
    dat = all[[paste(i, x, sep = "/")]]
    #for sim data
    #dat$label1 = rep(str_extract(x, "ct\\d+"), times= length(nrow(dat)))
    dat$label1 = rep(str_extract(x, "_.+_"), times= length(nrow(dat)))
    dat$label1 = gsub("_", "", dat$label1)
    dat$sample = rep(i, times= length(nrow(dat)))
    tab = rbind(tab, dat)
  }
}

# DATA WRANGLING
tab$interaction =  paste(tab$target, tab$label1, sep = "_")
tab = tab %>% select(-target, -label1)
tab$sample = sub(".csv", "", tab$sample)

df = as.data.frame(spread(tab, key = interaction, value = imp))
rownames(df) = df$sample
df = df[,-1]
df <- data.frame(lapply(df, function(x) ifelse(is.na(x) | is.nan(x), 0, x)))
df = as.data.frame(df)
rownames(df) = sub(".csv", "", names)
colnames(df) = sub("p_", "", colnames(df))
colnames(df) = sub("juxta_", "", colnames(df))
colnames(df) = sub("ct", "", colnames(df))
colnames(df) = sub("final_cell_type_", "", colnames(df))
colnames(df) = sub("finalcelltype", "", colnames(df))

###SAVE
write.csv(df,file=output_path,row.names = TRUE)

### PLOTTING
# Look at heatmap
pheatmap(df, treeheight_row = 0, treeheight_col = 0, show_rownames = FALSE)

sessionInfo()

