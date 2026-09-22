#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Ncurses..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf ncurses-6.6
tar -xf ncurses-6.6.tar.gz
cd ncurses-6.6

sed -i s/mawk// configure

mkdir -v build
pushd build
    ../configure
    make -C include
    make -C progs tic
popd

./configure \
    --prefix=/usr \
    --host="$LFS_TGT" \
    --build=$(./config.guess) \
    --mandir=/usr/share/man \
    --with-manpage-format=normal \
    --with-shared \
    --without-normal \
    --with-cxx-shared \
    --without-debug \
    --without-ada \
    --disable-stripping \
    --enable-widec

make

make DESTDIR="$LFS" TIC_PATH="$(pwd)/build/progs/tic" install

ln -sv libncursesw.so "$LFS/usr/lib/libncurses.so"

sed -e "s/^#if.*XOPEN.*$/#if 1/" \
    -i "$LFS/usr/include/curses.h"

cd "$LFS/sources"
rm -rf ncurses-6.6
'

echo "Ncurses concluído com sucesso."
