#!/usr/bin/env bash
# This script will perform the alignment of the fastq files against the GRCh38 genome using the Ensembl annotations (v91).

base_dir="$HOME"/"hdd1/PRJ0000003_CDILFIB"
output_dir="$base_dir"/"output/02_gene_expression"
sam_dir="$output_dir"/"sam"
samplesheet="$base_dir"/"data/samples/samples_PROJ0000003_DEEXPRNA_V6.csv"

rawdata_dir="$HOME"/"hdd1/raw_data"
fastq_dir="$rawdata_dir"/"fastq/GS_102911-001"

commondata_dir="$HOME"/"hdd1/common_data"
index_dir="$commondata_dir"/"sequence_index/STAR"

mapfile -t gsids < <(grep -Eo '[0-9\-]{14}' "$samplesheet")
for gsid in ${gsids[@]}; do
	echo "Aligning $gsid"
	sam_output_dir="$sam_dir"/"$gsid"
	mkdir -p "$sam_output_dir"

	mapfile -t reads < <(find "$fastq_dir" -name *"$gsid"*".fastq.gz")
	reads=($(IFS=","; echo "${reads[*]}"))
	echo $reads

	STAR --runThreadN 8 --genomeDir "$index_dir"/"ensembl_GRCh38_r91" --readFilesIn $reads --readFilesCommand zcat --outFileNamePrefix "$sam_output_dir"/"$gsid"_ |& tee -a "$sam_output_dir"/"STAR.log.txt"
done
