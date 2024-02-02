#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*/*}
set -ex

$DIR/init.sh

BIN=$ROOT/target/bin
cd $BIN

export ver=v$(cargo metadata --format-version=1 --no-deps | jq '.packages[0].version' -r)

dist() {
  $DIR/rcp.sh $BIN/$1 $ver/
  $DIR/gh.sh $BIN/$1
}

find . -mindepth 1 -maxdepth 1 -type d | while read file; do
  tarname=$file.tar.xz
  tar -cJvf $tarname $file
  b3sum --raw $tarname >$tarname.b3
  dist $tarname
  dist $tarname.b3
done
