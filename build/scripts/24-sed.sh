#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Sed..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf sed-4.10
tar -xf sed-4.10.tar.xz
cd sed-4.10

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(./build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf sed-4.10
'

echo "Sed concluído com sucesso."
