#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Patch..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf patch-2.8
tar -xf patch-2.8.tar.xz
cd patch-2.8

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf patch-2.8
'

echo "Patch concluído com sucesso."

