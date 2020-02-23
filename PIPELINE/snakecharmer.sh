#! /bin/bash

snakemake="$HOME/.local/bin/snakemake"
res_dir="$HOME/RESULTS"
log_dir="$res_dir/logs"
pipeline="$HOME/PIPELINE"
threads=$(grep -c "^processor" /proc/cpuinfo)
threads=$(expr "$threads" - 2)
S3="BUCKET"
EC2="INSTANCE"
YAML="CONFIG"

mkdir -p "$log_dir"

get_time() {
    echo "["$(date "+%F")"]"
}

# Run Cell Ranger
"$snakemake" \
    --snakefile "$pipeline/Snakefile" \
    --configfile "$pipeline/$YAML" \
    --cores "$threads" \
    --latency-wait 60 \
    &> "$log_dir/cellranger.out"

# Transfer results and terminate instance
aws s3 cp --recursive "$HOME/RESULTS" "$S3/RESULTS"
aws s3 cp --recursive "$HOME/PIPELINE" "$S3/PIPELINE"

aws ec2 terminate-instances \
    --instance-ids "$EC2" \
    > /dev/null


