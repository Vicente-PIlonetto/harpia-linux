#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Tar..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf tar-1.35
tar -xf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf tar-1.35
'

echo "Tar concluído com sucesso."
