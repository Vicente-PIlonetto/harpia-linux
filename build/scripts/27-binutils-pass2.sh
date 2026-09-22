#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Binutils Pass 2..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf binutils-2.47
tar -xf binutils-2.47.tar.xz
cd binutils-2.47

sed "6031s/\$add_dir//" -i ltmain.sh

mkdir -v build
cd build

../configure \
    --prefix=/usr \
    --build=$(../config.guess) \
    --host="$LFS_TGT" \
    --disable-nls \
    --enable-shared \
    --enable-gprofng=no \
    --disable-werror \
    --enable-64-bit-bfd \
    --enable-new-dtags \
    --enable-default-hash-style=gnu

make
make DESTDIR="$LFS" install

rm -v "$LFS/usr/lib/lib"{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd "$LFS/sources"
rm -rf binutils-2.47
'

echo "Binutils Pass 2 concluído com sucesso."
