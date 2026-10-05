#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Grep..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf grep-3.12
tar -xf grep-3.12.tar.xz
cd grep-3.12

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(./build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf grep-3.12
'

echo "Grep concluído com sucesso."
