#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
ROOT=${DIR%/*}
set -ex

source ../RUSTFLAGS.sh

if ! command -v cross &>/dev/null; then
  cargo install cross
fi

ver=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

cs() {
  cross build --target $1 --release
  ./mv.sh $ver $1
}

STATIC=

# CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="$RUSTFLAGS $STATIC"

CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_RUSTFLAGS=CARGO_TARGET_AARCH64_PC_WINDOWS_MSVC_RUSTFLAGS="$RUSTFLAGS -Ctarget-feature=+crt-static"

for i in ${x86_64-pc-windows-msvc aarch64-pc-windows-msvc}; do
  cs build $i
done
