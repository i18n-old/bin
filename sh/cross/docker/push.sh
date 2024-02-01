#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

docker images
source target.sh

TAG_LI=($(date +"%Y%m%d") latest)

for arch in ${TARGET_MACOS[@]}; do
  HUBNAME=$DOCKER_ORG/$arch
  for tag in ${TAG_LI[@]}; do
    docker tag ghcr.io/cross-rs/$arch:local $HUBNAME:$tag
    docker push $HUBNAME:$tag
  done
done
