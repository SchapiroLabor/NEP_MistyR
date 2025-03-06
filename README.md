# NEP_MistyR

Paper: https://doi.org/10.1186/s13059-022-02663-5

Multiview Intercellular SpaTial modeling framework (MISTy) is an explainable machine learning framework for knowledge extraction and analysis of single-cell, highly multiplexed, spatially resolved data. The flexible framework allows the creation of different views, an intra-, juxta-, and paraview, and analyses the relationships between the views. In our case, we look at the immediate neighborhood of cells and are interested in the juxtaview. Within the juxtaview, we can analyse which close cells can be used as predictors for other cells, so cell-cell interactions in terms of proximities. This task does not leverage the whole potential of the framework.

# Usage

## Source

The script src/Tutorial_Misty_adapted.R is adapted from the script the authors of MistyR used to create their figures (https://github.com/saezlab/misty_pipelines/blob/master/insilico/structure_pipeline.R). As indicated in the script, only the first code chunk is used for analysis.

## Installation

MistyR can be installed with: 
- `BiocManager::install("mistyR")` (v 1.6.1)

Other dependencies are 
- pheatmap_1.0.12 
- cowplot_1.1.1 
- ggvoronoi_0.8.5
- magrittr_2.0.3
- forcats_1.0.0
- stringr_1.5.0
- readr_2.1.3
- tidyr_1.3.0
- tibble_3.1.8
- ggplot2_3.4.0
- tidyverse_1.3.2
- distances_0.1.9
- purrr_1.0.1
- dplyr_1.1.0
- future_1.31.0

## Data

Simulated data with x, y, and ct annotation columns is used. The script src/Tutorial_Misty_adapted.R uses a relative input datapath to a data folder 2 levels above the cloned GitHub repo. The output files are stored in a form you created output folder on the same level as the cloned GitHub repo. The downstream notebook creates an initial heatmap visualization of the results and takes the stored output from the initial script as input.

## Scripts

`/src`:
- `/misty_mi_knn5.R`: This script runs mistyR on the simulated data with a neighborhood definition of KNN=5.
- `/misty_simulated_delaunay.R`: This script runs mistyR on the MI data using a Delaunay triangulation a neighborhood definition.

`/notebooks`:
- `/MI_ohe_conversion.ipynb`: This notebook converts MI data to one-hot encoding for MistyR.
- `/simulated_ohe_conversion.ipynb`: This notebook converts the simulated data to one-hot encoding for MistyR.
