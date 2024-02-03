#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*/*}
set -ex

$DIR/init.sh

BIN=$ROOT/target/bin
cd $BIN

. $DIR/VER.sh

dist() {
  $DIR/gh.sh $BIN/$1
}

find . -mindepth 1 -maxdepth 1 -type d | while read file; do
  tarname=$(basename $file).tar.xz
  tar -cJvf $tarname $file
  b3sum --raw $tarname >$tarname.b3
  dist $tarname
  dist $tarname.b3
done
