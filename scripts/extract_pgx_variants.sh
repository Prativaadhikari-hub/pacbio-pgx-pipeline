#!/usr/bin/env bash

set -euo pipefail

# Extract selected pharmacogene-associated records from
# an ANNOVAR-annotated VCF.
#
# Current analysis focuses on nine CYP pharmacogenes.

INPUT="${1:-../results/HG00276_annotated.hg38_multianno.vcf}"
OUTPUT="${2:-../results/pgx_variants.vcf}"

PGX_GENES='CYP1A2|CYP2B6|CYP2C8|CYP2C9|CYP2C19|CYP2D6|CYP3A4|CYP3A5|CYP4F2'

echo "Extracting PGx-associated records from:"
echo "${INPUT}"

# Preserve VCF headers.
grep '^#' "${INPUT}" > "${OUTPUT}"

# Extract records annotated to one or more selected pharmacogenes.
grep -v '^#' "${INPUT}" \
    | grep -E "Gene.refGene=(${PGX_GENES})(,|;)|Gene.refGene=[^;]*,(${PGX_GENES})(,|;)" \
    >> "${OUTPUT}"

COUNT=$(grep -vc '^#' "${OUTPUT}")

echo "PGx-associated VCF records: ${COUNT}"
echo "Output: ${OUTPUT}"
