#!/usr/bin/env bash
CONDA_BIN=$(which mamba)
if [[ -z $CONDA_BIN ]]; then
    CONDA_BIN=$(which conda)
fi
$CONDA_BIN create -n mutation -c bioconda \
    star'==2.7.8a' \
    picard'==2.25.0' \
    gatk4'==4.2.0.0' \
    samtools'==1.11'
