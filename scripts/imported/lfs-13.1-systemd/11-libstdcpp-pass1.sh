#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Libstdc++ Pass 1..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf gcc-16.2.0
tar -xf gcc-16.2.0.tar.xz
cd gcc-16.2.0

mkdir -v build
cd build

../libstdc++-v3/configure \
    --host="$LFS_TGT" \
    --build=$(../config.guess) \
    --prefix=/usr \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/16.2.0

make

make DESTDIR="$LFS" install

rm -v "$LFS/usr/lib/lib"{stdc++{,exp,fs},supc++}.la

cd "$LFS/sources"
rm -rf gcc-16.2.0
'

echo "Libstdc++ Pass 1 concluído com sucesso."

