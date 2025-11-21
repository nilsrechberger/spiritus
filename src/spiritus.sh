#!/bin/bash

shopt -s globstar

# Remove old data
rm -fr data/

# Define scope
years=(
	2023
	2024
)

# Request data from AWS and download
echo "Start Download..."
for year in "${years[@]}"; do
	aws s3 cp \
	--no-sign-request \
	--recursive \
	s3://openaq-data-archive/records/csv.gz/locationid=2162162/year=$year/ \
	data
	echo "Download data for year $year."
done
echo "Finished download."

# Unzip data
echo "Start unzip data..."
for file in data/**/*.csv.gz; do
	gunzip $file
	echo "Unzip $file"
done
echo "Done unzip data"


# Merge data
MERGED_DATA="data/merged_data.csv"

# Remove old data
rm -f $MERGED_DATA
touch $MERGED_DATA

# Extraxt header
FIRST_FILE=""
for file in data/**/*.csv; do
    if [ -f "$file" ]; then
        FIRST_FILE="$file"
        break  # Stoppe nach der ersten gefundenen Datei
    fi
done

head -n 1 "$FIRST_FILE" > "$MERGED_DATA"

for file in data/**/*.csv; do
    if [ -f "$file" ]; then
        tail -n +2 "$file" >> "$MERGED_DATA"
    fi
done

echo "Data merged"
echo "Output: $MERGED_DATA"
