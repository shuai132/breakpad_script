#!/bin/bash
set -e

LIBS_PATH=$1
OUTPUT_DIR=$2

TMP_ROOT=".tmp"
mkdir -p $TMP_ROOT

TMP_SYM_FILE="$TMP_ROOT/tmp.sym"
TMP_SYM_DIR="$OUTPUT_DIR"

function gen_sym() {
  LIBS_PATH=$1

  ./bin/dump_syms "$LIBS_PATH" >$TMP_SYM_FILE

  # shellcheck disable=SC2006
  info=$(head -n1 $TMP_SYM_FILE)
  # MODULE Linux arm 4EFE5BD5BE5099DC9EF048936A6279C10 libxx.so
  echo "sym info:$info"

  # shellcheck disable=SC2206
  info_array=($info)

  #sym_type=${info_array[0]}
  #sym_os=${info_array[1]}
  #sym_arch=${info_array[2]}
  sym_hash=${info_array[3]}
  sym_name=${info_array[4]}

  echo "sym_hash: $sym_hash"
  echo "sym_name: $sym_name"

  mkdir -p "$TMP_SYM_DIR/$sym_name/$sym_hash"
  mv $TMP_SYM_FILE "$TMP_SYM_DIR/$sym_name/$sym_hash/$sym_name.sym"
}

function foreach_dir() {
  # shellcheck disable=SC2045
  for element in $(ls "$1"); do
    dir_or_file=$1"/"$element
    if [ -d "$dir_or_file" ]; then
      foreach_dir "$dir_or_file"
    else
      echo "$dir_or_file"
      gen_sym "$dir_or_file"
    fi
  done
}
foreach_dir "$LIBS_PATH"
