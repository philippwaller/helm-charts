#!/usr/bin/env bash

index="$1"
json="$2"

crds=($(echo "$json" | jq -r -c ".charts[$index].settings.kubernetes.customResourceDefinitions[]"))
for crd in "${crds[@]}"; do
	kubectl create -f "$crd"
done
