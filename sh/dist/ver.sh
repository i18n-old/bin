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

echo $meta | jq -r '"wget -c "+.assets[].browser_download_url+"&"' | bash
wait

cd $DIST
set +x
# 不要暴露 s3 地址避免被盗刷
$DIR/rcp.sh $VER &
$DIR/rcp.sh _ &
set -x

wait

git checkout -b master
git add .
git commit -m$VER
git push -f --set-upstream origin master

cd ..

gh release delete-asset v v || gh release create v || true
gh release upload v v
