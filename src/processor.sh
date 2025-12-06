#!/bin/bash

# Set errexit
set -e

MERGED_DATA="data/merged_data.csv"
AQI_DATA="data/AQI_data.csv"

# Encode columns
COL_SENSOR_ID=2
COL_DATE=4
COL_PARAM=7
COL_VAL=9

echo "Calculating full AQI stats (Hourly, Daily Avg, Daily Category, Worst Case & Driver)..."

awk -F, -v c_sensor="$COL_SENSOR_ID" -v c_date="$COL_DATE" -v c_param="$COL_PARAM" -v c_val="$COL_VAL" '
BEGIN { OFS="," }

# Define functions
function clean_string(str) {
    gsub(/"/, "", str); gsub(/^ +| +$/, "", str)
    return tolower(str)
}

function get_day(str) {
    gsub(/"/, "", str)
    return substr(str, 1, 10) # YYYY-MM-DD
}

function aqi_to_severity(cat) {
    if (cat == "Good") return 1
    if (cat == "Fair") return 2
    if (cat == "Moderate") return 3
    if (cat == "Poor") return 4
    if (cat == "Very Poor") return 5
    if (cat == "Extremely Poor") return 6
    return 0 
}

function severity_to_aqi(sev) {
    if (sev == 6) return "Extremely Poor"
    if (sev == 5) return "Very Poor"
    if (sev == 4) return "Poor"
    if (sev == 3) return "Moderate"
    if (sev == 2) return "Fair"
    if (sev == 1) return "Good"
    return "N/A"
}

function get_aqi_category(param, val) {
    val = val + 0 # Fill missing values
    
    if (param == "pm25") {
        if (val <= 10) return "Good"; if (val <= 20) return "Fair";
        if (val <= 25) return "Moderate"; if (val <= 50) return "Poor";
        if (val <= 75) return "Very Poor"; return "Extremely Poor"
    }
    if (param == "pm10") {
        if (val <= 20) return "Good"; if (val <= 35) return "Fair";
        if (val <= 50) return "Moderate"; if (val <= 100) return "Poor";
        if (val <= 200) return "Very Poor"; return "Extremely Poor"
    }
    if (param == "no2") {
        if (val <= 40) return "Good"; if (val <= 90) return "Fair";
        if (val <= 120) return "Moderate"; if (val <= 230) return "Poor";
        if (val <= 340) return "Very Poor"; return "Extremely Poor"
    }
    if (param == "o3") {
        if (val <= 50) return "Good"; if (val <= 100) return "Fair";
        if (val <= 130) return "Moderate"; if (val <= 240) return "Poor";
        if (val <= 380) return "Very Poor"; return "Extremely Poor"
    }
    if (param == "so2") {
        if (val <= 100) return "Good"; if (val <= 200) return "Fair";
        if (val <= 350) return "Moderate"; if (val <= 500) return "Poor";
        if (val <= 750) return "Very Poor"; return "Extremely Poor"
    }
    if (param == "co") {
        if (val <= 5) return "Good"; if (val <= 7) return "Fair";
        if (val <= 10) return "Moderate"; if (val <= 15) return "Poor";
        if (val <= 20) return "Very Poor"; return "Extremely Poor"
    }
    return "Not defined"
}

NR==FNR {
    if (FNR==1) next

    day = get_day($c_date)
    param = clean_string($c_param)
    raw_sensor = $c_sensor; gsub(/"/, "", raw_sensor)
    raw_val = $c_val; gsub(/"/, "", raw_val); val = raw_val + 0

    key = day "_" raw_sensor "_" param
    
    sum[key] += val
    count[key]++
    next
}

FNR==1 && NR!=1 {
    
    for (key in sum) {
        split(key, parts, "_")
        day = parts[1]; sensor = parts[2]; param = parts[3]
        
        avg = sum[key] / count[key]
        
        final_avg_map[key] = avg

        cat = get_aqi_category(param, avg)
        sev = aqi_to_severity(cat)
        
        group_key = day "_" sensor
        
        if (sev > max_sev[group_key]) {
            max_sev[group_key] = sev
            worst_driver[group_key] = param
        }
    }
}

{ sub(/\r$/, "", $0) }

# Header Update
FNR==1 { 
    print $0, "AQI_Category_Hourly", "Daily_Average", "AQI_Category_Daily", "Daily_Worst_AQI_Category", "Worst_Driver_Param"
    next 
}

{
    day = get_day($c_date)
    param = clean_string($c_param)
    raw_sensor = $c_sensor; gsub(/"/, "", raw_sensor)
    raw_val = $c_val; gsub(/"/, "", raw_val); val = raw_val + 0

    key = day "_" raw_sensor "_" param
    group_key = day "_" raw_sensor

    # Hourly AQI
    cat_hourly = get_aqi_category(param, val)

    # Daily Average
    # Wert aus Zwischenschritt holen
    avg_val = final_avg_map[key]
    avg_str = sprintf("%.2f", avg_val)

    # Daily AQI
    cat_daily = get_aqi_category(param, avg_val)

    # Worst Case Overall & Driver
    worst_sev = max_sev[group_key]
    worst_cat = severity_to_aqi(worst_sev)
    driver = worst_driver[group_key]

    print $0, cat_hourly, avg_str, cat_daily, worst_cat, driver
}

' "$MERGED_DATA" "$MERGED_DATA" > "$AQI_DATA"

echo "Done! Results in $AQI_DATA"