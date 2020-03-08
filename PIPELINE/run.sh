#! /usr/bin/env bash

set -o nounset -o pipefail -o errexit

snakemake="$HOME/.local/bin/snakemake"
res_dir="$HOME/RESULTS"
log_dir="$res_dir/logs"
pipeline="$HOME/PIPELINE"
threads=$(grep -c "^processor" /proc/cpuinfo)
threads=$(expr "$threads" - 2)
S3="BUCKET"
EC2="INSTANCE"
YAML="CONFIG"

get_time() {
    echo "["$(date "+%F %T")"]"
}


# Transfer files to EC2 instance
s3_fqs=($(
    aws s3 ls "$S3" \
        | grep -E -o "[[:alnum:]_\-\.]+.fastq.gz"
))

echo -e "\n$(get_time) Transferring fastq files from $S3 to EC2 instance:"

for fq in "${s3_fqs[@]}"
do
    aws s3 cp "$S3/$fq" ~/DATA &
done

wait

sleep 30


# Run Cell Ranger
echo -e "\n$(get_time) Beginning Cell Ranger run."

"$snakemake" \
    --snakefile "$pipeline/Snakefile" \
    --configfile "$pipeline/$YAML" \
    --cores "$threads" \
    --latency-wait 60 \
    &> "$log_dir/cellranger.out"


# Transfer results and terminate instance
echo -e "\n$(get_time) Cell Ranger run complete. Transferring results to $S3."

aws s3 cp --recursive "$HOME/RESULTS" "$S3/RESULTS"
aws s3 cp --recursive "$HOME/PIPELINE" "$S3/PIPELINE"

aws ec2 terminate-instances \
    --instance-ids "$EC2" \
    > /dev/null



