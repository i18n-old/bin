#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
ROOT=${DIR%/*}
set -ex

source ../RUSTFLAGS.sh

if ! command -v cross &>/dev/null; then
  cargo install cross
fi

cs() {
  cross $1 -Z unstable-options --release --target $2 ${@:3}
}

ver=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

csbr() {
  for i in "$@"; do
    cs build $i
    ./mv.sh $ver $i
  done
}

csbr x86_64-pc-windows-msvc aarch64-pc-windows-msvc
