#/bin/bash

# Read data

MERGED_DATA="data/merged_data.csv"

# Filter columns for pm10 data
PM10_DATA="data/pm10.csv"
head -n 1 "$MERGED_DATA" > "$PM10_DATA"
grep -e "pm10" $MERGED_DATA >> "$PM10_DATA"
