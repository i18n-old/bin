#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR
set -ex

DIRSH=$DIR/sh

$DIRSH/initdist.sh

cd $DIR/target/bin

dist() {
  $DIRSH/rcp.sh $@
  $DIRSH/dist.gh.sh $@
}

find . -mindepth 1 -maxdepth 1 -type d | while read file; do
  tarname=$file.tar.xz
  tar -cJvf $tarname $file
  b3sum --raw $tarname >$tarname.b3
  dist $tarname
  dist $tarname.b3
done