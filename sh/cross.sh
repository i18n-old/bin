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

ver=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

rustup component add rust-src --toolchain nightly

build_mv() {
  cargo $build -Z build-std=std,panic_abort --release --target $1
  $DIR/cross/mv.sh $ver $1
}

for target in ${TARGET_LI[@]}; do
  ./cross/target.sh $target
  build_mv $target
done

wait
if [ "$unameOut" == "Linux" ]; then
  ./cross/build.sh
fi
