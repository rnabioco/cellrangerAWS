#! /bin/bash

config=test.yaml

# Function to pull sample names from yaml
get_samples() {
    local field=$1

    # Extract samples from yaml
    line_nums=$(
        cat "$config" \
            | grep -E -n "^[A-Z_]+:" \
            | grep -E -A 1 "$field:" \
            | grep -Eo "^[0-9]+"
    )

    start_idx=$(echo "$line_nums" | head -1)
    end_idx=$(echo "$line_nums" | tail -1)
    n_lines=$(expr "$end_idx" - "$start_idx" - 1)

    samples=$(
        cat "$config" \
            | grep -E -A "$n_lines" "^$field:" \
            | grep -Eo "\".+\""
    )

    # Delete samples from yaml
    start_idx=$(expr "$start_idx" + 1)
    end_idx=$(expr "$end_idx" - 1)

    sed -i "$start_idx","$end_idx"d "$config"

    echo $samples
}

# Create arrays containing sample names
IFS=" " read -a rna_arr <<< $(get_samples RNA_SAMPLES)
IFS=" " read -a adt_arr <<< $(get_samples ADT_SAMPLES)
IFS=" " read -a vdj_arr <<< $(get_samples VDJ_SAMPLES)

n_rna="${#rna_arr[@]}"
n_vdj="${#vdj_arr[@]}"
n_total=$(expr "$n_rna" + "$n_vdj")

# Create new yamls for cellranger count
for i in $(seq 1 "$n_rna")
do
    new_config="config_$i.yaml"
    i=$(expr "$i" - 1)

    cat "$config" \
        | awk '$1 !~ "^#"' \
        > "$new_config"

    sed -i "s/RNA_SAMPLES:/RNA_SAMPLES:\n    - ${rna_arr[$i]}\n/g" "$new_config"
    sed -i "s/ADT_SAMPLES:/ADT_SAMPLES:\n    - ${adt_arr[$i]}\n/g" "$new_config"
done

# Create new yamls for cellranger vdj
for i in $(seq $(expr "$n_rna" + 1) "$n_total")
do
    new_config="config_$i.yaml"
    i=$(expr "$i" - 1 - "$n_rna")

    cat "$config" \
        | awk '$1 !~ "^#"' \
        > "$new_config"

    sed -i "s/VDJ_SAMPLES:/VDJ_SAMPLES:\n    - ${vdj_arr[$i]}\n/g" "$new_config"
done





