#!/bin/bash
# author: Michael Skaro
# date: 3/18/2021
# Purpose: Star quantification in trimmed fq.gz files, star.bam creation, feed bams to GATK variant calling best practice


STAR --runMode genomeGenerate \
--genomeDir /home/mskaro1/storage/ATXN/mouse_ref/star_index \
--genomeFastaFiles /home/mskaro1/storage/ATXN/mouse_ref/star_index/GRCm38.primary_assembly.genome.fa \
--sjdbOverhang 100 --sjdbGTFfile /home/mskaro1/storage/ATXN/mouse_ref/star_index/gencode.vM24.annotation.gtf --runThreadN 16

for i in `cat /home/mskaro1/storage/ATXN/mRNA/concatenated/ID`;
do
        echo $i\ ;
#   echo $i\_R1_trimmed_001.fastq.gz ;
#   echo $i\_R2_trimmed_001.fastq.gz ;

STAR --runMode alignReads --runThreadN 20 \
--genomeDir /home/mskaro1/storage/ATXN/mouse_ref/star_index/ \
--twopassMode None --outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 \
--alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 \
--outFilterType BySJout --outFilterScoreMinOverLread 0.33 --outFilterMatchNminOverLread 0.33 \
--limitSjdbInsertNsj 1200000 --readFilesIn $i\_R1_trimmed_001.fastq.gz $i\_R1_trimmed_002.fastq.gz \
--outFileNamePrefix $i --readFilesCommand zcat --outSAMstrandField intronMotif \
--outFilterIntronMotifs None --alignSoftClipAtReferenceEnds Yes --quantMode TranscriptomeSAM GeneCounts \
--outSAMtype BAM SortedByCoordinate --outSAMunmapped None --genomeLoad NoSharedMemory --chimSegmentMin 15 \
--chimJunctionOverhangMin 15 --chimOutType Junctions WithinBAM SoftClip --chimMainSegmentMultNmax 1 \
--outSAMattributes None --outSAMattrRGline ID:$i

# feed bams to GATK best practices

done
