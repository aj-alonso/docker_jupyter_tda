#!/usr/bin/env bash

set -euo pipefail

git clone https://github.com/rivettda/rivet-python
cd rivet-python
pip install -e .
