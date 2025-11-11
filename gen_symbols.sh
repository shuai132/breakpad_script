#!/bin/bash
set -e

is_elf_file() {
  local file="$1"
  if [ -f "$file" ] && [ -r "$file" ] && file "$file" | grep -q "ELF"; then
    return 0
  else
    return 1
  fi
}

function foreach_dir() {
  # shellcheck disable=SC2045
  for element in $(ls "$1"); do
    dir_or_file=$1"/"$element
    if [ -d "$dir_or_file" ]; then
      foreach_dir "$dir_or_file" "$2"
    else
      if is_elf_file "$dir_or_file"; then
        echo "Processing ELF file: $dir_or_file"
        flock /tmp/breakpad_gen_sym.lock bash gen_sym.sh "$dir_or_file" "$2"
      else
        echo "Skipping non-ELF file: $dir_or_file"
      fi
    fi
  done
}

foreach_dir "$1" "$2"
