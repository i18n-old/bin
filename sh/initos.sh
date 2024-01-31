#!/usr/bin/env bash

set -ex
unameOut="$(uname -s)"

if ! command -v realpath &>/dev/null; then
  case "$unameOut" in
  # Linux*) machine=Linux ;;
  Darwin*) brew install coreutils ;;
  # CYGWIN*) machine=Cygwin ;;
  # MINGW*) machine=MinGw ;;
  # MSYS_NT*) machine=Git ;;
  # *) machine="UNKNOWN:${unameOut}" ;;
  esac
  # echo ${machine}

fi

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

if ! [ -f "$HOME/.config/rclone/rclone.conf" ]; then
  ./denc.sh
  if command -v rsync &>/dev/null; then
    rsync -av conf/ $HOME
  else
    cp -rT conf $HOME
  fi
fi
