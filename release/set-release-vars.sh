# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.

# Helper script that sets shell variables characterizing a new release of this material.
# Must be sourced from a main script located in the same directory as this script
# after scriptdir has been set and with the current dir being $scriptdir

course="REPL_OfficialAbbrev_REPL"      # e.g., APDevPRDev, MCDL1, ...
solutionsdir="$scriptdir/../solutions"
manualdir="$scriptdir/../doc/manual"
assetsreldir=assets
assetsdir="$scriptdir/$assetsreldir"

# determine asset name from all its components
today=$(date -u '+%d%b%Y' | tr '[:upper:]' '[:lower:]')                 # 07may2020
muleVersionFull=$($solutionsdir/display-mule-runtime-version-in-use.sh) # 4.3.0
muleVersion=${muleVersionFull%.*}                                       # 4.3
