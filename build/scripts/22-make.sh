#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Make..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf make-4.4.1
tar -xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf make-4.4.1
'

echo "Make concluído com sucesso."
