#!/bin/bash

echo "Start process"
. src/crawler.sh
. src/processor.sh
. src/filterer.sh
. srr/clenaer.sh
echo "End process"
