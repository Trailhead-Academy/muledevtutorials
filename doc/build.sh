#!/bin/bash

# build all docs in an environment where the Asciidoctor toolchain is available

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

# build manual
cd manual
./build.sh
cd ..
