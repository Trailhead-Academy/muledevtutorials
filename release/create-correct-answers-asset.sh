#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Creates an asset for the correct answers of this certification based on the current state of this repo.
# This asset is intended for a new release of this certification and 
# is created as a zip file in the assets sub-directory of the current directory.
#
# Must be run after create-answer-references-asset.sh because requires a build to have been performed by that
# script !
#
# The asset name will include the Mule runtime version this course release is based on
# as well as the current date (in format 07may2020). Both of these are determined automatically.
#
# Outputs to stderr the name of the asset file (which was created inthe assets sub-directory):
# MCDL14.3_answerReferences_07may2020.zip
#
# Usage  : create-correct-answers-asset.sh
# Example: create-correct-answers-asset.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

source set-release-vars.sh

# determine asset name from all its components
assetname="$course$muleVersion""_correctAnswers_$today" # MCDL14.3_correctAnswers_07may2020
assetfile="$assetname.txt"                              # MCDL14.3_correctAnswers_07may2020.txt

echo "Creating $assetfile"
cd $assetsdir
rm -f $assetfile
cat "$solutionsdir"/standalone-apps/*/target/correctAnswers.log | sort -n > $assetfile

# output to stderr the path of newly created asset, relative to the assets directory
cd $assetsdir
echo $(ls "$assetfile") 1>&2
