#!/bin/bash
# Repo: https://github.com/apple/swift.git

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y cmake ninja-build clang python uuid-dev libicu-dev \
    icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig \
    libpython-dev libncurses5-dev pkg-config libblocksruntime-dev ocaml \
    libcurl4-openssl-dev autoconf libtool systemtap-sdt-dev tzdata rsync \
    ca-certificates libstdc++-5-dev libobjc-5-dev git \
    build-essential g++

WDIR=`pwd`
export SWIFT_SOURCE_ROOT=$WDIR/swift-source
export SWIFT_BUILD_ROOT=$WDIR/swift-source
export SWIFT_PATH_TO_LLVM_SOURCE=$WDIR/swift-source/llvm
export PATH=$PATH:$SWIFT_BUILD_ROOT/buildbot_incremental/llvm-linux-powerpc64le/bin:$SWIFT_BUILD_ROOT/buildbot_incremental/swift-linux-powerpc64le/bin

mkdir swift-source
cd swift-source
git clone https://github.com/sowani/swift.git
./swift/utils/update-checkout --clone --scheme "swift-4.1-branch"

#git config --global user.name "asowani"
#git config --global user.email "sowania@us.ibm.com"

mv swift-corelibs-foundation swift-corelibs-foundation.org
git clone https://github.com/sowani/swift-corelibs-foundation -b "swift-4.1-branch"

mv swiftpm swiftpm.org
git clone https://github.com/sowani/swift-package-manager swiftpm -b "swift-4.1-branch"

mv clang clang.org
git clone https://github.com/sowani/swift-clang clang -b "swift-4.1-branch"

cd swift

mv test/IRGen/c_functions.swift test/IRGen/c_functions.swift.org
mv test/IRGen/errors.sil test/IRGen/errors.sil.oef
mv test/IRGen/errors.sil.oef test/IRGen/errors.sil.org
mv test/IRGen/objc_simd.sil test/IRGen/objc_simd.sil.org
#mv test/Sanitizers/witness_table_lookup.swift test/Sanitizers/witness_table_lookup.swift.org
mv test/Sanitizers/tsan.swift test/Sanitizers/tsan.swift.org
mv test/Driver/linker-args-order-linux.swift test/Driver/linker-args-order-linux.swift.org
mv test/IRGen/big_types_corner_cases.swift test/IRGen/big_types_corner_cases.swift.org
mv test/IRGen/clang_inline_opt.swift test/IRGen/clang_inline_opt.swift.org


# Following command builds and run standard test suite for Swift.
#utils/build-script --no-assertions --release --test --validation-test \
#  --lit-args=-v --build-subdir=buildbot_incremental --llbuild --swiftpm \
#  --xctest --foundation --libdispatch -- --reconfigure --jobs 16

#utils/build-script --preset buildbot_linux install_destdir=/tmp installable_package=/tmp

utils/build-script \
	--release --assertions \
	--llbuild \
	--swiftpm \
	--xctest \
	--no-swift-stdlib-assertions \
	--test --validation-test --long-test \
	--foundation \
	--libdispatch \
	--lit-args=-v \
	-- \
	--build-ninja \
	--install-swift \
	--install-swiftpm \
	--install-xctest \
	--install-prefix=/usr \
	--swift-enable-ast-verifier=0 \
	--build-swift-static-stdlib \
	--build-swift-static-sdk-overlay \
	--build-swift-stdlib-unittest-extra \
	--test-installable-package \
	--install-destdir=/swift-build \
	--install-libdispatch \
	--reconfigure \
        --skip-test-cmark \
        --skip-test-lldb \
        --skip-test-swift \
        --skip-test-llbuild \
        --skip-test-swiftpm \
        --skip-test-xctest \
        --skip-test-foundation \
        --skip-test-libdispatch \
        --skip-test-playgroundsupport \
        --skip-test-libicu

#	--installable-package "swift-ow-linux-$(uname -m)" \
