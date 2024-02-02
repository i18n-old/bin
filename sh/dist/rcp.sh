#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -e

source conf/S3.sh

rclone copy $1 $S3/$2
