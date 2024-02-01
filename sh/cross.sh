#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*}
cd $DIR
set -ex

source RUSTFLAGS.sh

installed=$(rustup target list --installed)

unameOut="$(uname -s)"

target_list=$(rustup target list | awk '{print $1}')

case "${unameOut}" in
Linux)
  ./cross/build.sh &
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
  (echo $installed | grep -q $target || rustup target add $target) && rustup update nightly
  build_mv $target
done

wait
# if [ "$unameOut" == "Darwin" ]; then
#   build_mv universal2-apple-darwin
# fi
