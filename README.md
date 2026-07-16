# GDC Lung Cancer Classification
This repo serves as a demo of using embeddings of cancer data to do classification over non-small cell lung cancer (NSCLC) cases from the Genomic Data Commons (GDC).

## Data

For our experiments, we'll use the following datasets:
* TCGA-LUAD
    * RNA-seq & WSIs: https://portal.gdc.cancer.gov/projects/tcga-luad
* TCGA-LUSC
    * RNA-seq & WSIs: https://portal.gdc.cancer.gov/projects/tcga-lusc
* CPTAC-LUAD
    * RNA-seq: https://portal.gdc.cancer.gov/projects/cptac-3 (filter for lung primary, disease type adenocarcinomas)
    * WSIs: https://portal.imaging.datacommons.cancer.gov/collections/cptac_luad
* CPTAC-LSCC
    * RNA-seq: https://portal.gdc.cancer.gov/projects/cptac-3 (filter for lung primary, disease type squamous cell neoplasm)
    * WSIs: https://portal.imaging.datacommons.cancer.gov/collections/cptac_lscc

### Overview

1. Histopathology Whole Slide Images:
    1. Download patch-level embeddings from [MahmoodLab/UNI2-h-features](https://huggingface.co/datasets/MahmoodLab/UNI2-h-features)
    1. Filter only tumor slides
    1. Average patch-level embeddings into slide-level embeddings
1. Bulk RNA-seq Gene Expression:
    1. Download RNA-seq data from GDC
    1. Embed with BulkRNABert (to prevent leakage, make sure to use [checkpoint which did not train over TCGA](https://github.com/instadeepai/multiomics-open-research/tree/main/checkpoints/bulk_rna_bert_gtex_encode))

### Download and Embed

All tools to download and embed the data are detailed in the [data-preprocessing](./data-preprocessing) subdirectory. Work through the numbered scripts and notebooks there.

## Models

With embedding data in-hand, we can explore various ways to derive classification models over the embeddings. We'll specifically demonstrate the following classifiers (implemented in [notebooks](./notebooks)):
* Logistic Regression (LR)
* k-Nearest Neighbors (kNN)
