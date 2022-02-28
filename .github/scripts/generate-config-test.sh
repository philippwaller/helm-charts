#!/usr/bin/env bash

ciChanged=false
changedCharts=$(jq -c . < stubs/changed-charts.json)

./generate-config.sh "$ciChanged" "$changedCharts"
