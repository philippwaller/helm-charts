#!/usr/bin/env bash

## SCRIPT CONFIGURATION
debug=true
outputFile="ci.yaml"
outputYamlPath=".kubernetes.supportedVersions"

function getNodeVersionsAsStr() {
  nodeVersions=()
  nextPage="https://registry.hub.docker.com/v2/repositories/kindest/node/tags?page_size=1024"
  while [[ "$nextPage" != "null" ]]; do
    json=$(curl -L -s "$nextPage")
    nextPage=$(echo "${json}" | jq -r ".next")
    versionStrings=$( \
        echo "${json}" \
        | jq -r ".results[].name" \
        | grep -E "^v([0-9]+\.?)+" \
        | sed "s/^v//g" \
    )
    nodeVersions+=("${versionStrings}")
  done
  echo "${nodeVersions[*]}" | sort -V
}

function getSchemaVersionAsStr() {
  curl -L -s "https://api.github.com/repos/yannh/kubernetes-json-schema/git/trees/master" \
    | jq -r ".tree[].path" \
    | grep -E "^v([0-9]+\.?)+$" \
    | sed "s/^v//g" \
    | sort -V
}

function getVersions() {
  nodeVersions=($1)
  schemaVersions=($2)
  intersections=()
  for nodeVersion in "${nodeVersions[@]}"; do
      for schemaVersion in "${schemaVersions[@]}"; do
          if [[ $nodeVersion == "$schemaVersion" ]]; then
              intersections+=( "$nodeVersion" )
              break
          fi
      done
  done
  echo "${intersections[*]}"
}

function readMinK8sVersion() {
  yq .kubeVersion "$1/Chart.yaml" | sed "s/^\^//g"
}

function filterUnsupportedVersions() {
  while read version; do
    if [ "$version" != "`echo -e "$version\n$minK8sVersion" | sort -V | head -n1`" ] || [ "$version" == "$minK8sVersion" ]; then
      echo "$version"
    fi
  done
}

function log() {
  if [ $debug == true ]; then
    # shellcheck disable=SC2059
    printf "\n$1"
  fi
}

nodeVersions=($(getNodeVersionsAsStr))
log "available node versions [${#nodeVersions[@]}]:\n${nodeVersions[*]}"
schemaVersions=($(getSchemaVersionAsStr))
log "\navailable schema versions [${#schemaVersions[@]}]:\n${schemaVersions[*]}"
availableVersions=($(getVersions "${nodeVersions[*]}" "${schemaVersions[*]}"))
log "\navailable versions (intersection)[${#availableVersions[@]}]:\n${availableVersions[*]}\n\n"

projectRootPath=$(git rev-parse --show-toplevel)
for dir in "$projectRootPath"/charts/*/; do
    dirname=$(basename "$(dirname "$dir")")/$(basename "$dir")
    printf "update versions for chart %s\n" "$dirname"
    minK8sVersion=$(readMinK8sVersion "$dir")
    supportedVersions=($(printf '%s\n' "${availableVersions[@]}" | filterUnsupportedVersions))
    log "supported k8s versions (>= $minK8sVersion) [${#supportedVersions[@]}]:\n${supportedVersions[*]}\n"
    yq -i "$outputYamlPath = (\"${supportedVersions[*]}\" | split(\" \"))" "$dir/$outputFile"
done
