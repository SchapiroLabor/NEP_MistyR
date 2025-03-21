library(tidyverse)

### PATHS
# either symmetric or asymmetric dataset folder
input_dir = "./../../20250225_output_Miguel_misty/output_delaunay/20250217_asym01_nbh2_1000dim_grid200_300iter_50swaps_ohe/"
output_path = "./../../../Comparison/202411_results_simfixed_asym/Misty_delauany_abundance_4ct_cross01.csv"
data <- list.files(path = input_dir, recursive = TRUE, pattern = "\\juxta.40.txt$")

### DATA WRANGLING
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
    dat$label1 = rep(str_extract(x, "ct\\d+"), times= length(nrow(dat)))
    dat$label1 = rep(str_extract(x, "_.+_"), times= length(nrow(dat)))
    dat$label1 = gsub("_", "", dat$label1)
    dat$sample = rep(i, times= length(nrow(dat)))
    tab = rbind(tab, dat)
  }
}

# create labels for interactions
tab$interaction =  paste(tab$target, tab$label1, sep = "_")
tab = tab %>% select(-target, -label1)
tab$sample = sub(".csv", "", tab$sample)

tab$interaction = gsub("ct", "", tab$interaction)
tab$interaction = gsub("pct_", "", tab$interaction)
tab$interaction = gsub("p_", "", tab$interaction)

df = as.data.frame(spread(tab, key = interaction, value = imp))
rownames(df) = df$sample
df = df[,-1]

df <- data.frame(lapply(df, function(x) ifelse(is.na(x) | is.nan(x), 0, x)))
colnames(df) = sub("X", "", colnames(df) )
df = as.data.frame(df)

### SAVE
write.csv(df,file=output_path,row.names = TRUE)

### PLOTTING
pheatmap(df, treeheight_row = 0, treeheight_col = 0, show_rownames = FALSE)

sessionInfo()