#!/usr/bin/env bash
# Run FastQC on the .fastq files to ensure the files are of good quality and to check whether trimming is necessary.

base_dir="$HOME"/"hdd1/PRJ0000003_CDILFIB"
samplesheet="$base_dir"/"data/samples/samples_PROJ0000003_DEEXPRNA_V6.csv"
fastqc_dir="$base_dir"/"output/02_gene_expression/fastqc"

fastq_dir="$HOME"/"hdd1/raw_data/fastq/GS_102911-001"

mapfile -t gsids < <(grep -Eo '[0-9\-]{14}' "$samplesheet")
for gsid in ${gsids[@]}; do
	echo $gsid
	fastqc_output_dir="$fastqc_dir"/"$gsid"
	mkdir -p "$fastqc_output_dir"

	mapfile -t reads < <(find "$fastq_dir" -name *"$gsid"*".fastq.gz")
	for read in ${reads[@]}; do
		#echo $read
		fastqc --outdir="$fastqc_output_dir" --thread 8 $read |& tee -a "$fastqc_dir"/"fastqc.log.txt"
	done
done
