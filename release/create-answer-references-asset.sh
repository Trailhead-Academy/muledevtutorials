#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Creates an asset for the answer references (Mule apps, etc.) of this certification based on the current state of this repo.
# This asset is intended for a new release of this certification and 
# is created as a zip file in the assets sub-directory of the current directory.
#
# The asset name will include the Mule runtime version this course release is based on
# as well as the current date (in format 07may2020). Both of these are determined automatically.
#
# Outputs to stderr the name of the asset file (which was created inthe assets sub-directory):
# MCDL14.3_answerReferences_07may2020.zip
#
# Performs any build necessary to package all artifacts required for this asset,
# and can therefore be run from a fresh clone of this GitHub project.
#
# The secure properties key used for decrypting secure (encrypted) properties only has to be provided 
# if there is at least one Mule app that actually needs to decrypt secure properties:
# the provided value sets a Java system property named "encrypt.key" for the entire build, i.e., all Mule apps
#
# Usage  : create-answer-references-asset.sh [secure-props-key]  
# Example: create-answer-references-asset.sh securePropsCryptoKey

ENCRYPTKEY=${1:-1234567890123456} # Mule app secure properties en/decryption key, defaulting to formally valid key for AES

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

source set-release-vars.sh

# determine asset name from all its components
assetname="$course$muleVersion""_answerReferences_$today" # MCDL14.3_answerReferences_07may2020
assetfile="$assetname.zip"                                # MCDL14.3_answerReferences_07may2020.zip

echo "Building all artifacts required for $assetname"
"$solutionsdir"/build.sh "$ENCRYPTKEY"

echo "Staging $assetname"
cd $assetsdir
rm -rf $assetname && mkdir $assetname && cd $assetname
cp "$solutionsdir"/standalone-apps/*/target/*.jar ./

echo "Creating $assetfile"
cd $assetsdir
rm -f $assetfile
zip -r -9 $assetfile $assetname

# output to stderr the path of newly created asset, relative to the assets directory
cd $assetsdir
echo $(ls "$assetfile") 1>&2
