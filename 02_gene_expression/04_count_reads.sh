#!/usr/bin/env bash
# Here we will count the reads using the featureCounts tool included in the Subread package. Annotations are based on the Ensembl annotations v91.

base_dir="$HOME"/"hdd1/PRJ0000003_CDILFIB"
output_dir="$base_dir"/"output/02_gene_expression"

bam_dir="$output_dir"/"bam"
count_dir="$output_dir"/"counts"
mkdir $count_dir

annotation="$HOME"/"hdd1/common_data/genome/annotation/ensembl/GRCh38/Homo_sapiens.GRCh38.91.gtf"

featureCounts -T 8 -a "$annotation" -t exon -g gene_id -o "$count_dir"/"counts.txt" "$bam_dir"/*.bam
