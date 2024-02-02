#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
ROOT=${DIR%/*}
cd $DIR
set -ex

source RUSTFLAGS.sh

build="build" # -Z unstable-options

unameOut="$(uname -s)"
case "${unameOut}" in
MINGW*)
  choco install activeperl nasm &
  TARGET_LI=$(rustc -vV | awk '/host/ { print $2 }')
  ;;
Linux)
  build="zigbuild"
  if ! command -v cargo-zigbuild &>/dev/null; then
    cargo install cargo-zigbuild
  fi
  TARGET_LI=$(rustup target list | awk '{print $1}' | grep "\-linux-" | grep -E "x86|aarch64" | grep -E "[musl|gun]$" | grep -v "i686-unknown-linux-musl")
  ;;
Darwin)
  TARGET_LI=$(rustc -vV | awk '/host/ { print $2 }')
  ;;
esac

. $DIR/dist/VER.sh

for target in ${TARGET_LI[@]}; do
  ./cross/target.sh $target &
done

wait

# if [ "$unameOut" == "Linux" ]; then
# docker pull i18nsite/x86_64-pc-windows-msvc-cross &
# docker pull i18nsite/aarch64-pc-windows-msvc-cross &
# fi

build="cargo $build -Z build-std=std,panic_abort --release --target"

echo $TARGET_LI | xargs -n1 -P$(nproc) $build

if [[ "$unameOut" == MINGW* ]]; then
  wait
  target=aarch64-pc-windows-msvc
  TARGET_LI="$TARGET_LI $target"
  # Get Visual Studio installation directory
  VSINSTALLDIR=$(vswhere.exe -latest -requires Microsoft.VisualStudio.Component.VC.Llvm.Clang -property installationPath)
  VCINSTALLDIR=$VSINSTALLDIR/VC
  LLVM_ROOT=$VCINSTALLDIR/Tools/Llvm/x64
  export PATH=$PATH:/usr/local/bin/nasm:$LLVM_ROOT/bin
  ./cross/target.sh $target
  $build $target
fi

for target in ${TARGET_LI[@]}; do
  $DIR/cross/mv.sh $VER $target
done
