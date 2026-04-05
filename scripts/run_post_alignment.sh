#!/bin/bash
# PacBio PGx Pipeline - Part 3: Post-Alignment Processing
# Date: April 2026
# Sample: HG00276

# 1. Convert/Sort SAM to BAM (Binary format)
# Using 4 cores and sorting by genomic coordinates
echo "Starting Samtools Sort at $(date)..."
samtools sort -@ 4 -o ../data/HG00276_sorted.bam ../data/HG00276_aligned.sam

# 2. Index the BAM (Allows rapid searching of specific genes)
echo "Indexing BAM at $(date)..."
samtools index ../data/HG00276_sorted.bam

echo "Post-processing complete at $(date)!"
