#!/bin/bash
# Ref.: https://github.com/google/breakpad

yum update -y
yum install -y git python make gcc-c++
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:`pwd`/depot_tools
mkdir breakpad && cd breakpad
fetch breakpad
cd src
./configure && make
make check
make install
