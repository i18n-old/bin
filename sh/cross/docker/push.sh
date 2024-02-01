#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

docker images
source target.sh

TAG_LI=($(date +"%Y%m%d") latest)

push() {
  target_li=$1
  for arch in ${target_li[@]}; do
    HUBNAME=$DOCKER_ORG/$arch
    for tag in ${TAG_LI[@]}; do
      docker tag ghcr.io/cross-rs/$arch:local $HUBNAME:$tag
      docker push $HUBNAME:$tag
    done
  done
}

push $CROSS_TARGET
