#!/bin/bash

dir="$(dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")"

target=$1
sed -i -r 's/^('"$target"'\t)([0-9]*)[\.]([0-9]*)[\.]([0-9]*)$/echo "\1\2.\3.$((\4+1))"/eg' $dir/VERSIONS

awk -v t=$target -F '\t' '{ if ($1 == t) print $2 }' $dir/VERSIONS
