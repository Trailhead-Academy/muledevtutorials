#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Display the currently configured Mule runtime version used by this build as major.minor.patch, such as 4.3.0
# Any suffix to the version, such as '-hf1' or '-rc3' is stripped off, so 4.2.2-hf5 is reported as 4.2.2 
# 
# This requires a Maven dependency on com.mulesoft.mule.distributions:mule-runtime-impl-bom
# to be managed by bom.xml.
#
# Usage: display-mule-runtime-version-in-use.sh

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
dep="com.mulesoft.mule.distributions:mule-runtime-impl-bom"

filter() {
	grep -A1 "$dep" \
	| tr '\n' ' '   \
	| perl -pe 's|.*?(\d+\.\d+\.\d+).*|\1|gs'
}

$mvns -f $bom -Pversions versions:display-dependency-updates -Dverbose | filter
