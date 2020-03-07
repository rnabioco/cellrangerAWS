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


# Transfer files to EC2 instance
local s3_fqs=$(
    aws s3 ls "$s3" \
        | grep -E -o "[[:alnum:]_\-\.]+.fastq.gz"
)

echo -e "\n$(get_time) Transferring the following files from $s3 to EC2 instance:"
echo "$s3_fqs"

s3_fqs=("$s3_fqs")

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
aws s3 cp --recursive "$HOME/RESULTS" "$S3/RESULTS"
aws s3 cp --recursive "$HOME/PIPELINE" "$S3/PIPELINE"

aws ec2 terminate-instances \
    --instance-ids "$EC2" \
    > /dev/null

