#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source conf.sh

ver=$(echo $meta | jq -r '.packages[0].version')

$DIR/rcp.sh $ver
