#!/usr/bin/env bash

set -ex

for i in "$@"; do
  gh release upload $ver $i ||
    (
      (
        DIR=$(realpath $0) && DIR=${DIR%/*/*/*} &&
          gh release create $ver -F $DIR/log/$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version').md || true
      ) && gh release upload $ver $i
    )
done
