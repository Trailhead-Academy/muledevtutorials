#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Adapt a GitHub repo that was newly created from the template repo https://github.com/mulesoft-consulting/training-template
# to the course/cert that the repo was created for.
#
# This is done by searching placeholder tokens in all files contained in the repo
# and replacing them with values that fit the course/cert of the newly created repo.
#
# This works only once, immediately after the repo was created from the template.
# Afterwards, this script should be deleted from the newly created repo.
#
# Usage:   adapt-content-of-newly-created-repo.sh <repo-name>          <first-half-of-official-name>   <second-half-of-official-name>           <official-abbrev> <minimal-lowercase-abbrev>
# Example: adapt-content-of-newly-created-repo.sh training-APDevLevel2 "Anypoint Platform Development" "Production-Ready Development Practices" "APDevPRDev"      devl2

SCRIPT="$0" # filename of this script
REPO="$1"   # the plain GitHub repo name, which must be in the mulesoft-consulting GitHub org, e.g., "training-APDevLevel2"
NAME_1="$2" # first  half of the official course/cert name, e.g., "Anypoint Platform Development"
NAME_2="$3" # second half of the official course/cert name, e.g., "Production-Ready Development Practices"
ABBREV="$4" # official course/cert abbreviation, e.g., "APDevPRDev"
MINABB="$5" # minimal lower-case course/cert abbreviation , e.g., "devl2", "opsprm", "mcdl1"

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

echo "GitHub repo name                  : $REPO"
echo "Official course/cert name         : $NAME_1: $NAME_2"
echo "Official course/cert abbreviation : $ABBREV"
echo "Minimal lower-case abbreviation   : $MINABB"

bak=".before-replacement"

# iterate over all files that might contain placeholder tokens
find . -type f \( -name '*.sh' -or -name '*.adoc' -or -name '*.xml' -or -name '*.yaml' \) -not -path './.git/*' -not -path "$SCRIPT" -exec                            \
  sed -i $bak                                                                                          \
	  -e "s,github.com/mulesoft-consulting/training-template/,github.com/mulesoft-consulting/$REPO/,g" \
	  -e "s,REPL_OfficialNameFirstHalf_REPL,$NAME_1,g"                                                 \
	  -e "s,REPL_OfficialNameSecondHalf_REPL,$NAME_2,g"                                                \
	  -e "s,REPL_OfficialAbbrev_REPL,$ABBREV,g"                                                        \
	  -e "s,REPL_MinimalLCAbbrev_REPL,$MINABB,g"                                                       \
	  {}  \;

find . -type f -name "*$bak" -delete
