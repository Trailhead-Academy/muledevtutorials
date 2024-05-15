#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Create a GitHub Issue for every available Maven dependency update
# but only if such an Issue does not already exist.
# Requires 'hub' to be installed and configured (for authentication to GitHub)
#
# Usage: create-dependency-update-issues.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

# no-fail grep: a grep that does not return exit code 1 when it doesn't find any matching line
# normal grep returns 1 if no match is found, causing this script to exit immediately (-e and pipefail are set)
# nfgrep behaves like grep but returns exit code 0 if no matching lines are found
nfgrep() {
	grep "$@" || [[ $? == 1 ]]
}

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -ff"

bom=bom.xml
label='dependency upgrade'

filter() {
	nfgrep -B1 '\->'             \
    | nfgrep -v 'The following ' \
    | nfgrep -v '\-\-'           \
    | sed -e 's/\[INFO\]   //g'
}

xform() {
	sed -e 's/\${/update /g'                  \
	| sed -e 's/}[ ]*[\.]\{3,\}[ ]*/ from /g' \
	| sed -e 's/[ ]*->[ ]*/ to /g'
}

# expresses version information using properties, then transform any updates into a GitHub Issue title
titles=$($mvns -f $bom -Pversions versions:display-property-updates | filter | xform)
if [ -z "$titles" ]; then
	echo "No available dependency updates"
else
	echo "Found available dependency updates"
	while read -r title; do
		echo "Available dependency update: $title"                  || exit 10
		# search for a matching GitHub Issue
		exists=$(hub issue -l "$label" -f '%t%n' | nfgrep "$title") || exit 11
		if [ -z "$exists" ]; then
			echo "Creating new GitHub Issue  : $title"              || exit 12
			hub issue create -m "$title" -l "$label"                || exit 13
		else
			echo "GitHub Issue already exists: $title"              || exit 14
		fi
	done <<< "$titles" || exit 1
fi
