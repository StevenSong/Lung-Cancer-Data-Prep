#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

echo "Login to HuggingFace with an account that has accepted the DUA for MahmoodLab/UNI2-h-features."
echo "Additionally, ensure that the access token has read access to the repo."

hf auth login

hf download --repo-type dataset MahmoodLab/UNI2-h-features \
CPTAC/cptac_lscc.tar.gz \
CPTAC/cptac_luad_part1.tar.gz \
CPTAC/cptac_luad_part2.tar.gz \
TCGA/TCGA-LUAD.tar.gz \
TCGA/TCGA-LUSC.tar.gz \
--local-dir $SCRIPT_DIR/../embeddings/patch-embeddings


echo "========================"


echo "Combining downloaded file parts"
cd "$SCRIPT_DIR/../embeddings/patch-embeddings/CPTAC"

PARTS=(cptac_luad_part1.tar.gz cptac_luad_part2.tar.gz)
OUT=cptac_luad.tar.gz

# portable file size in bytes (GNU stat, then BSD/macOS stat)
filesize() { stat -c%s "$1" 2>/dev/null || stat -f%z "$1"; }

# expected combined size = sum of the parts' sizes
EXPECTED_SIZE=0
for p in "${PARTS[@]}"; do
    EXPECTED_SIZE=$(( EXPECTED_SIZE + $(filesize "$p") ))
done

if [[ -f "$OUT" && "$(filesize "$OUT")" == "$EXPECTED_SIZE" ]]; then
    echo "$OUT exists and matches expected size ($EXPECTED_SIZE bytes)."
else
    echo "Combining parts into $OUT"
    cat "${PARTS[@]}" > "$OUT"
    ACTUAL_SIZE="$(filesize "$OUT")"
    if [[ "$ACTUAL_SIZE" != "$EXPECTED_SIZE" ]]; then
        echo "ERROR: combined file size mismatch." >&2
        echo "  expected: $EXPECTED_SIZE" >&2
        echo "  actual:   $ACTUAL_SIZE" >&2
        exit 1
    fi
fi


echo "========================"


echo "Extracting downloaded content (no resume/partial extraction check, will re-extract everything)"

# already in CPTAC dir
cd ..
mkdir -p CPTAC-LUAD CPTAC-LSCC TCGA-LUAD TCGA-LUSC

cd CPTAC
# tar -xzf cptac_luad.tar.gz -C ../CPTAC-LUAD
# tar -xzf cptac_lscc.tar.gz -C ../CPTAC-LSCC
cd ../TCGA
tar -xzf TCGA-LUAD.tar.gz -C ../TCGA-LUAD
tar -xzf TCGA-LUSC.tar.gz -C ../TCGA-LUSC


echo "========================"


echo "Cleaning up (deleting the downloaded .tar.gz files, keeping the extracted .h5 files)"
cd ..
rm -r CPTAC TCGA
