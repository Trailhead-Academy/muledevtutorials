# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.

# generate diagrams in SVG and PNG format
echo Generate diagrams
asciidoctor --verbose -r asciidoctor-diagram -a img=svg asciidoctor-diagrams.adoc
asciidoctor --verbose -r asciidoctor-diagram -a img=png asciidoctor-diagrams.adoc

# generate main doc, using diagrams generated above
echo Generate main doc in HTML format
asciidoctor --verbose                        -a img=svg *manual*.adoc
