#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*}
cd $DIR
set -ex

source RUSTFLAGS.sh

meta=$(cargo metadata --format-version=1 --no-deps)
installed=$(rustup target list --installed)
ver=$(echo $meta | jq -r '.packages[0].version')

unameOut="$(uname -s)"

target_list=$(rustup target list | awk '{print $1}')

case "${unameOut}" in
Linux*) TARGET_LI=$(echo "$target_list" | grep "\-linux-" | grep -E "x86|aarch64" | grep -E "[musl|gun]$" | grep -v "i686-unknown-linux-musl") ;;
Darwin*) TARGET_LI=$(echo "$target_list" | grep "\-apple-" | grep -v "\-ios") ;;
esac

if ! command -v cargo-zigbuild &>/dev/null; then
  cargo install cargo-zigbuild
fi

build_mv() {
  cargo zigbuild --release --target $1
  $DIR/cross/mv.sh $ver $1
}

for target in ${TARGET_LI[@]}; do
  (echo $installed | grep -q $target || rustup target add $target) && rustup update nightly
  build_mv $target
done

if [ "$unameOut" == "Darwin" ]; then
  build_mv universal2-apple-darwin
fi
