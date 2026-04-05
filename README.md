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

### Step 3: Alignment Results
- **Tool:** Minimap2 -ax map-hifi
- **Command:** `./minimap2/minimap2 -ax map-hifi -t 4 reference/hg38.mmi data/HG00276.fastq.gz > data/HG00276_aligned.sam`
- **Status:** Currently Processing...

### Milestone Reached: Data Processing Complete
- [x] **Alignment:** Minimap2 finished in ~16 minutes with 95% CPU efficiency.
- [x] **Sorting:** Samtools sorted 424MB of data entirely in-memory (high-performance).
- [x] **Indexing:** BAM index (.bai) verified and functional for rapid gene lookup.
- [x] **Storage Optimization:** Original SAM removed; 80% reduction in file size achieved.

### Current Stage: Variant Calling (GATK4)
- **Status:** Initiating HaplotypeCaller for HG00276.

## Pipeline Execution Details

### Standardizing BAM Headers
To ensure GATK compatibility, we inject Read Group (RG) information:
```bash
samtools addreplacerg -r "@RG\tID:1\tPL:PACBIO\tLB:lib1\tSM:HG00276\tPU:1" \
  -o data/HG00276_final.bam data/HG00276_sorted.bam
```

### Variant Calling (GATK4)
We utilize GATK HaplotypeCaller in GVCF mode to identify germline variants:
```bash
gatk --java-options "-Xmx12g" HaplotypeCaller \
  -R reference/hg38.fa \
  -I data/HG00276_final.bam \
  -O results/HG00276_raw_variants.g.vcf \
  -ERC GVCF
```
