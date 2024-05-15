#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# In all source code files where this is possible, update license information and format the code.
# After running this script you should commit and push to Git.
#
# Usage: normalize-all-source-code.sh.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

echo "Normalizing all source code"
./update-license-information.sh
./format-source-code.sh
