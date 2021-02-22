#!/bin/bash
# author: Michael Skaro
# date: 1/26/2022
# Purpose: End-to-End QC, RNAseq and DEseq2 analyses


#Operator	Description
#! EXPRESSION	The EXPRESSION is false.
#-n STRING	The length of STRING is greater than zero.
#-z STRING	The lengh of STRING is zero (ie it is empty).
#STRING1 = STRING2	STRING1 is equal to STRING2
#STRING1 != STRING2	STRING1 is not equal to STRING2
#INTEGER1 -eq INTEGER2	INTEGER1 is numerically equal to INTEGER2
#INTEGER1 -gt INTEGER2	INTEGER1 is numerically greater than INTEGER2
#INTEGER1 -lt INTEGER2	INTEGER1 is numerically less than INTEGER2
#-d FILE	FILE exists and is a directory.
#-e FILE	FILE exists.
#-r FILE	FILE exists and the read permission is granted.
#-s FILE	FILE exists and it's size is greater than zero (ie. it is not empty).
#-w FILE	FILE exists and the write permission is granted.
#-x FILE	FILE exists and the execute permission is granted.




# Move file from the subdirectories up to a fasq folder
find . -name '*.gz' -exec mv {} /Volumes/easy\ store/Mouse_RNAseq/3510-224966743/FASTQ \;

# concatenate all the files that are the same file but were run on different lanes
ls -1 *R1*.gz | awk -F '_' '{print $1,$2}' | sort | uniq > ID
vim ID
%s/ /_/g
for i in `cat ./ID`; do cat $i\_L001_R1_001.fastq.gz $i\_L002_R1_001.fastq.gz $i\_L003_R1_001.fastq.gz $i\_L004_R1_001.fastq.gz > $i\_R1_001.fastq.gz; done
for i in `cat ./ID`; do cat $i\_L001_R2_001.fastq.gz $i\_L002_R2_001.fastq.gz $i\_L003_R2_001.fastq.gz $i\_L004_R2_001.fastq.gz > $i\_R2_001.fastq.gz; done 
# run fastqc to estimate trimming distance, find over represented sequences

# run cut adapt on the sequences and remove illumina universal adapter 
# see cutadapt documentation
#miRNA
for i in `cat ./ID`; do cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -o trimmed/$i\_R1_trimmed_001.fastq.gz $i\_R1_001.fastq.gz; done
# mRNA
for i in `cat ./ID`; do -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o trimmed/$i\_R1_trimmed_001.fastq.gz -p trimmed/$i\_R2_trimmed_001.fastq.gz $i\_R1_trimmed_001.fastq.gz $i\_R2_trimmed_001.fastq.gz

# make a fastqc directory run fastqc on the trimmed fastq



# begin salmon build for indexing of mmu-GRC38
	# get the data
	
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.transcripts.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/GRCm38.primary_assembly.genome.fa.gz
	
# make decoys
grep "^>" <(zcat GRCm38.primary_assembly.genome.fa.gz) | cut -d " " -f 1 > decoys.txt 
sed -i -e 's/>//g' decoys.txt
# make gentrome 
cat gencode.vM23.transcripts.fa.gz GRCm38.primary_assembly.genome.fa.gz > gentrome.fa.gz
	
# retain indexes 
	
salmon index -t gentrome.fa.gz -d decoys.txt -p 12 -i salmon_index

# pseudo -align the fastq files to the genome and quantify the scripts
         


for i in `cat /home/mskaro1/storage/ATXN/mRNA/concatenated/ID`;
do
        echo $i\ ;
#       echo $i\_R1_trimmed_001.fastq.gz ;
#       echo $i\_R2_trimmed_001.fastq.gz ;

        salmon quant -i /home/mskaro1/storage/ATXN/mouse_ref/salmon_index --libType A \
          -1 $i\_R1_trimmed_001.fastq.gz \
          -2 $i\_R2_trimmed_001.fastq.gz \
          -p 8 --validateMappings \
          -o quant/$i;


done

for i in `cat /home/mskaro1/storage/ATXN/miRNA/concatenated/ID`;
do
        echo $i\ ;
#       echo $i\_R1_trimmed_001.fastq.gz ;
#       

        salmon quant -i /home/mskaro1/storage/ATXN/mouse_ref/salmon_index --libType A \
          -r $i\_R1_trimmed_001.fastq.gz \
          -p 8 --validateMappings \
          -o quant/$i;




# output the counts files in the /alginedBAM/

# quantify mRNA transcripts put in results/counts/

# invoke DEseq2 pipeline

# Differential expression analysis









#END
