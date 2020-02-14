#! /usr/bin/env bash

#BSUB -J cellranger
#BSUB -o logs/cellranger_%J.out
#BSUB -e logs/cellranger_%J.err
#BSUB -R "select[mem>4] rusage[mem=4]" 
#BSUB -q rna

set -o nounset -o pipefail -o errexit -x

mkdir -p logs


# Function to run snakemake
run_snakemake() {
    local num_jobs=$1
    local config_file=$2
    
    drmaa_args='
        -o {log}.out 
        -e {log}.err 
        -J {params.job_name} 
        -R "{params.memory} span[hosts=1] " 
        -n {threads} '

    snakemake \
        --snakefile Snakefile \
        --drmaa "$drmaa_args" \
        --jobs $num_jobs \
        --latency-wait 60 \
        --rerun-incomplete \
        --configfile $config_file
}

run_snakemake 50 config.yaml


