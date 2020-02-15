#! /bin/bash

snakemake="$HOME/.local/bin/snakemake"
res_dir="$HOME/RESULTS"
log_dir="$res_dir/logs"
pipeline="$HOME/PIPELINE"
threads=$(grep -c "^processor" /proc/cpuinfo)
threads=$(expr "$threads" - 2)

mkdir -p "$log_dir"


"$snakemake" \
    --snakefile "$pipeline/Snakefile" \
    --configfile "$pipeline/config.yaml" \
    --cores "$threads" \
    --latency-wait 60 \
    > "$log_dir/cellranger.out" \
    2>&1

