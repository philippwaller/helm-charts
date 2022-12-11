#!/usr/bin/env bash

index="$1"
json="$2"

crdsStr=$(echo "$json" | jq -r -c ".charts[$index].settings.kubernetes.customResourceDefinitions[]")
crds=()
while IFS='' read -r line; do [[ -n "$line" ]] && crds+=("$line"); done < <(echo "$crdsStr")
for crd in "${crds[@]}"; do
	kubectl create -f "$crd"
done
