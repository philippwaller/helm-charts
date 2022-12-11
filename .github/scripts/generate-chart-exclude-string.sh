#!/usr/bin/env bash

chartPath="$1"
projectRootPath=$(git rev-parse --show-toplevel)
chartDir="$projectRootPath/charts"

excludePaths=$(
	find "$chartDir" -type d -mindepth 1 -maxdepth 1 |
		sed "s~$projectRootPath/~~" |
		grep -Ev "^$chartPath$" |
		awk -F "/" '{ print $2 }' |
		tr '\n' ',' |
		sed 's/,$//g'
)

echo "$excludePaths"
