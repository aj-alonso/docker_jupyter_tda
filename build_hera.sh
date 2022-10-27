#!/usr/bin/env bash
set -euo pipefail

git clone https://github.com/anigmetov/hera.git
cd hera
mkdir build
cd build
cmake .. -DHERA_BUILD_EXAMPLES=ON
make
