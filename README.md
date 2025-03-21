# NEP_MistyR

Paper: https://doi.org/10.1186/s13059-022-02663-5

Multiview Intercellular SpaTial modeling framework (MISTy) is an explainable machine learning framework for knowledge extraction and analysis of single-cell, highly multiplexed, spatially resolved data. The flexible framework allows the creation of different views, an intra-, juxta-, and paraview, and analyses the relationships between the views. In our case, we look at the immediate neighborhood of cells and are interested in the juxtaview. Within the juxtaview, we can analyse which close cells can be used as predictors for other cells, so cell-cell interactions in terms of proximities. This task does not leverage the whole potential of the framework.

# Usage

## Source

The script src/Tutorial_Misty_adapted.R is adapted from the script the authors of MistyR used to create their figures (https://github.com/saezlab/misty_pipelines/blob/master/insilico/structure_pipeline.R). As indicated in the script, only the first code chunk is used for analysis. The output of the NEP analysis were further compared to other methods in https://github.com/SchapiroLabor/NEP_comparison

## Installation

MistyR can be installed with: 
`BiocManager::install("mistyR")` (v 1.6.1)

Other dependencies are specidied in `session_info.txt`.

## Data

### In silico tissue (IST) data
Simulated .csv data with x, y, and ct annotation columns were used. The asymmetric and symmetric in silico tissue (IST) datasets were generated as described here: https://github.com/SchapiroLabor/NEP_IST_generation. 

### Myocardial infarction (MI) data

Sequential Immunofluorescence data was accessed via Synapse (project SynID : syn51449054): https://www.synapse.org/Synapse:syn51449054. The dataframe with phenotypes was accessed within the project at:  https://www.synapse.org/Synapse:syn65487454.

## Scripts

`/src`:
- `/misty_mi_knn5.R`: This script runs mistyR on the simulated data with a neighborhood definition of KNN=5.
- `/misty_simulated_delaunay.R`: This script runs mistyR on the MI data using a Delaunay triangulation a neighborhood definition.
- `/reshape_misty_output_mi_knn5.R`: This script takes the output files from `/misty_mi_knn5.R` and reformats them into a NEP pair x sample data frame for further comparison.
- `/reshape_misty_output_simulated_delaunay.R`: This script takes the output files from `/misty_simulated_delaunay.R` and reformats them into a NEP pair x sample data frame for further comparison.

`/notebooks`:
- `/MI_ohe_conversion.ipynb`: This notebook converts MI data to one-hot encoding for MistyR.
- `/simulated_ohe_conversion.ipynb`: This notebook converts the simulated data to one-hot encoding for MistyR.
