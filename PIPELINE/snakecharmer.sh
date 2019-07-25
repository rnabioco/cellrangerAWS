#! /bin/bash

mkdir -p /mnt/EBS/RESULTS/logs

~/.local/bin/snakemake \
    --snakefile ~/PIPELINE/Snakefile \
    --latency-wait 60 \
    --rerun-incomplete  \
    --configfile /mnt/EBS/DATA/config.yaml \
    > /mnt/EBS/RESULTS/logs/cellranger.err 2>&1

