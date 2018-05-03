#!/usr/bin/env bash
# This script will clean the sam files, convert to bam, sort the bam files, and create indexes.

base_dir="$HOME"/"hdd1/PRJ0000003_CDILFIB"
output_dir="$base_dir"/"output/02_gene_expression"

sam_dir="$output_dir"/"sam"
bam_dir="$output_dir"/"bam"
mkdir $bam_dir

samplesheet="$base_dir"/"data/samples/samples_PROJ0000003_DEEXPRNA_V6.csv"

mapfile -t gsids < <(grep -Eo '[0-9\-]{14}' "$samplesheet")

for gsid in ${gsids[@]}; do
	echo "$gsid"

	sam_file="$sam_dir/$gsid/$gsid""_Aligned.out.sam"
	echo $sam_file

	#Remove unmapped reads and multiple mappings (4 + 256 = 260)
	#Remove reads with mapping score < 10
	#Remove mitochondrial sequences
	#Convert SAM to BAM
	samtools view -@ 8 -S -h -F 260 -q 10 "$sam_file" | awk '($1 ~ /^@/) || ($3 != "MT") { print $0 }' | samtools view -@ 8 -bS -o "$bam_dir"/"$gsid.tmp.bam" - |& tee -a "$bam_dir"/"samtools.log.txt"
	#Sort reads
	samtools sort -@ 8 -m 4G -o "$bam_dir"/"$gsid.bam" "$bam_dir"/"$gsid.tmp.bam" |& tee -a "$bam_dir"/"samtools.log.txt"
	#Create index
	samtools index "$bam_dir"/"$gsid.bam" |& tee -a "$bam_dir"/"samtools.log.txt"
	#Clean up
	rm "$bam_dir"/"$gsid.tmp.bam"
done
