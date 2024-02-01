#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*}
cd $DIR
set -ex

source RUSTFLAGS.sh

unameOut="$(uname -s)"

target_list=$(rustup target list | awk '{print $1}')

case "${unameOut}" in
Linux)
  docker pull i18nsite/x86_64-pc-windows-msvc-cross &
  docker pull i18nsite/aarch64-pc-windows-msvc-cross &
  TARGET_LI=$(echo "$target_list" | grep "\-linux-" | grep -E "x86|aarch64" | grep -E "[musl|gun]$" | grep -v "i686-unknown-linux-musl")
  ;;
Darwin) TARGET_LI=$(echo "$target_list" | grep "\-apple-" | grep -v "\-ios") ;;
esac

if ! command -v cargo-zigbuild &>/dev/null; then
  cargo install cargo-zigbuild
fi

ver=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

build_mv() {
  cargo zigbuild --release --target $1
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
