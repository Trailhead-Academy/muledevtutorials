#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Build this Mule project
# including running all (unit) tests (can be skipped, default is false, i.e., don't skip if not provided), and
# beforehand install (which may include: build) all required local dependencies (those in the same monorepo)
#
# The secure properties key used for decrypting secure (encrypted) properties only has to be provided 
# if there are actually secure properties to decrypt: the provided value sets a Java system property named "encrypt.key"
#
# Usage  : build.sh [secure-props-key]   [skip-tests]
# Example: build.sh securePropsCryptoKey false       

ENCRYPTKEY=${1:-1234567890123456} # Mule app secure properties en/decryption key, defaulting to formally valid key for AES
SKIP_TESTS=${2:-false}            # whether to skip (MUnit) tests, if not set default to false

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../../../etc/settings.xml"
mvns="mvn -s $sts -ff -U"

UNIT="$(basename $scriptdir)"

# install the parent POM this project depends on
../../../install-parent-poms.sh

echo "Building $UNIT"
$mvns install -Dencrypt.key=$ENCRYPTKEY -Dmunit.skip=$SKIP_TESTS
