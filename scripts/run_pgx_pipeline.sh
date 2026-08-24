#!/usr/bin/env bash

set -euo pipefail

# PacBio HiFi Full-Genome PGx Variant Analysis
# Sample: HG00276
#
# Workflow:
# PacBio HiFi FASTQ -> Minimap2 -> sorted BAM -> read groups
# -> GATK HaplotypeCaller -> GenotypeGVCFs -> ANNOVAR
#
# The sequencing dataset was generated using the Twist Alliance
# Long-Read Pharmacogenomics Panel. Variant calling is performed
# against the complete hg38 reference genome.

SAMPLE="HG00276"

READS="../data/${SAMPLE}.fastq.gz"
REFERENCE="../reference/hg38.fa"

SORTED_BAM="../data/${SAMPLE}_sorted.bam"
FINAL_BAM="../data/${SAMPLE}_final.bam"

GVCF="../results/${SAMPLE}_raw_variants.g.vcf"
VCF="../results/${SAMPLE}_final_variants.vcf"

ANNOVAR_DB="../humandb"
ANNOVAR_OUT="../results/${SAMPLE}_annotated"

echo "Starting PacBio HiFi PGx analysis for ${SAMPLE}"
echo "Start time: $(date)"

# --------------------------------------------------
# 1. Align PacBio HiFi reads to the complete hg38 genome
# --------------------------------------------------

echo "Aligning reads with Minimap2..."

minimap2 -ax map-hifi "${REFERENCE}" "${READS}" | \
    samtools sort -@ 4 -o "${SORTED_BAM}"

# --------------------------------------------------
# 2. Add read-group information
# --------------------------------------------------

echo "Adding read-group information..."

samtools addreplacerg \
    -r "@RG\tID:1\tPL:PACBIO\tLB:TwistPGx\tSM:${SAMPLE}\tPU:1" \
    -o "${FINAL_BAM}" \
    "${SORTED_BAM}"

# --------------------------------------------------
# 3. Index BAM
# --------------------------------------------------

echo "Indexing BAM..."

samtools index "${FINAL_BAM}"

# --------------------------------------------------
# 4. Germline variant calling in GVCF mode
# --------------------------------------------------

echo "Running GATK HaplotypeCaller..."

gatk --java-options "-Xmx12g" HaplotypeCaller \
    -R "${REFERENCE}" \
    -I "${FINAL_BAM}" \
    -O "${GVCF}" \
    -ERC GVCF

# --------------------------------------------------
# 5. Convert GVCF to genotyped VCF
# --------------------------------------------------

echo "Running GATK GenotypeGVCFs..."

gatk --java-options "-Xmx4g" GenotypeGVCFs \
    -R "${REFERENCE}" \
    -V "${GVCF}" \
    -O "${VCF}"

# --------------------------------------------------
# 6. Functional annotation with ANNOVAR
# --------------------------------------------------

echo "Annotating variants with ANNOVAR..."

table_annovar.pl "${VCF}" "${ANNOVAR_DB}" \
    -buildver hg38 \
    -out "${ANNOVAR_OUT}" \
    -remove \
    -protocol refGene,clinvar,dbnsfp42a \
    -operation g,f,f \
    -nastring . \
    -vcfinput

echo "Pipeline completed successfully."
echo "Finish time: $(date)"
