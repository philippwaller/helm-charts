#!/usr/bin/env bash

index=3
configuration=$(jq -c . < stubs/configuration.json)

./install-custom-resource-definitions.sh "$index" "$configuration"
