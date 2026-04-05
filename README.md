# PacBio Long-Read Pharmacogenomics Pipeline

This project implements a PacBio HiFi long-read variant calling pipeline using the Twist Alliance PGx panel (49 genes) mapped to the hg38 genome.

## Overview
The project performs full-genome alignment of PacBio long reads, variant calling using GATK, and analysis of pharmacogenomics genes. Results can be visualized in IGV.

## Objectives
- Perform full-genome alignment
- Call variants using GATK
- Analyze pharmacogenomics genes (49-gene panel)
- Visualize results in IGV

## Tools
- Minimap2
- SAMtools
- GATK4
- ANNOVAR
- IGV

## Directory Structure
- data/       # Raw FASTQ files
- reference/  # Reference genome
- scripts/    # Analysis scripts
- results/    # Output files
- logs/       # Logs

## Status
Project setup in progress
