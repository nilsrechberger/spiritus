#!/bin/bash

echo "Start process"
. src/crawler.sh
. src/processor.sh
. src/filterer.sh
echo "End process"
