#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

name=conf
tar=$name.tar.zstd

echo $ENC_PASSWD | gpg --batch --yes --passphrase-fd 0 --output $tar --decrypt $tar.enc
tar --zstd -xvf $tar
