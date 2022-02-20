#!/usr/bin/env bash

filterUnsupportedVersions() {
  minVer="v1.16.1"
  while read version; do
    if [ "$version" != "`echo -e "$version\n$minVer" | sort -V | head -n1`" ] || [ "$version" == "$minVer" ]; then
      echo "$version"
    fi
  done
}

nodeVersions=$( \
  curl -L -s "https://registry.hub.docker.com/v2/repositories/kindest/node/tags?page_size=1024" \
  | jq -r ".results[].name" \
  | grep -E "^v([0-9]+\.?)+$" \
  | filterUnsupportedVersions \
  | sort \
  )
nodeVersionArray=($nodeVersions)
printf "node versions array:\n"
printf "%s " "${nodeVersionArray[@]}"

schemaVersions=$( \
  curl -L -s "https://api.github.com/repos/yannh/kubernetes-json-schema/git/trees/master" \
    | jq -r ".tree[].path" \
    | grep -E "^v([0-9]+\.?)+$" \
    | sort \
  )
schemaVersionArray=($schemaVersions)
printf "\n\nschema versions:\n"
printf "%s " "${schemaVersionArray[@]}"

intersections=()
for nodeVersion in "${nodeVersionArray[@]}"; do
    for schemaVersion in "${schemaVersionArray[@]}"; do
        if [[ $nodeVersion == "$schemaVersion" ]]; then
            intersections+=( "$nodeVersion" )
            break
        fi
    done
done
printf "\n\nintersection:\n"
printf "%s " "${intersections[@]}"

scriptPath="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"
printf "%s\n" "${intersections[@]}" | sed "s/v/- /g" > "$scriptPath/../k8s-versions.yaml"
