#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

./sh/initdist.sh

source sh/conf.sh

cargo build --release
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

cd $DIR/target/release

rm -rf $branch
mkdir -p $branch

binname=$(echo $meta | jq -r '.packages[0].name')
mv $binname $branch/$name

tarname=$branch.tar.bz2

tar -jcvf $tarname $branch

b3sum --raw $tarname >$tarname.b3

DIRSH=$DIR/sh
dist() {
  $DIRSH/rcp.sh $@
  $DIRSH/dist.gh.sh $@
}

dist $tarname $tarname.b3
