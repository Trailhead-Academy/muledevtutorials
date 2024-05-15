#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Format all source code - at the moment this is only XML files (Mule flow XML files, Maven POMs, log4j config files, etc.)

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -fae -U -q"

./install-parent-poms.sh

echo "Formatting XML files"
$mvns -f parent-pom.xml process-sources -Pformat
