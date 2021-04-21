#!/usr/bin/env bash
# Run this in the mutation conda environment!
WORKDIR="/mnt/data/mutation"
N_THREADS=20

# Build STAR genome index files
## Human
if [ ! -f "${WORKDIR}/annotation/gencode.v35.annotation.gtf" ]; then
    echo "Unzipping human gencode annotation GTF file"
    gunzip -k "${WORKDIR}/annotation/gencode.v35.annotation.gtf.gz"
fi
if [ ! -f "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" ]; then
    echo "Unzipping human genome fasta file"
    gunzip -k "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa.gz"
fi

if [ ! -d "${WORKDIR}/annotation/STAR_index/human" ]; then
	echo "Generating STAR index for human"
    STAR \
        --runThreadN "${N_THREADS}" \
        --runMode genomeGenerate \
        --genomeDir "${WORKDIR}/annotation/STAR_index/human" \
        --genomeFastaFiles "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
        --sjdbGTFfile "${WORKDIR}/annotation/gencode.v35.annotation.gtf"
fi


## Mouse
if [ ! -f "${WORKDIR}/annotation/gencode.vM26.annotation.gtf" ]; then
    echo "Unzipping mouse gencode annotation GTF file"
    gunzip -k "${WORKDIR}/annotation/gencode.vM26.annotation.gtf.gz"
fi
if [ ! -f "${WORKDIR}/annotation/GRCm39.primary_assembly.genome.fa" ]; then
    echo "Unzipping mouse genome fasta file"
    gunzip -k "${WORKDIR}/annotation/GRCm39.primary_assembly.genome.fa.gz"
fi

if [ ! -d "${WORKDIR}/annotation/STAR_index/mouse" ]; then
	echo "Generating STAR index for mouse"
    STAR \
        --runThreadN "${N_THREADS}" \
        --runMode genomeGenerate \
        --genomeDir "${WORKDIR}/annotation/STAR_index/mouse" \
        --genomeFastaFiles "${WORKDIR}/annotation/GRCm39.primary_assembly.genome.fa" \
        --sjdbGTFfile "${WORKDIR}/annotation/gencode.vM26.annotation.gtf"
fi


# Gather samples to work on; we have single end reads
sample_IDs=$(awk -F, '{if ($4 == "Good") print $3}' "${WORKDIR}/design_matrix.csv")

# Map fastq reads to the genome
for sample_ID in $sample_IDs; do
    echo "Working on ${sample_ID}"
    sample_path="${WORKDIR}/fastq/${sample_ID}.fastq.gz"

    # Map reads to the graft (human) reference genome
    STAR \
	    --runThreadN "${N_THREADS}" \
        --genomeDir "${WORKDIR}/annotation/STAR_index/human" \
        --readFilesIn "${sample_path}" \
        --twopassMode Basic \
		--readFilesCommand zcat \
        --outSAMattributes NM \
		--outFileNamePrefix ${WORKDIR}/bam/human/${sample_ID} \
        --outSAMtype BAM SortedByCoordinate

    # Map reads to the host (mouse) reference genome
	STAR \
	    --runThreadN "${N_THREADS}" \
        --genomeDir "${WORKDIR}/annotation/STAR_index/mouse" \
        --readFilesIn "${sample_path}" \
        --twopassMode Basic \
		--readFilesCommand zcat \
        --outSAMattributes NM \
		--outFileNamePrefix ${WORKDIR}/bam/mouse/${sample_ID} \
        --outSAMtype BAM SortedByCoordinate

done
