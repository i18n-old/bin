#!/usr/bin/env bash

if ! command -v b3sum &>/dev/null; then
  case "$unameOut" in
  Darwin*) brew install b3sum ;;
  *) cargo install b3sum ;;
  esac
fi
