#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Update all files that hold license information

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -fae -U -q"

echo "Installing dependencies required for updating license information"
# must install into Maven repo all domain projects to be able to update license information (skipping tests)
./domains-and-domain-apps/template-domain/domain/build.sh unused true

echo "Updating license information"
# must execute a phase that the Mule Maven plugin is not bound to: using clean instead of process-resources
$mvns clean -Plicense -DbuildRootDir="$scriptdir"
