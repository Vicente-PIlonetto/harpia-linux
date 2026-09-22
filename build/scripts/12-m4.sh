#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando M4..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf m4-1.4.21
tar -xf m4-1.4.21.tar.xz
cd m4-1.4.21

./configure \
    --prefix=/usr \
    --host="$LFS_TGT" \
    --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf m4-1.4.21
'

echo "M4 concluído com sucesso."
