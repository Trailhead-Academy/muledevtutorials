# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.

./build-html-only.sh

# generate main doc, using diagrams generated before
echo Generate main doc in PDF format
asciidoctor-pdf --verbose -a img=svg *manual*.adoc
