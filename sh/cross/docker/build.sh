#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source target.sh

cd /tmp
rm -rf cross
git clone --depth=1 https://github.com/cross-rs/cross
cd cross
git submodule update --init --remote

for target in ${CROSS_TARGET[@]}; do
  cargo build-docker-image $target-cross --build-arg "MACOS_SDK_URL=$MACOS_SDK" --tag local || true
done

# MACOS_SDK=$(curl -sSL https://api.github.com/repos/alexey-lysiuk/macos-sdk/releases | jq ".[1].assets[0].browser_download_url" -r)
#
# for target in ${TARGET_MACOS[@]}; do
#   cargo build-docker-image $target --build-arg "MACOS_SDK_URL=$MACOS_SDK" --tag local || true
# done
