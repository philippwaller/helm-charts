#!/usr/bin/env bash

ciChanged=$1
changedCharts=$2

projectRootPath=$(git rev-parse --show-toplevel)
if [ "$ciChanged" == false ]; then
	chartStr=$(echo "$changedCharts" |
		jq -r .[] |
		awk -F '/' '{ print $1"/"$2 }' |
		sort |
		uniq)
	charts=()
	while IFS='' read -r line; do charts+=("$line"); done < <(echo "$chartStr")
else
	chartStr=$(find "$projectRootPath/charts" -type d -mindepth 1 -maxdepth 1 | sed "s~$projectRootPath/~~")
	charts=()
	while IFS='' read -r line; do charts+=("$line"); done < <(echo "$chartStr")
fi

index=0
chartsJsonArray=()
matrixJsonArray=()
for chartPath in "${charts[@]}"; do
	chartName=$(basename "$chartPath")
	settings=$(yq -o=json '.' "$projectRootPath/$chartPath/ci.yaml")
	chartJson=$(
		jq --null-input \
			--arg name "$chartName" \
			--arg path "$chartPath" \
			--argjson settings "$settings" \
			'{"name": $name, "path": $path, "settings": $settings}'
	)
	chartsJsonArray+=("$chartJson")
	versions=()
	versionsStr=$(echo "$settings" | jq -r -c '.kubernetes.supportedVersions[]')
	while IFS='' read -r line; do versions+=("$line"); done < <(echo "$versionsStr")

	for version in "${versions[@]}"; do
		matrixJson=$(
			jq --null-input \
				--arg index "$index" \
				--arg name "$chartName" \
				--arg path "$chartPath" \
				--arg version "$version" \
				'{"sourceIndex": $index, "name": $name, "path": $path, "version": $version}'
		)
		matrixJsonArray+=("$matrixJson")
	done
	index=$((index + 1))
done

chartsObject=$(echo "${chartsJsonArray[@]}" | jq -c -s '{charts: .}')
matrixObject=$(echo "${matrixJsonArray[@]}" | jq -s -c '{matrix: .}')
json=$(echo "$chartsObject" | jq -c ". + $matrixObject")
echo "$json"
