#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this Mule app to the given CloudHub environment using the given configuration
#
# Usage  : deploy-to-ch.sh <env> <suffix> <worker-type> <client-id>                      <client-secret>                  <secure-props-key>
# Example: deploy-to-ch.sh prod  ''       MICRO         e0............................99 FD............................85 securePropsCryptoKey

ENV=$1        # Environment identifier, only for the Mule app properties files selection, NOT for AP environment
SUFFIX=$2     # Mule app name suffix
CHWORKER=$3   # CloudHub worker type (MICRO, SMALL, ...)
APCID=$4      # Anypoint Platform client ID to register with API Manager for autodiscovery
APSECRET=$5   # Anypoint Platform client secret for client ID
ENCRYPTKEY=$6 # Mule app secure properties en/decryption key

APREGION=us-east-1

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../../etc/settings.xml"
mvns="mvn -s $sts -ff"

echo Confiuguration environment  : $ENV
echo Mule app name suffix        : $SUFFIX
echo Anypoint Platform region    : $APREGION
echo CloudHub worker type        : $CHWORKER
echo Anypoint Platform client ID : $APCID

$mvns -DmuleDeploy deploy \
      -Ddeployment.env=$ENV -Ddeployment.suffix=$SUFFIX \
      -Dap.region=$APREGION -Dch.workerType=$CHWORKER \
      -Dap.client_id=$APCID -Dap.client_secret=$APSECRET \
      -Dencrypt.key=$ENCRYPTKEY
