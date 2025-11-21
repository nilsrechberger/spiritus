#!/bin/bash

shopt -s globstar

# Define scope
years=(
	2024
)

# Request data from AWS and download
echo "Start Download..."
for year in "${years[@]}"; do
	aws s3 cp \
	--no-sign-request \
	--recursive \
	s3://openaq-data-archive/records/csv.gz/locationid=2178/year=$year/ \
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
