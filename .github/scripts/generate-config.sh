#!/usr/bin/env bash

ciChanged="$1"
changedCharts="$2"
projectRootPath=$(git rev-parse --show-toplevel)

# get changed charts
changedChartStr=$(echo "$changedCharts" |
	jq -r .[] |
	awk -F '/' '{ print $1"/"$2 }' |
	sort |
	uniq)
changedCharts=()
while IFS='' read -r line; do changedCharts+=("$line"); done < <(echo "$changedChartStr")

if [ "$ciChanged" == true ]; then
	# get all charts
	allChartsStr=$(find "$projectRootPath/charts" -type d -mindepth 1 -maxdepth 1 | sed "s~$projectRootPath/~~")
	charts=()
	while IFS='' read -r line; do charts+=("$line"); done < <(echo "$allChartsStr")
else
	charts=("${changedCharts[@]}")
fi

index=0
chartsJsonArray=()
matrixJsonArray=()
for chartPath in "${charts[@]}"; do

	if printf '%s\0' "${changedCharts[@]}" | grep -Fxqz -- "$chartPath"; then
		versionBump=true
	else
		versionBump=false
	fi

	chartName=$(basename "$chartPath")
	settings=$(yq -o=json '.' "$projectRootPath/$chartPath/ci.yaml")
	chartJson=$(
		jq --null-input \
			--arg name "$chartName" \
			--arg path "$chartPath" \
			--arg versionBump "$versionBump" \
			--argjson settings "$settings" \
			'{"name": $name, "path": $path, "settings": $settings, "versionBump": $versionBump}'
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
				--arg versionBump "$versionBump" \
				--arg version "$version" \
				'{"sourceIndex": $index, "name": $name, "path": $path, "version": $version, "versionBump": $versionBump}'
		)
		matrixJsonArray+=("$matrixJson")
	done
	index=$((index + 1))
done

chartsObject=$(echo "${chartsJsonArray[@]}" | jq -c -s '{charts: .}')
matrixObject=$(echo "${matrixJsonArray[@]}" | jq -s -c '{matrix: .}')
json=$(echo "$chartsObject" | jq -c ". + $matrixObject")
echo "$json"
