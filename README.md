# PacBio Long-Read Pharmacogenomics (PGx) Pipeline

## Project Overview
This project implements a full-genome analysis pipeline for PacBio HiFi long-read data, specifically targeting the **Twist Alliance Long-Read PGx panel**. This panel covers 49 genes (including CYP2D6 and CYP2C19) that are traditionally difficult to resolve with short-read sequencing due to structural variants and pseudogenes.

## Tools & Technologies
- **Alignment:** Minimap2 (map-hifi)
- **Data Processing:** Samtools (Read Group injection & Indexing)
- **Variant Calling:** GATK4 HaplotypeCaller (v4.6.2.0)
- **Target Genes:** 49 PGx genes in "dark regions" of the genome.

## Pipeline Workflow
1. **Mapping:** Aligning raw FASTQ to GRCh38/hg38.
2. **Standardization:** Injecting @RG tags for GATK compatibility.
3. **Discovery:** Generating Genomic VCFs (GVCF) to capture high-confidence calls.
4. **Genotyping:** Producing finalized VCFs for allele interpretation.

## Key Findings
- Successfully resolved variants in the 49 target PGx genes.
- Leveraged PacBio long reads to traverse complex genomic regions (low mapping quality regions in Illumina).
