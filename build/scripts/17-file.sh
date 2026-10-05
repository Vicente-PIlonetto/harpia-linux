#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando File..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf file-5.48
tar -xf file-5.48.tar.gz
cd file-5.48

mkdir -v build
pushd build
    ../configure --disable-bzlib \
                 --disable-libseccomp \
                 --disable-xzlib \
                 --disable-zlib
    make
popd

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR="$LFS" install

rm -v "$LFS/usr/lib/libmagic.la"

cd "$LFS/sources"
rm -rf file-5.48
'

echo "File concluído com sucesso."
