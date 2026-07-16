# !/bin/bash

set -e

echo "Make sure you cloned this repo with the --recurse-submodules flag,"
echo "as this script uses tooling from the multimodal-cancer-modeling submodule."
echo "If you didn't, run this in the root of this repo:"
echo
echo "git submodule update --init --recursive"
echo
echo "Then make sure you create and activate the conda environment from the submodule."
echo "NOTE: embed_expr_bulkrnabert.py expects TSVs to be organized under case ID subfolders"
echo "==================="


echo "Downloading BulkRNABert checkpoint"
REPO_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

CKPT_DIR="$REPO_ROOT/data/BulkRNABert-checkpoints/bulk_rna_bert_gtex_encode"
CKPT_REPO="https://raw.githubusercontent.com/instadeepai/multiomics-open-research"
mkdir -p "$CKPT_DIR"
cd "$CKPT_DIR"
curl -LO "$CKPT_REPO/16421c0/checkpoints/bulk_rna_bert_gtex_encode/config.json"
curl -LO "$CKPT_REPO/16421c0/checkpoints/bulk_rna_bert_gtex_encode/params.joblib"
cd $REPO_ROOT
echo "==================="

mkdir -p "$REPO_ROOT/embeddings/RNAseq"
COHORTS=("CPTAC-LSCC" "CPTAC-LUAD" "TCGA-LUAD" "TCGA-LUSC")
for COHORT in "${COHORTS[@]}"; do
    echo "Embedding $COHORT RNAseq data"
    python "$REPO_ROOT/multimodal-cancer-modeling/embed/embed_expr_bulkrnabert.py" \
    --dataset-folder "$REPO_ROOT/data/RNAseq/$COHORT/TSVs" \
    --preprocessed-cache "$REPO_ROOT/data/RNAseq/$COHORT-preprocessed_genes.csv" \
    --output-h5 "$REPO_ROOT/embeddings/RNAseq/$COHORT.h5" \
    --gene-list "$REPO_ROOT/multimodal-cancer-modeling/data/bulkrnabert_gene_list.txt" \
    --rna-seq-column tpm_unstranded \
    --model-name bulk_rna_bert_gtex_encode \
    --weights-folder "$REPO_ROOT/data/BulkRNABert-checkpoints" \
    --aggregation mean
done
