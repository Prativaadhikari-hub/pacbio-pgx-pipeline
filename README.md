# PacBio HiFi Full-Genome Pharmacogenomics Variant Analysis

## Overview

This project implements a reproducible bioinformatics workflow for analyzing **PacBio HiFi long-read sequencing data** generated using the **Twist Alliance Long-Read Pharmacogenomics (PGx) Panel**.

The project extends a UC San Diego Genomic Sequencing Technologies course exercise that initially focused on chromosome 10 and the pharmacogenes **CYP2C9** and **CYP2C19**. Following the instructor's recommendation to extend the analysis beyond chromosome 10, PacBio HiFi reads were aligned against the **complete GRCh38/hg38 human reference genome**, followed by germline variant calling, functional annotation, and focused analysis of selected pharmacogenes.

The project demonstrates an end-to-end long-read bioinformatics workflow using **Minimap2, SAMtools, GATK4, ANNOVAR, IGV, Bash, and Linux**.

---

## Project Objectives

The goals of this project were to:

1. Align PacBio HiFi reads to the complete hg38 human reference genome.
2. Process and index long-read genomic alignments.
3. Perform germline SNV and indel calling with GATK4.
4. Functionally annotate variants using ANNOVAR.
5. Extract and summarize variants associated with selected pharmacogenes.
6. Inspect a complex pharmacogenomic locus using IGV.
7. Build a reproducible command-line workflow suitable for further PGx analysis.

---

## Dataset

**Sample:** HG00276
**Sequencing:** PacBio HiFi / CCS
**Dataset:** Twist Alliance Long-Read Pharmacogenomics Panel
**Reference genome:** GRCh38 / hg38

The sequencing panel targets **49 pharmacogenes**. The current downstream results summary focuses on nine CYP genes:

* CYP1A2
* CYP2B6
* CYP2C8
* CYP2C9
* CYP2C19
* CYP2D6
* CYP3A4
* CYP3A5
* CYP4F2

Large FASTQ, reference genome, BAM, and complete genome-wide variant files are not included in this repository because of their size.

Dataset metadata is provided in `data/sample_info.txt`.

---

## Analysis Workflow

```text
PacBio HiFi FASTQ
        |
        v
Minimap2
Full-genome alignment to hg38
        |
        v
SAM / BAM
        |
        v
SAMtools
Coordinate sorting + indexing
        |
        v
Read-group assignment
        |
        v
GATK HaplotypeCaller
        |
        v
GVCF
        |
        v
GATK GenotypeGVCFs
        |
        v
Genome-wide VCF
        |
        v
ANNOVAR
Functional annotation
        |
        v
PGx-associated variant extraction
        |
        v
Selected CYP-gene analysis + IGV inspection
```

---

## Tools

| Tool           | Role in analysis                                                 |
| -------------- | ---------------------------------------------------------------- |
| **Minimap2**   | PacBio HiFi read alignment to hg38                               |
| **SAMtools**   | Alignment processing, sorting, indexing, and read-group handling |
| **GATK4**      | Germline variant calling and genotyping                          |
| **ANNOVAR**    | Gene-based and clinical variant annotation                       |
| **IGV**        | Visual inspection of genomic alignments and loci                 |
| **Bash/Linux** | Pipeline automation, filtering, and result processing            |

---

## Variant Calling and Annotation

PacBio HiFi reads were aligned to the complete hg38 reference genome using the Minimap2 `map-hifi` preset.

The alignments were coordinate-sorted with SAMtools, read-group information was added for downstream GATK processing, and the final BAM was indexed.

Germline variant calling was performed using **GATK HaplotypeCaller** in GVCF mode. **GenotypeGVCFs** was then used to produce a genotyped VCF containing SNVs and indels.

The resulting variants were functionally annotated with **ANNOVAR**.

The end-to-end workflow is documented in:

```text
scripts/run_pgx_pipeline.sh
```

Individual processing stages are also provided as separate scripts for transparency.

---

## Pharmacogene-Focused Analysis

Following genome-wide variant calling and ANNOVAR annotation, the annotated VCF was filtered for records associated with nine selected CYP pharmacogenes.

The extraction is implemented in:

```text
scripts/extract_pgx_variants.sh
```

The analysis identified **532 unique VCF records associated with at least one of the nine selected CYP genes**.

### Annotated Records by Gene

