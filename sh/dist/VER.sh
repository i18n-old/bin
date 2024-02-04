#!/usr/bin/env bash

[ -z "${VER}" ] && export VER=$(cargo metadata --format-version=1 --no-deps | jq -r '.workspace_default_members[0]' | awk -F@ '{print $2}') || true
