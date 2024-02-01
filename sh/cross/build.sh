#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
ROOT=${DIR%/*}
set -ex

source ../RUSTFLAGS.sh

if ! command -v cross &>/dev/null; then
  cargo install cross
fi

ver=$(cargo metadata --format-version=1 | jq -r '.packages[0].version')

cs() {
  ./target.sh $1
  cross build --target $1 --release
  ./mv.sh $ver $1
}

STATIC="$RUSTFLAGS -Ctarget-feature=+crt-static"
CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_RUSTFLAGS=$STATIC
CARGO_TARGET_AARCH64_PC_WINDOWS_MSVC_RUSTFLAGS=$STATIC

WIN=(x86_64-pc-windows-msvc aarch64-pc-windows-msvc)

for i in ${WIN[@]}; do
  cs $i
done
