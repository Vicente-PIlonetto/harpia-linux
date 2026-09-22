#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Bash..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf bash-5.3
tar -xf bash-5.3.tar.gz
cd bash-5.3

./configure --prefix=/usr \
            --build=$(sh support/config.guess) \
            --host="$LFS_TGT" \
            --without-bash-malloc \
            --docdir=/usr/share/doc/bash-5.3

make
make DESTDIR="$LFS" install

ln -sfv bash "$LFS/bin/sh"

cd "$LFS/sources"
rm -rf bash-5.3
'

echo "Bash concluído com sucesso."
