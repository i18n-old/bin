#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*/*}
cd $DIR
set -ex

ver=$1
arch=$2

TARGET=$DIR/target

BIN=$TARGET/bin

OUT=$BIN/$ver.$arch

rm -rf $OUT

mkdir -p $OUT

find $TARGET/$arch/release -maxdepth 1 -type f -perm +u=x | while read file; do
  mv "$file" $OUT/
done
