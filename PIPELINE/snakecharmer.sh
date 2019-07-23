#!/bin/bash


snakemake \
    --snakefile Snakefile \
    --latency-wait 60 \
    --rerun-incomplete  \
    --configfile DATA/config.yaml


#~/.local/bin/snakemake \
#    --snakefile ~/PIPELINE/Snakefile \
#    --latency-wait 60 \
#    --rerun-incomplete  \
#    --configfile /mnt/EBS/DATA/config.yaml \
#    > ~/PIPELINE/RESULTS/logs/cellranger.err 2>&1

