#!/usr/bin/env bash

index=1
configuration=$(jq -c . <stubs/configuration.json)

./install-custom-resource-definitions.sh "$index" "$configuration"

index=4
configuration=$(jq -c . <stubs/configuration.json)

./install-custom-resource-definitions.sh "$index" "$configuration"
