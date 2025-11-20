#!/bin/bash

# Define request urls
requests_urls=(
    "https://openaq-data-archive.s3.amazonaws.com/records/csv.gz/locationid=2178/year=2022/month=05/location-2178-20220503.csv.gz"
)

# Check if data dir exists
data_dir="./data"

if [ ! -d "$data_dir" ]; then
    echo "Creating dir $data_dir..."
    mkdir -p "$data_dir"
fi

# Request and download data
echo "Start download..."
for url in "${requests_urls[@]}"; do
    echo "Downloade: $url"
    wget -q -P "$data_dir" "$url"
done
echo "Download finished."

# Unpack data
echo "Unpack .gz-Files..."
for file in "$data_dir"/*.csv.gz; do
    if [ -f "$file" ]; then
        echo "Unapck: $file"
        gunzip "$file"
    else
        echo "No .csv.gz-Files in $data_dir found."
        break
    fi
done
echo "Unpack finished."
