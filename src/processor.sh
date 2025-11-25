#/bin/bash

# Read data

MERGED_DATA="data/merged_data.csv"

# Filter data for parameter
echo "Start filter data for paramters"
PARAMETERS=(
	co
	no2
	o3
	pm10
	pm25
	so2	
)

for param in "${PARAMETERS[@]}"; do
	echo "Filter for $param"
	OUTPUT="data/$param.csv"
	head -n 1 "$MERGED_DATA" > "$OUTPUT"
	grep -e "$param" "$MERGED_DATA" >> "$OUTPUT"
	echo "Output file: $OUTPUT"
done

# Filter for location ID
echo "Start filter data for location ID"

LOCATIONS=(
	5735
	9590
	2162162
)

for loc in "${LOCATIONS[@]}"; do 
	echo "Filter for location $loc"
	OUTPUT="data/$loc.csv"
	head -n 1 "$MERGED_DATA" > "$OUTPUT"
	grep -e "$loc" "$MERGED_DATA" >> "$OUTPUT"
	echo "Output file: $OUTPUT"
done
