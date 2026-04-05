#!/bin/bash
# PacBio PGX Pipeline - Step 4: Variant Calling
# This script standardizes the BAM and runs GATK HaplotypeCaller

# 1. Add Read Group (RG) Header - Required by GATK
echo "Adding Read Group headers..."
samtools addreplacerg -r "@RG\tID:1\tPL:PACBIO\tLB:lib1\tSM:HG00276\tPU:1" \
  -o ../data/HG00276_final.bam \
  ../data/HG00276_sorted.bam

# 2. Index the final BAM
echo "Indexing final BAM..."
samtools index ../data/HG00276_final.bam

# 3. Run GATK HaplotypeCaller (Optimized for 12GB RAM)
echo "Starting GATK HaplotypeCaller at $(date)..."
/home/prativaadhikari75/projects/pacbio-pgx-pipeline/tools/gatk-4.6.2.0/gatk --java-options "-Xmx12g" HaplotypeCaller \
  -R ../reference/hg38.fa \
  -I ../data/HG00276_final.bam \
  -O ../results/HG00276_raw_variants.g.vcf \
  -ERC GVCF
