#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

./sh/initdist.sh

source sh/conf.sh

# cargo build --release

meta=$(cargo metadata --format-version=1 --no-deps)
ver=$(echo $meta | jq -r '.packages[0].version')

cfg=$(rustc --print cfg)
arch=$(echo "$cfg" | grep target_arch | awk -F '"' '{print $2}')
os=$(echo "$cfg" | grep target_os | awk -F '"' '{print $2}')
target_env=$(rustc --print cfg | grep target_env | awk -F '"' '{print $2}')

if [[ -n "$target_env" ]]; then
  target_env="-$target_env"
fi

export name_ver=$name-$ver

branch=$name_ver.$os-$arch$target_env

CARGO_RELEASE=$DIR/target/release
OUTPUT_DIR=$CARGO_RELEASE/$branch

rm -rf $OUTPUT_DIR

mkdir -p $OUTPUT_DIR

cargo build -Z unstable-options --release --out-dir $OUTPUT_DIR

cd $CARGO_RELEASE

tarname=$branch.tar.bz2

tar -jcvf $tarname $branch

b3sum --raw $tarname >$tarname.b3
