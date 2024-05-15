#!/bin/bash

# build all docs using an Asciidoctor Docker image
# in an environment where only the Docker daemon must be running

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

image="integrational/asciidoctor:latest"

docker pull $image

# must mount this scriptdir's parent directory into the container's working directory (/documents) 
# because AsciiDoc sources may use include to access files from the ../solutions directory
# then, from within the container's working directory, the build.sh script to be executed
# is located one directory down, which then is equivalent to this scriptdir
#
thisRelDir="$(basename "$scriptdir")"  # evaluates to 'doc'
parentAbsDir="$(dirname "$scriptdir")" # evaluates to absolute path of parent directory, of which doc is a direct sub-directory
docker run --rm --name asciidoctor -t -v "$parentAbsDir":/documents $image "./$thisRelDir/build.sh"
