#!/usr/bin/env bash

set -ex

for i in ${S3[@]}; do
  rclone copy $1 $i/$2
done
