#!/usr/bin/env bash

ciChanged=true
changedCharts=$(jq -c . <stubs/changed-charts.json)

./generate-config.sh "$ciChanged" "$changedCharts"
