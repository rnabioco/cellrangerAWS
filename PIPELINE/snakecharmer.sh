#! /bin/bash

snakemake="$HOME/.local/bin/snakemake"
data_dir="/mnt/EBS/DATA"
res_dir="/mnt/EBS/RESULTS"
log_dir="$res_dir/logs"
pipeline="$HOME/PIPELINE"

mkdir -p "$log_dir"

"$snakemake" \
    --snakefile "$pipeline/Snakefile" \
    --latency-wait 60 \
    --rerun-incomplete \
    --configfile "$data_dir/config.yaml" \
    > "$log_dir/cellranger.out" \
    2>&1

