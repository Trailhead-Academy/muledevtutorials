#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Check all Maven dependencies (normal dependencies and Maven plugin) and display information about
# whether they are up-to-date or if updates are available
#
# Usage: display-available-dependency-updates.sh

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

filter() {
	nfgrep -B1 '\->'             \
    | nfgrep -v 'The following ' \
    | nfgrep -v '\-\-'           \
    | sed -e 's/\[INFO\]   //g'
}

# expresses version information using properties
$mvns -f $bom -Pversions versions:display-property-updates | filter

# shouldn't need to run this: it's already covered by the above
$mvns -f $bom -Pversions versions:display-dependency-updates | filter

# shouldn't need to run this: it's already covered by the above
$mvns -f $bom -Pversions versions:display-plugin-updates | filter
