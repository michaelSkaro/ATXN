#!/usr/bin/env bash

# Detecting somatic variants in the patient-derived xenograft (PDX) data.
# Since we have RNA-Seq data, the mutations detected are limited to expressed
# genes, and depends on the complications in library prep, RNA splicing and editing.
# Detection rate is usually poor for low allelic frequency mutations.

##########################################
# Environment setup
##########################################
WORKDIR="/mnt/data/mutation"

mkdir -p \
    "${WORKDIR}/annotation/exon_intervals" \
    "${WORKDIR}/bam/filtered/dedup" \
    "${WORKDIR}/bam/filtered/split_n_cigar" \
    "${WORKDIR}/bam/filtered/qc_recal" \
    "${WORKDIR}/mutation/vcf/raw" \
    "${WORKDIR}/mutation/vcf/filtered" \
    "${WORKDIR}/mutation/vcf/annotated" \
    "${WORKDIR}/mutation/annotation"

# Prepare reference dictionary and index files
# https://gatk.broadinstitute.org/hc/en-us/articles/360035531652-FASTA-Reference-genome-format
if [ ! -f "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.dict" ]; then
    gatk CreateSequenceDictionary \
        -R "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa"
fi

if [ ! -f "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa.fai" ]; then
    samtools faidx \
        "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
        -o "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa.fai"
fi

# Download known polymorphic sites (VCF) and generate its index file
if [ ! -f "${WORKDIR}/annotation/dbSNP_common_all_chr.vcf" ]; then
    wget -O "${WORKDIR}/annotation/dbSNP_common_all.vcf.gz" \
        https://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/common_all_20180418.vcf.gz && \
    gunzip -d "${WORKDIR}/annotation/dbSNP_common_all.vcf.gz" && \
    awk '{if($0 !~ /^#/) print "chr"$0; else print $0}' \
        "${WORKDIR}/annotation/dbSNP_common_all.vcf" > \
        "${WORKDIR}/annotation/dbSNP_common_all_chr.vcf" && \
    gatk IndexFeatureFile \
        -I "${WORKDIR}/annotation/dbSNP_common_all_chr.vcf"
fi

