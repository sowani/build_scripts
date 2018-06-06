#!/bin/bash
# These are build instructions and sequence to build Chrome. In reality, it
# does not get built on Power yet. This is just for record.
# Ref.: https://chromium.googlesource.com/chromium/src/+/master/docs/linux_build_instructions.md

apt-get update -y
apt-get install -y git python lsb-release
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:`pwd`/depot_tools
mkdir ~/chromium && cd ~/chromium
fetch --nohooks chromium
cd src
gclient runhooks

# Start build.
gn gen out/Default
ninja -C out/Default chrome

# To run unit tests.
out/Default/unit_tests

# To run Chrome which got built.
out/Default/chrome
