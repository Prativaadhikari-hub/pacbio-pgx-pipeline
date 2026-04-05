#!/bin/bash
# PacBio PGx Pipeline - Part 2: Alignment
# Date: April 2026
# Sample: HG00276

# 1. Define Paths
GENOME="../reference/hg38.mmi"
READS="../data/HG00276.fastq.gz"
OUTPUT="../data/HG00276_aligned.sam"

# 2. Run Minimap2
echo "Starting Alignment at $(date)..."
../minimap2/minimap2 -ax map-hifi -t 4 $GENOME $READS > $OUTPUT
echo "Alignment Finished at $(date)!"
