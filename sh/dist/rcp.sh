#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -ex

source conf.sh

for i in ${S3[@]}; do
  rclone copy $1 $i/$2
done
