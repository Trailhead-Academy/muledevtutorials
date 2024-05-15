#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Build all artifacts here and below here
# including running all (unit) tests (can be skipped, default is false, i.e., don't skip if not provided), and
# beforehand install (which may include: build) all required local dependencies (those in the same monorepo)
#
# The secure properties key used for decrypting secure (encrypted) properties only has to be provided 
# if there is at least one Mule app that actually needs to decrypt secure properties:
# the provided value sets a Java system property named "encrypt.key" for the entire build, i.e., all Mule apps
#
# Usage  : build.sh [secure-props-key]   [skip-tests]
# Example: build.sh securePropsCryptoKey false       

ENCRYPTKEY=${1:-1234567890123456} # Mule app secure properties en/decryption key, defaulting to formally valid key for AES
SKIP_TESTS=${2:-false}            # whether to skip (MUnit) tests, if not set default to false

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="$(basename $scriptdir)"

# install the parent POMs these projects depend on
./domains-and-domain-apps/template-domain/apps/install-parent-poms.sh
./standalone-apps/install-parent-poms.sh

echo "Building $UNIT"
./domains-and-domain-apps/template-domain/build.sh   "$ENCRYPTKEY" "$SKIP_TESTS" true
./standalone-apps/build.sh                           "$ENCRYPTKEY" "$SKIP_TESTS" true
