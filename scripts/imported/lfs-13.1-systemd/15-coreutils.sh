#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Coreutils..."

sudo -u lfs bash -c '
set -e
source /home/lfs/.bashrc
cd "$LFS/sources"

rm -rf coreutils-9.11
tar -xf coreutils-9.11.tar.xz
cd coreutils-9.11

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname

make
make DESTDIR="$LFS" install

mv -v "$LFS/usr/bin/chroot" "$LFS/usr/sbin"
mkdir -pv "$LFS/usr/share/man/man8"
mv -v "$LFS/usr/share/man/man1/chroot.1" "$LFS/usr/share/man/man8/chroot.8"
sed -i "s/\"1\"/\"8\"/" "$LFS/usr/share/man/man8/chroot.8"

cd "$LFS/sources"
rm -rf coreutils-9.11
'

echo "Coreutils concluído com sucesso."

