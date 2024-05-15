#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Creates an asset for the student manual of this course based on the current state of this repo.
# This asset is intended for a new release of this course and 
# is created as a PDF file in the assets sub-directory of the current directory.
#
# The asset name will include the Mule runtime version this course release is based on
# as well as the current date (in format 07may2020). Both of these are determined automatically.
#
# Outputs to stderr the name of the asset file (which was created in the assets sub-directory):
# APDevPRDev4.3_studentManual_07may2020.pdf
#
# Assumes that the manual is already built and committed to GitHub
# and can therefore be run from a fresh clone of this GitHub project.
#
# Usage: create-manual-asset-for-part1.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

source set-release-vars.sh

# determine asset name from all its components
assetname="$course$muleVersion""_studentManual_$today" # APDevPRDev4.3_studentManual_07may2020
assetfile="$assetname.pdf"                             # APDevPRDev4.3_studentManual_07may2020.pdf

echo "Creating $assetfile"
cd $assetsdir
rm -f $assetfile
cp "$manualdir"/*manual*.pdf $assetfile

# output to stderr the path of newly created asset, relative to the assets directory
cd $assetsdir
echo $(ls "$assetfile") 1>&2
