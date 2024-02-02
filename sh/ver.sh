#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new"

ver=$(cargo metadata --no-deps --format-version=1 | jq -r '.packages[0].version')
branch=$(git symbolic-ref --short -q HEAD || echo main)

cp -f git.config ../.git/config

cd /tmp
echo $ver >v
$DIR/rcp.sh v

cd $(dirname $DIR)

rm -rf dist
mkdir -p dist
cd dist
git init
cp -f $DIR/dist/git.config .git/config

# git branch -D v || true
# git switch --orphan v
# rm -rf *
# echo $ver >v
# git add .
# git commit -m$ver
# git push --set-upstream origin v -f
# git checkout $branch
