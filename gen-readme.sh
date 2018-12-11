#!/bin/sh
#
# Be sure this script is executed any time the license terms or readme inputs are altered!
#

for input in $(ls -1 */readme.yaml); do
    gomplate --context .=$input -f image-readme.tmpl.md -o $(dirname $input)/README.md
done
