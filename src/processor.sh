#!/bin/bash

MERGED_DATA="data/merged_data.csv"
AQI_DATA="data/AQI_data.csv"

echo "Calculate AQI in $MERGED_DATA according to EEA standards..."

awk -F, 'BEGIN {OFS=","}
{
    # Remove line brake (by windows sys)
    sub(/\r$/, "", $0)
}

# Add new column
NR==1 { 
    print $0, "AQI_Category" 
    next 
} 

# Select param and value column
{
    raw_param = $7
    raw_val = $9
    
    # Normalize data
    param = raw_param
    val = raw_val
    gsub(/"/, "", param)
    gsub(/^ +| +$/, "", param)
    param = tolower(param)
    
    gsub(/"/, "", val)
    gsub(/^ +| +$/, "", val)

    # Handling missing values
    val = val + 0
    
    cat = "Not defined"

    # Define AQI
    if (param == "pm25") {
        if (val <= 10)      cat = "Good"
        else if (val <= 20) cat = "Fair"
        else if (val <= 25) cat = "Moderate"
        else if (val <= 50) cat = "Poor"
        else if (val <= 75) cat = "Very Poor"
        else                cat = "Extremely Poor"
    }

    else if (param == "pm10") {
        if (val <= 20)       cat = "Good"
        else if (val <= 35)  cat = "Fair"
        else if (val <= 50)  cat = "Moderate"
        else if (val <= 100) cat = "Poor"
        else if (val <= 200) cat = "Very Poor"
        else                 cat = "Extremely Poor"
    }

    else if (param == "no2") {
        if (val <= 40)       cat = "Good"
        else if (val <= 90)  cat = "Fair"
        else if (val <= 120) cat = "Moderate"
        else if (val <= 230) cat = "Poor"
        else if (val <= 340) cat = "Very Poor"
        else                 cat = "Extremely Poor"
    }

    else if (param == "o3") {
        if (val <= 50)       cat = "Good"
        else if (val <= 100) cat = "Fair"
        else if (val <= 130) cat = "Moderate"
        else if (val <= 240) cat = "Poor"
        else if (val <= 380) cat = "Very Poor"
        else                 cat = "Extremely Poor"
    }

    else if (param == "so2") {
        if (val <= 100)      cat = "Good"
        else if (val <= 200) cat = "Fair"
        else if (val <= 350) cat = "Moderate"
        else if (val <= 500) cat = "Poor"
        else if (val <= 750) cat = "Very Poor"
        else                 cat = "Extremely Poor"
    }

    else if (param == "co") {
        if (val <= 5)       cat = "Good"
        else if (val <= 7)  cat = "Fair"
        else if (val <= 10) cat = "Moderate"
        else if (val <= 15) cat = "Poor"
        else if (val <= 20) cat = "Very Poor"
        else                cat = "Extremely Poor"
    }

    # Falls der Parameter unbekannt ist, zeigen wir ihn im Fehler an
    else {
        cat = "No AQI according to EEA"
    }

    # Add aqi category
    print $0, cat

}' "$MERGED_DATA" > "$AQI_DATA"

echo "Done! Results in $AQI_DATA"
