#!/usr/bin/env bash

set -euo pipefail

git clone https://github.com/rivetTDA/rivet.git
cd rivet
git apply /opt/rivet_fix_docopt.patch
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
