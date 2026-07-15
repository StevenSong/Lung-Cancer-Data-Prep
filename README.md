# Lung-Cancer-Data-Prep
Download and embed TCGA and CPTAC lung adenocarcinoma and squamous cell carcinoma data (WSIs and RNAseq)

## Datasets
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

## Steps
1. Histopathology Whole Slide Images:
    1. Download patch-level embeddings from [MahmoodLab/UNI2-h-features](https://huggingface.co/datasets/MahmoodLab/UNI2-h-features)
    1. Average patch-level embeddings into slide-level embeddings
1. Bulk RNA-seq Gene Expression:
    1. Download RNA-seq data from GDC
    1. Embed with BulkRNABert (to prevent leakage, make sure to use [checkpoint which did not train over TCGA](https://github.com/instadeepai/multiomics-open-research/tree/main/checkpoints/bulk_rna_bert_gtex_encode))
