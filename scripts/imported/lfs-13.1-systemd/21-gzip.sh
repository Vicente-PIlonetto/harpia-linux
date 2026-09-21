#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Gzip..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf gzip-1.14
tar -xf gzip-1.14.tar.xz
cd gzip-1.14

./configure --prefix=/usr --host="$LFS_TGT"

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf gzip-1.14
'

echo "Gzip concluído com sucesso."

