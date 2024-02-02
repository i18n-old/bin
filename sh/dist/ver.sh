#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new"

ver=$(curl -s "https://api.github.com/repos/i18n-site/bin/releases/latest" | jq -r '.tag_name')
branch=$(git symbolic-ref --short -q HEAD || echo main)

cp -f git.config ../.git/config

DIST=${DIR%/*/*}/dist

rm -rf $DIST
mkdir -p $DIST
cd $DIST

git init
cp -f $DIR/git.config .git/config

echo $ver >v
$DIR/rcp.sh $DIST/v

git add .
git commit -m$ver
git push origin main -f
