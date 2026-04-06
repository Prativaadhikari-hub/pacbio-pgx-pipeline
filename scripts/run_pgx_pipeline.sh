#!/bin/bash
# Twist Alliance Long-Read PGx Pipeline
# Target: 49 Pharmacogenomic Genes (CYP2D6, CYP2C19, etc.)

# 1. Alignment with Minimap2 (HiFi Preset)
minimap2 -ax map-hifi ../reference/hg38.fa ../data/HG00276.fastq.gz | \
samtools sort -@ 4 -o ../data/HG00276_sorted.bam

# 2. Add Read Groups & Index (Crucial for GATK)
samtools addreplacerg -r "@RG\tID:1\tPL:PACBIO\tLB:TwistPGx\tSM:HG00276\tPU:1" \
  -o ../data/HG00276_final.bam ../data/HG00276_sorted.bam
samtools index ../data/HG00276_final.bam

# 3. GATK HaplotypeCaller (GVCF Mode)
/home/prativaadhikari75/projects/pacbio-pgx-pipeline/tools/gatk-4.6.2.0/gatk --java-options "-Xmx12g" HaplotypeCaller \
  -R ../reference/hg38.fa \
  -I ../data/HG00276_final.bam \
  -O ../results/HG00276_raw_variants.g.vcf \
  -ERC GVCF

# 4. Final Genotyping
/home/prativaadhikari75/projects/pacbio-pgx-pipeline/tools/gatk-4.6.2.0/gatk --java-options "-Xmx4g" GenotypeGVCFs \
  -R ../reference/hg38.fa \
  -V ../results/HG00276_raw_variants.g.vcf \
  -O ../results/HG00276_final_variants.vcf
