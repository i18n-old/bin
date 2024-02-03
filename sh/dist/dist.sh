#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
source conf/S3.sh
set -ex

export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new"

VER=$(gh release list -L1 | tail -1 | awk '{print $1}')

DIST=${DIR%/*/*}/dist
DIST_VER=$DIST/$VER
rm -rf $DIST
mkdir -p $DIST_VER
cd $DIST_VER
gh release download $VER

cd $DIST
mkdir -p _

direnv . exec $DIR/ver_vbyte.coffee _/v

gh release delete-asset _ v || gh release create _ --notes . || true
# 必须在 git init 之前 upload,不然会没法 release
gh release upload _ _/v
git init

cp -f $DIR/conf/git.config .git/config
git checkout -b main

# 不要暴露 s3 地址避免被盗刷
find . -mindepth 1 -maxdepth 1 \
  -exec basename {} \; | grep -v "^\." |
  xargs -P 4 -I {} $DIR/rcp.sh {}

git add .
git commit -m$VER
git push -f --set-upstream origin main
