#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

DIRSH=$DIR/sh

$DIRSH/initdist.sh

cd $DIR/target/bin

export ver=v$(cargo metadata --format-version=1 --no-deps | jq '.packages[0].version' -r)

dist() {
  $DIRSH/rcp.sh $@ $ver/
  $DIRSH/dist.gh.sh $@
}

find . -mindepth 1 -maxdepth 1 -type d | while read file; do
  tarname=$file.tar.xz
  tar -cJvf $tarname $file
  b3sum --raw $tarname >$tarname.b3
  dist $tarname
  dist $tarname.b3
done
