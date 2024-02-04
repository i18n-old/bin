#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

RED='\033[0;31m'
NC='\033[0m'

branch=$(git symbolic-ref --short -q HEAD || echo main)

beginhash=$(git log --format=%H -1 main)

(git add . && git commit -m .) || true

git pull

if [ "$branch" != "main" ]; then
  git fetch origin main
  git merge origin main -m "merge main" || true
fi

cargo build

hash=$(git log --format=%H -1)

if ! command -v cargo-v &>/dev/null; then
  cargo install cargo-v
fi

cargo v patch -y
. sh/dist/VER.sh

logmd=log/$VER.md

if ! [ -s $logmd ]; then
  echo -e "${RED}miss changelog : $logmd$NC"
  touch $logmd && git add $logmd
  git reset --hard $hash || true
  git checkout Cargo.toml
  exit 1
fi

git reset --soft $beginhash || true

git add . && git commit -mv$VER || true

if [ "$branch" != "main" ]; then
  git push origin $branch -f
  git checkout main
  git merge $branch
fi

git tag -d v$VER
git tag v$VER
git push origin main &
git push origin v$VER &
wait

if [ "$branch" != "main" ]; then
  git checkout $branch
  git reset --hard $(git log --format=%H -1 main)
  git add .
  git commit -m $VER || true
  git push -f
fi
