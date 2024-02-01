#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*}
cd $ROOT
set -ex

if ! command -v cross &>/dev/null; then
  cargo install cross
fi

cs() {
  cross $1 -Z unstable-options --release --target $2 ${@:3}
}

csbr() {
  for i in "$@"; do
    cs build $i --out-dir target/$i/release
  done

}

csbr aarch64-pc-windows-msvc
