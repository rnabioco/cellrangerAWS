#!/bin/bash

snakemake \
    --snakefile ~/PIPELINE/Snakefile \
    --latency-wait 60 \
    --rerun-incomplete  \
    --configfile /mnt/EBS/DATA/config.yaml \
    > ~/RESULTS/logs/cellranger.err 2>&1

