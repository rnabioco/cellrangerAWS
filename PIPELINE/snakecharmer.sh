#!/bin/bash

~/.local/bin/snakemake \
    --snakefile ~/PIPELINE/Snakefile \
    --latency-wait 60 \
    --rerun-incomplete  \
    --configfile /mnt/EBS/DATA/config.yaml \
    > /mnt/EBS/RESULTS/logs/cellranger.err 2>&1


#snakemake \
#    --snakefile Snakefile \
#    --latency-wait 60 \
#    --rerun-incomplete  \
#    --configfile DATA/config.yaml
