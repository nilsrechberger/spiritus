#!/bin/bash

shopt -s globstar

# Remove old data
rm -fr data/

# Define scope
LOCATION_ID=(
# Lucern
	2162162
	5735
	9590
# Zurich
	9589
	9591
	9587
# Geneve
	3732
	2162150
	9578
)

# Request data from AWS and download
echo "Start Download..."
for location in "${LOCATION_ID[@]}"; do
	aws s3 cp \
	--no-sign-request \
	--recursive \
	s3://openaq-data-archive/records/csv.gz/locationid=$location/year=2024/ \
	data
	echo "Download data for location $location."
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
for file in data/*/*.csv; do
    if [ -f "$file" ]; then
        FIRST_FILE="$file"
        break 
    fi
done

echo "Using header from $FIRST_FILE"

head -n 1 "$FIRST_FILE" > "$MERGED_DATA"

for file in data/**/*.csv; do
    if [ -f "$file" ]; then
        tail -n +2 "$file" >> "$MERGED_DATA"
    fi
done

echo "Data merged"
echo "Output: $MERGED_DATA"
