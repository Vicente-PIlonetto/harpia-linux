#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Gawk..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf gawk-5.4.1
tar -xf gawk-5.4.1.tar.xz
cd gawk-5.4.1

sed -i "s/extras//" Makefile.in

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf gawk-5.4.1
'

echo "Gawk concluído com sucesso."

