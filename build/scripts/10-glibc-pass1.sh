#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando Glibc Pass 1..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf glibc-2.44
tar -xf glibc-2.44.tar.xz
cd glibc-2.44

case $(uname -m) in
    x86_64)
        ln -sfv ../lib/ld-linux-x86-64.so.2 "$LFS/lib64"
        ln -sfv ../lib/ld-linux-x86-64.so.2 "$LFS/lib64/ld-lsb-x86-64.so.3"
    ;;
esac

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure \
    --prefix=/usr \
    --host="$LFS_TGT" \
    --build=$(../scripts/config.guess) \
    --enable-kernel=5.4 \
    --with-headers="$LFS/usr/include" \
    libc_cv_slibdir=/usr/lib

make
make DESTDIR="$LFS" install

sed "/RTLDLIST=/s@/usr@@g" -i "$LFS/usr/bin/ldd"

cd "$LFS/sources"
rm -rf glibc-2.44
'

echo "Glibc Pass 1 concluído com sucesso."
