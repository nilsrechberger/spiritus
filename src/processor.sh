#/bin/bash

# Read data

MERGED_DATA="data/merged_data.csv"

# Filter columns for pm10 data
grep -e "pm10" $MERGED_DATA  > "data/pm10.csv"
