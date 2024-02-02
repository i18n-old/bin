#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

name=conf
tar=$name.tar.zstd

rm -rf $tar

ZSTD_CLEVEL=19 tar --zstd -cvpf $tar $name

echo $ENC_PASSWD | gpg --batch --yes --passphrase-fd 0 --output $tar.enc --symmetric --cipher-algo AES256 $tar
