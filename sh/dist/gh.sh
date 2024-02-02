#!/usr/bin/env bash

set -ex

for i in "$@"; do
  gh release upload $VER $i ||
    (
      (
        DIR=$(realpath $0) && DIR=${DIR%/*/*/*} &&
          gh release create $VER -F $DIR/log/$VER.md || true
      ) && gh release upload $VER $i
    )
done
