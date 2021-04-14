import os
import glob 

ID = glob_wildcards("raw_reads/{id}.fastq.gz")


rule all:
    input:
        expand("rawQC/{id}_fastqc_{extension}", id=ID, extension =["zip", "html"]),
        expand("star_aligned/{id}Aligned.out.bam", id=ID),
        expand("star_aligned/{id}Aligned.toTranscriptome.out.bam", id=ID),
        expand("star_aligned/{id}Log.final.out", id=ID),
        expand("star_aligned/{id}ReadsPerGene.out.tab", id=ID),
        expand("star_aligned/{id}SJ.out.tab", id=ID)

rule rawFASTQC:
	input:
		raw_read = "raw_reads/{id}.fastq.gz"
	output:
		zip = "rawQC/{id}_fastqc.zip",
		html ="rawQC/{id}_fastqc.html"
	params:
		path = "rawQC/"
	threads:
		1
	shell:
	'''
	fastqc {input.raw_read} --threads {threads} -o {params.path}
	'''

rule trimmomatic:
	input:
		read1 = "raw_reads/{id}.fastq.gz",
		read2 = "raw_reads/{id}.fastq.gz"
	output:
		forwardPaired = "trimmed_reads/{id}_1P.fastq.gz",
		reversePaired = "trimmed_reads/{id}_2Pfastq.gz"
	params:
		basename ="trimmed_reads/{id}.fastq.gz"
		log ="trimmed_reads/{id}.log"
		
	threads:
		4
	shell:
	'''
	trimmotmatic PE -threads {threads} {input.read1} {input.read2} -baseout {params.basename} ILLUMINACLIP:Truseq3-PE-2.fa:2:30:10:2:KeepBothReads LEADING 3 TRAILING 3 MINLEN 36 2>{params.log}
	'''

rule star:
	input:
		read1 = rules.trimmomatic.output.forwardPaired
		read2 = rules.trimmomatic.output.reversePaired
	output:
		bam = "star_aligned/{id}Aligned.out.bam",
		transcriptomeBam = "star_aligned/{id}Aligned.toTranscriptome.out.bam"
		log = "star_aligned/{id}Log.final.out",
		geneCounts = "star_aligned/{id}ReadsPerGene.out.tab",
		SJ = "star_aligned/{id}SJ.out.tab"
	params:
		starAligned/{id}
	threads:
		20
	shell:
	'''
	STAR \
		--runThreadN {threads} \
        --readFilesIn {input.reads1} {input.read2} \
        --outSAMattrRGline {params.prefix} \
        --alignIntronMax 1000000 \
        --alignIntronMin 20 \
        --alignMatesGapMax 1000000 \
        --alignSJDBoverhangMin 1 \
        --alignSJoverhangMin 8 \
        --alignSoftClipAtReferenceEnds Yes \
        --chimJunctionOverhangMin 15 \
        --chimMainSegmentMultNmax 1 \
        --chimOutType Junctions SeparateSAMold WithinBAM SoftClip \
        --chimSegmentMin 15 \
        --genomeDir star_index/  \
        --genomeLoad NoSharedMemory \
        --limitSjdbInsertNsj 1200000 \
        --outFileName {params.prefix} \
        --outFilterIntronMotifs None \
        --outFilterMatchNminOverLread 0.33 \
        --outFilterMismatchNmax 999 \
        --outFilterMismatchNoverLmax 0.1 \
        --outFilterMultimapNmax 20 \
        --outFilterScoreMinOverLread 0.33 \
        --outFilterType BySJout \
        --outSAMattributes NH HI AS nM NM ch \
        --outSAMstrandField intronMotif \
        --outSAMtype BAM Unsorted \
        --outSAMunmapped Within \
        --quantMode TranscriptomeSAM GeneCounts \
        --readFilesCommand zcat \
        --twopassMode Basic
	'''


'''
# dry run
snakemake -s snakefile.py -n 
# forrrr real
snakemake -s snakefile.py -j 30
'''


















