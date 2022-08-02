#!/bin/bash
set -e

SOURCE_DIR=$1
OUTPUT_DIR=$2
C_COMPILER=$3
CXX_COMPILER=$4
C_FLAGS=$5
CXX_FLAGS=$6
INSTALL_DIR=$7

if [ "$7" == "" ]; then
  echo "error: need more parameters"
  exit 1
fi

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
make -j32
make install

BREAKPAD_DIR=$CURRENT_DIR/$INSTALL_DIR
mkdir -p "$BREAKPAD_DIR"/include
mkdir -p "$BREAKPAD_DIR"/libs

cp -rf "$OUTPUT_DIR"/include "$BREAKPAD_DIR"
cp -f "$OUTPUT_DIR"/lib/libbreakpad_client.a "$BREAKPAD_DIR"/libs
