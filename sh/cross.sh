#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*}
cd $DIR
set -ex

source RUSTFLAGS.sh

unameOut="$(uname -s)"

case "${unameOut}" in
Linux)
  build="zigbuild"
  docker pull i18nsite/x86_64-pc-windows-msvc-cross &
  docker pull i18nsite/aarch64-pc-windows-msvc-cross &
  if ! command -v cargo-zigbuild &>/dev/null; then
    cargo install cargo-zigbuild
  fi
  TARGET_LI=$(rustup target list | awk '{print $1}' | grep "\-linux-" | grep -E "x86|aarch64" | grep -E "[musl|gun]$" | grep -v "i686-unknown-linux-musl")
  ;;
Darwin)
  TARGET_LI=$(rustc -vV | awk '/host/ { print $2 }')
  build="build" # -Z unstable-options
  ;;
esac

. $DIR/dist/VER.sh
rustup component add rust-src --toolchain nightly

for target in ${TARGET_LI[@]}; do
  ./cross/target.sh $target
  build_mv $target
  cargo $build -Z build-std=std,panic_abort --release --target $target &
done

wait

for target in ${TARGET_LI[@]}; do
  $DIR/cross/mv.sh $VER $target
done

if [ "$unameOut" == "Linux" ]; then
  ./cross/build.sh
fi
