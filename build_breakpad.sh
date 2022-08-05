#!/bin/bash
set -e

echo "$0 parameters:"
echo "SOURCE_DIR:$SOURCE_DIR"
echo "OUTPUT_DIR:$OUTPUT_DIR"
echo "C_COMPILER:$C_COMPILER"
echo "CXX_COMPILER:$CXX_COMPILER"
echo "C_FLAGS:$C_FLAGS"
echo "CXX_FLAGS:$CXX_FLAGS"
echo "INSTALL_DIR:$INSTALL_DIR"
echo ""

# shellcheck disable=SC2046
CURRENT_DIR=$(cd $(dirname "$0") && pwd)

cd "$SOURCE_DIR"

# fix breakpad src
THIRD_PARTY_LSS_DIR="$SOURCE_DIR"/src/third_party/lss
mkdir -p "$THIRD_PARTY_LSS_DIR"
cp -f "$CURRENT_DIR"/fix/linux_syscall_support.h "$THIRD_PARTY_LSS_DIR"

# avoid compile error
FIX_FLAGS="-fno-strict-aliasing"

# remove -g
C_FLAGS=${C_FLAGS/-g/""}
CXX_FLAGS=${CXX_FLAGS/-g/""}

# compile breakpad
export CC=${C_COMPILER}
export CXX=${CXX_COMPILER}
export CFLAGS="${C_FLAGS} ${FIX_FLAGS}"
export CXXFLAGS="${CXX_FLAGS} ${FIX_FLAGS}"
./configure --host=arm-linux --prefix="$OUTPUT_DIR"
make clean
make -j32
make install

mkdir -p "$INSTALL_DIR"/include
mkdir -p "$INSTALL_DIR"/libs

cp -rf "$OUTPUT_DIR"/include "$INSTALL_DIR"
cp -f "$OUTPUT_DIR"/lib/libbreakpad_client.a "$INSTALL_DIR"/libs
