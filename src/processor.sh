#/bin/bash

# Read data

MERGED_DATA="data/merged_data.csv"

# Filter columns for parameter

PARAMETERS=(
	co
	no2
	o3
	pm10
	pm25
	so2	
)

for param in "${PARAMETERS[@]}"; do
	OUTPUT="data/$param.csv"
	head -n 1 "$MERGED_DATA" > "$OUTPUT"
	grep -e "$param" $MERGED_DATA >> "$OUTPUT"
done
