#!/bin/bash

# Load .env file
source ./.env

# Request data
curl --request GET \
--url "https://api.openaq.org/v3/sensors/3917/days" \
--header "X-API-Key: $API_KEY" | jq -r '.results[] | [.value, .parameter.name, .parameter.units, .period.datetimeFrom.local] | @csv' | column -ts ","
