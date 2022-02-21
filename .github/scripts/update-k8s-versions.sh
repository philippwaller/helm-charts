#!/usr/bin/env bash

# pipe function to filter unsupported k8s versions
filterUnsupportedVersions() {
  minVer="v1.16.1"
  while read version; do
    if [ "$version" != "`echo -e "$version\n$minVer" | sort -V | head -n1`" ] || [ "$version" == "$minVer" ]; then
      echo "$version"
    fi
  done
}

## determine available k3s docker versions

# define start page
nextPage="https://registry.hub.docker.com/v2/repositories/kindest/node/tags?page_size=1024"

# iterate over tag pages and extract suitable versions
nodeVersions=()
printf "Loading Node Docker Tags"
while [[ "$nextPage" != "null" ]]; do
  json=$(curl -L -s "$nextPage")
  nextPage=$(echo "${json}" | jq -r ".next")
  versionStrings=$( \
      echo "${json}" \
      | jq -r ".results[].name" \
      | grep -E "^v([0-9]+\.?)+" \
      | filterUnsupportedVersions \
  )
  nodeVersions+=("${versionStrings}")
  printf "."
done

# sort versions strings
nodeVersions=($(printf '%s\n' "${nodeVersions[@]}" | sort -V))

# print debug information
printf "\n\nk3s versions array:\n"
printf "%s " "${nodeVersions[@]}"


## determine available schema versions

# get all available schemas and extract suitable versions
versionStrings=$( \
  curl -L -s "https://api.github.com/repos/yannh/kubernetes-json-schema/git/trees/master" \
    | jq -r ".tree[].path" \
    | grep -E "^v([0-9]+\.?)+$" \
    | sort -V \
)
schemaVersions=($versionStrings)

# print debug information
printf "\n\nschema versions:\n"
printf "%s " "${schemaVersions[@]}"


## determine intersection
intersections=()
for nodeVersion in "${nodeVersions[@]}"; do
    for schemaVersion in "${schemaVersions[@]}"; do
        if [[ $nodeVersion == "$schemaVersion" ]]; then
            intersections+=( "$nodeVersion" )
            break
        fi
    done
done

# print debug information
printf "\n\nintersection:\n"
printf "%s " "${intersections[@]}"

# write result to file
scriptPath="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"
printf "%s\n" "${intersections[@]}" | sed "s/v/- /g" > "$scriptPath/../k8s-versions.yaml"
