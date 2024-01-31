#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
source $DIR/conf.sh

set -ex

for i in ${S3[@]}; do
  for fp in "$@"; do
    rclone copy $fp $i &
  done
done

wait
