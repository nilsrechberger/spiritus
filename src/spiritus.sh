#!/bin/bash

years=(
	2024
)

for year in "${years[@]}"; do
	aws s3 cp \
	--no-sign-request \
	--recursive \
	s3://openaq-data-archive/records/csv.gz/locationid=2178/year=$year/ \
	data
done