| Gene    | Annotated records |
| ------- | ----------------: |
| CYP1A2  |                40 |
| CYP2B6  |                74 |
| CYP2C8  |               129 |
| CYP2C9  |               119 |
| CYP2C19 |                73 |
| CYP2D6  |                 4 |
| CYP3A4  |                34 |
| CYP3A5  |                13 |
| CYP4F2  |                74 |

Per-gene counts do not sum to 532 because an individual ANNOVAR record can be associated with more than one gene.

The filtered records and summary are available in:

```text
results/pgx_variants.vcf
results/pgx_variant_summary.tsv
```

---

## CYP2D6 / CYP2D7 Locus

The **CYP2D6/CYP2D7 region** was inspected because it represents a challenging pharmacogenomic locus with substantial sequence homology.

Four ANNOVAR records in the selected-gene analysis were associated with both **CYP2D6 and CYP2D7**. These records occurred on the alternate reference contig:

```text
chr22_KB663609v1_alt
```

The four records included two synonymous and two nonsynonymous SNVs.

No CYP2D6-annotated records were identified on canonical `chr22` using the same annotation-filtering approach.

Because the observed records occur on an alternate contig and are jointly annotated to CYP2D6 and CYP2D7, they are **not interpreted here as unambiguous CYP2D6-specific variants or star alleles**.

IGV was used for visual inspection of the locus.

![CYP2D6 locus visualization](images/cyp2d6_variant.png)

This observation illustrates an important challenge when analyzing highly homologous pharmacogenomic loci.

---

## Repository Structure

```text
pacbio-pgx-pipeline/
├── README.md
├── .gitignore
│
├── data/
│   └── sample_info.txt
│
├── images/
│   └── cyp2d6_variant.png
│
├── results/
│   ├── pgx_variant_summary.tsv
│   └── pgx_variants.vcf
│
└── scripts/
    ├── extract_pgx_variants.sh
    ├── run_alignment.sh
    ├── run_post_alignment.sh
    ├── run_variant_calling.sh
    └── run_pgx_pipeline.sh
```

---

## Key Results

* Implemented a **full-genome PacBio HiFi alignment and variant-calling workflow** against hg38.
* Automated long-read alignment and BAM processing using Minimap2 and SAMtools.
* Performed germline variant calling using GATK HaplotypeCaller and GenotypeGVCFs.
* Annotated genome-wide variants using ANNOVAR.
* Extracted **532 unique records associated with nine selected CYP pharmacogenes**.
* Generated reproducible per-gene variant summaries.
* Investigated the complex CYP2D6/CYP2D7 region and documented ambiguity associated with alternate-contig annotation.
* Organized scripts, representative results, metadata, and visualization into a reproducible GitHub project.

---

## Limitations

This project is an **educational and portfolio bioinformatics analysis**, not a validated clinical pharmacogenomics pipeline.

Important limitations include:

* Although the sequencing panel targets 49 pharmacogenes, the current summarized downstream analysis focuses on nine CYP genes.
* ANNOVAR gene association does not by itself establish pathogenicity or clinical significance.
* The reported counts represent annotated VCF records associated with the selected genes, not independently validated clinically actionable variants.
* CYP2D6/CYP2D7 is a highly homologous genomic region requiring specialized approaches for definitive locus-specific interpretation.
* CYP star alleles, diplotypes, metabolizer phenotypes, and clinical drug-response recommendations were not assigned.
* The workflow has not been validated for clinical diagnostic use.

---

## Skills Demonstrated

**Long-read genomics:** PacBio HiFi, human genome alignment, variant analysis
**Bioinformatics tools:** Minimap2, SAMtools, GATK4, ANNOVAR, IGV
**Data formats:** FASTQ, SAM, BAM, GVCF, VCF
**Computational skills:** Bash scripting, Linux command line, pipeline automation, genomic data filtering
**Domain:** Pharmacogenomics, germline variant analysis, human genomics

---

## Project Context

This project was developed as an extension of coursework in **Genomic Sequencing Technologies at UC San Diego Extended Studies**.

The original course exercise focused on chromosome 10 and CYP2C9/CYP2C19. The instructor subsequently recommended extending the analysis to the complete human genome using PacBio HiFi reads generated from the Twist Alliance Long-Read Pharmacogenomics Panel.

This repository documents that full-genome extension and subsequent focused pharmacogene analysis.
