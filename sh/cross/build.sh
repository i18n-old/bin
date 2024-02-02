#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
ROOT=${DIR%/*}
set -ex

source ../RUSTFLAGS.sh

if ! command -v cross &>/dev/null; then
  cargo install cross
fi

ver=$(cargo metadata --no-deps --format-version=1 | jq -r '.packages[0].version')

cs() {
  ./target.sh $1
  cross build --release -Z build-std=std,panic_abort --target $1
  ./mv.sh $ver $1
}

# 这样无效,不知道为什么
# STATIC="$RUSTFLAGS -C target-feature=+crt-static"
# export CARGO_TARGET_X86_64_PC_WINDOWS_MSVC_RUSTFLAGS=$STATIC
# export CARGO_TARGET_AARCH64_PC_WINDOWS_MSVC_RUSTFLAGS=$STATIC

# 不静态编译会提示缺少 vcruntime140.dll
RUSTFLAGS="$RUSTFLAGS -C target-feature=+crt-static"

WIN=(x86_64-pc-windows-msvc aarch64-pc-windows-msvc)

for i in ${WIN[@]}; do
  cs $i
done
