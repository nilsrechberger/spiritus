#!/bin/bash

# Load .env file
source ./.env

# Request data
curl --request GET \
--url "https://api.openaq.org/v3/locations/8118" \
--header "X-API-Key: $API_KEY"
