#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source conf.sh

cp -f git.config ../.git/config

ver=$(cargo metadata --no-deps --format-version=1 | jq -r '.packages[0].version')
branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' | awk -F' ' '{print $2}')

cd /tmp
echo $ver >v
$DIR/rcp.sh v
cd $DIR
git branch -D v || true
git switch --orphan v
rm -rf *
echo $ver >v
git add .
git commit -m$ver
git push --set-upstream origin v -f
git checkout $branch
