#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Xz..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf xz-5.8.3
tar -xf xz-5.8.3.tar.xz
cd xz-5.8.3

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess) \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.3

make
make DESTDIR="$LFS" install

rm -v "$LFS/usr/lib/liblzma.la"

cd "$LFS/sources"
rm -rf xz-5.8.3
'

echo "Xz concluído com sucesso."
