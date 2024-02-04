#!/usr/bin/env bash

set -ex

cd /tmp

exe=b3s

down=https://github.com/i18n-site/rust/releases/download

if ! command -v $exe &>/dev/null; then
  target=$(rustc -vV | grep "host:" | awk '{print $2}')
  ver=$(curl -fsSL $down/$exe/v)
  file=$ver.$target
  txz=$file.tar.xz
  wget -c $down/$exe.$ver/$txz
  tar xvf $txz
  cd $file
  mv $exe /usr/local/bin
fi
