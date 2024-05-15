#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Create settings.xml from settings.xml.template replacing placeholders with actual credentials passed on command-line.
#
# Usage  : create-settings-xml-from-template.sh <username-for-releases-ee-repo>   <password-for-releases-ee-repo> <username-for-cloudhub-deploy>   <password-for-cloudhub-deploy>
# Example: create-settings-xml-from-template.sh usernameForMuleSoftReleasesEERepo passwdForMuleSoftReleasesEERepo usernameForCHServerEntryToDeploy passwdForCHServerEntryToDeploy

EE_UNAME="$1" # username for releases-ee repo
EE_PASSW="$2" # password for releases-ee repo
CH_UNAME="$3" # username for cloudhub server entry used for deployment to CloudHub
CH_PASSW="$4" # password for cloudhub server entry used for deployment to CloudHub

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sed -e 's,{{ee.uname}},'"$EE_UNAME"',g' \
    -e 's,{{ee.passw}},'"$EE_PASSW"',g' \
    -e 's,{{ch.uname}},'"$CH_UNAME"',g' \
    -e 's,{{ch.passw}},'"$CH_PASSW"',g' \
    settings.xml.template > settings.xml
