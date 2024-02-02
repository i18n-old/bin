#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
source conf/S3.sh
set -ex

export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new"

github_org_user() {
  local url=$1
  if [[ $url == *"https://"* ]]; then
    echo $(echo $url | awk -F"/" '{uo=$4"/"$5;print uo}')
  else
    echo $(echo $url | sed -r 's#git@github\.com:(.*)\.git#\1#')
  fi
}

ghou=$(github_org_user $(git remote -v | awk '{print $2}' | grep github.com))

meta=$(curl -s "https://api.github.com/repos/$ghou/releases/latest")

VER=$(echo $meta | jq -r '.tag_name' | cut -d'v' -f2-)

DIST=${DIR%/*/*}/dist
DIST_VER=$DIST/$VER
rm -rf $DIST
mkdir -p $DIST_VER
cd $DIST

git init

cp -f $DIR/conf/git.config .git/config

mkdir -p _
echo $VER >_/v
cd $VER

echo $meta | jq -r '"wget --retry-connrefused --waitretry=9 --read-timeout=30 --timeout=15 -t 999 -c "+.assets[].browser_download_url+"&"' | bash
wait

cd $DIST
set +x
# 不要暴露 s3 地址避免被盗刷
find . -mindepth 1 -maxdepth 1 -exec basename {} \; | grep -v "^\." | xargs -P 4 -I {} ./rcp.sh {}
set -x

wait

git checkout -b main
git add .
git commit -m$VER
git push -f --set-upstream origin main

cd ..

gh release delete-asset _ v || gh release create _ || true
gh release upload _ v
