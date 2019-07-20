#!/bin/bash

source /software/cellranger-3.0.2/sourceme.bash

/usr/local/bin/snakemake \
    --snakefile /PIPELINE/Snakefile \
    --latency-wait 60 \
    --rerun-incomplete  \
    --configfile /PIPELINE/config.yaml \
    2> /PIPELINE/logs/cellranger.err

