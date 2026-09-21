#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Diffutils..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf diffutils-3.12
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            gl_cv_func_strcasecmp_works=yes \
            --build=$(./build-aux/config.guess)

make
make DESTDIR="$LFS" install

cd "$LFS/sources"
rm -rf diffutils-3.12
'

echo "Diffutils concluído com sucesso."

