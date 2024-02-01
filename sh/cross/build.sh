#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

if ! command -v cross &>/dev/null; then
  cargo install cross
fi

cs() {
  cross $1 -Z unstable-options --release --target $2 ${@:3}
}

csbr() {
  for i in "$@"; do
    cs build $i --out-dir target/bin/$i
  done

}

cd $DIR

csbr aarch64-apple-darwin x86_64-apple-darwin x86_64-unknown-linux-musl
