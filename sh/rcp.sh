#!/usr/bin/env bash

set -ex

for i in ${S3[@]}; do
  for fp in "$@"; do
    rclone copy $fp $i &
  done
done

wait
