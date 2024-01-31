#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

RED='\033[0;31m'
NC='\033[0m'

branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' | awk -F' ' '{print $2}')

beginhash=$(git log --format=%H -2 main | tail -1)

(git add . && git commit -m .) || true

git pull

if [ "$branch" != "main" ]; then
  git pull origin main
  git merge origin/main
fi

cargo build

hash=$(git log --format=%H -1)

cargo v patch -y

set +x
meta=$(cargo metadata --format-version=1 --no-deps)
ver=$(echo $meta | jq -r '.packages[0].version')
set -x

logmd=log/$ver.md

if ! [ -s $logmd ]; then
  echo -e "${RED}miss changelog : $logmd$NC"
  touch $logmd && git add $logmd
  git reset --hard $hash || true
  git checkout Cargo.toml
  exit 1
fi

git reset --soft $beginhash || true

echo $(($(cat .v) + 1)) >.v

git add . && git commit -mv$ver || true

if [ "$branch" != "main" ]; then
  git checkout main
  git merge $branch
fi

git tag -d v$ver
git tag v$ver
git pull
git push origin main
git push origin v$ver
if [ "$branch" != "main" ]; then
  git checkout $branch
  git pull
  git push
fi
