#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Binutils Pass 1..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf binutils-2.47
tar -xf binutils-2.47.tar.xz
cd binutils-2.47

mkdir -v build
cd build

../configure \
    --prefix="$LFS/tools" \
    --with-sysroot="$LFS" \
    --target="$LFS_TGT" \
    --disable-nls \
    --enable-gprofng=no \
    --disable-werror \
    --enable-new-dtags \
    --enable-default-hash-style=gnu

make
make install

cd "$LFS/sources"
rm -rf binutils-2.47
'

echo "Binutils Pass 1 concluído com sucesso."