# Prepare genomic intervals for runnning HaplotypeCaller in parallel
# https://github.com/gatk-workflows/gatk4-rnaseq-germline-snps-indels/blob/master/gatk4-rna-best-practices.wdl
if [ ! -f "${WORKDIR}/annotation/gencode_human.gtf.exons.interval_list" ]; then
    tail -n +6 "${WORKDIR}/annotation/gencode.v35.annotation.gtf" | \
        awk -F'\t' '$3 == "exon"{print $1 "\t" ($4 - 1) "\t" $5}' > \
        "${WORKDIR}/annotation/gencode_human_exome.bed" && \
    gatk BedToIntervalList \
        -I "${WORKDIR}/annotation/gencode_human_exome.bed" \
        -O "${WORKDIR}/annotation/gencode_human.gtf.exons.interval_list" \
        -SD "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.dict" && \
    gatk --java-options "-Xms1g" IntervalListTools \
        --SCATTER_COUNT 20 \
        --SUBDIVISION_MODE BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
        --UNIQUE true \
        --SORT true \
        --INPUT "${WORKDIR}/annotation/gencode_human.gtf.exons.interval_list" \
        --OUTPUT "${WORKDIR}/annotation/exon_intervals" && \
    cd "${WORKDIR}/annotation/exon_intervals" && \
        rename 's/temp_\d*?([^0]\d*)_of_20\/.*$/$1.interval_list/' ./*/* && \
        rmdir ./temp* && \
        cd -
fi

# Download data source for functional annotation of variants
if [ ! -d "${WORKDIR}/mutation/annotation/funcotator_dataSources.v1.7.20200521s" ]; then
    gatk FuncotatorDataSourceDownloader \
        --somatic \
        --validate-integrity \
        --extract-after-download \
        -O "${WORKDIR}/mutation/annotation/somatic_annot.tar.gz"
fi


##########################################
# Call variants
##########################################
# Pipeline description: https://gatk.broadinstitute.org/hc/en-us/articles/360035531192-RNAseq-short-variant-discovery-SNPs-Indels-
# https://gatk.broadinstitute.org/hc/en-us/articles/360035535912

sample_IDs=$(awk -F, '{if ($4 == "Good") print $3}' "${WORKDIR}/design_matrix.csv")

for sample_ID in $sample_IDs; do

    # Add dummy read groups required by GATK
    # ~3min on single core
    picard AddOrReplaceReadGroups \
        I="${WORKDIR}/bam/filtered/Filtered_bams/${sample_ID}_Filtered.bam" \
        O="${WORKDIR}/bam/filtered/dedup/${sample_ID}_rg.bam" \
        RGID="1" \
        RGLB="lib1" \
        RGPL="illumina" \
        RGPU="unit1" \
        RGSM="${sample_ID}"

    # Mark duplicates and sort using Picard
    # ~3min on 20 cores
    gatk MarkDuplicatesSpark \
        -I "${WORKDIR}/bam/filtered/dedup/${sample_ID}_rg.bam" \
        -O "${WORKDIR}/bam/filtered/dedup/${sample_ID}.bam" \
        -M "${WORKDIR}/bam/filtered/dedup/${sample_ID}.metrics" \
        --create-output-bam-index true \
        --read-validation-stringency SILENT \
        --conf 'spark.executor.cores=20' && \
    rm "${WORKDIR}/bam/filtered/dedup/${sample_ID}_rg.bam"

    # Split reads with N in the cigar into multiple supplementary alignments (SplitNCigarReads)
    # Slow step, ~25min on single core
    gatk SplitNCigarReads \
        -R "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
        -I "${WORKDIR}/bam/filtered/dedup/${sample_ID}.bam" \
        -O "${WORKDIR}/bam/filtered/split_n_cigar/${sample_ID}.bam"

    # Base (Quality score) recalibration
    ## Generate recalibration table (BaseRecalibrator) and
    ## apply base quality score recalibration (ApplyBQSR)
    gatk BQSRPipelineSpark \
        -R "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
        -I "${WORKDIR}/bam/filtered/split_n_cigar/${sample_ID}.bam" \
        --known-sites "${WORKDIR}/annotation/dbSNP_common_all_chr.vcf" \
        -O "${WORKDIR}/bam/filtered/qc_recal/${sample_ID}.bam" \
        --use-original-qualities \
        --conf 'spark.executor.cores=20'

    # Call variants using HaplotypeCaller
    # Not using Mutect2 because it's designed for somatic variants calling,
    # and in our case we don't have a normal sample to compare against the reference.
    # https://gatk.broadinstitute.org/hc/en-us/articles/360035890491?id=11127

    # Really slow without splitting the intervals! ~81min for one sample.
    for i in {1..20}; do
        gatk --java-options "-Xms6g -XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10" HaplotypeCaller \
            -R "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
            -I "${WORKDIR}/bam/filtered/qc_recal/${sample_ID}.bam" \
            -O "${WORKDIR}/mutation/vcf/raw/${sample_ID}.${i}.vcf.gz" \
            -L "${WORKDIR}/annotation/exon_intervals/${i}.interval_list" \
            --dont-use-soft-clipped-bases \
            --standard-min-confidence-threshold-for-calling 20 \
            --dbsnp "${WORKDIR}/annotation/dbSNP_common_all_chr.vcf" &
    done
    wait

    # Merge the per-interval VCFs for the same sample
    touch "${WORKDIR}/mutation/vcf/raw/${sample_ID}.list"
    for i in {1..20}; do
        echo "${WORKDIR}/mutation/vcf/raw/${sample_ID}.${i}.vcf.gz" >> "${WORKDIR}/mutation/vcf/raw/${sample_ID}.list"
    done
    gatk --java-options "-Xms2000m" MergeVcfs \
        --INPUT "${WORKDIR}/mutation/vcf/raw/${sample_ID}.list" \
        --OUTPUT "${WORKDIR}/mutation/vcf/raw/${sample_ID}.vcf.gz" && \
    rm "${WORKDIR}/mutation/vcf/raw/${sample_ID}.list" \
        "${WORKDIR}/mutation/vcf/raw/${sample_ID}".*.vcf.gz \
        "${WORKDIR}/mutation/vcf/raw/${sample_ID}".*.vcf.gz.tbi

    # Variant filtering (almost instant)
    gatk VariantFiltration \
        -R "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
        -V "${WORKDIR}/mutation/vcf/raw/${sample_ID}.vcf.gz" \
        -O "${WORKDIR}/mutation/vcf/filtered/${sample_ID}.vcf.gz" \
        --window 35 \
        --cluster 3 \
        --filter-name "FS" \
        --filter "FS > 30.0" \
        --filter-name "QD" \
        --filter "QD < 2.0"

    # Variant annotation
    # ~5min/core/sample
    gatk Funcotator \
        -R "${WORKDIR}/annotation/GRCh38.primary_assembly.genome.fa" \
        -V "${WORKDIR}/mutation/vcf/filtered/${sample_ID}.vcf.gz" \
        -O "${WORKDIR}/mutation/vcf/annotated/${sample_ID}.vcf" \
        --output-file-format "VCF" \
        --data-sources-path "${WORKDIR}/mutation/annotation/funcotator_dataSources.v1.7.20200521s/" \
        --ref-version "hg38"
done