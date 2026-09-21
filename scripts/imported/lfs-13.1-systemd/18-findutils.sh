#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Findutils..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf findutils-4.11.0
tar -xf findutils-4.11.0.tar.xz
cd findutils-4.11.0

./configure --prefix=/usr \
            --localstatedir=/var/lib/locate \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf findutils-4.11.0
'

echo "Findutils concluído com sucesso."

