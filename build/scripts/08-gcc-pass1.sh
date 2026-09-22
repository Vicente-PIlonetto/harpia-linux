#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando GCC Pass 1..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf gcc-16.2.0
tar -xf gcc-16.2.0.tar.xz
cd gcc-16.2.0

tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr

tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp

tar -xf ../mpc-1.4.1.tar.xz
mv -v mpc-1.4.1 mpc

case $(uname -m) in
    x86_64)
        sed -e "/m64=/s/lib64/lib/" \
            -i.orig gcc/config/i386/t-linux64
    ;;
esac

mkdir -v build
cd build

../configure \
    --target="$LFS_TGT" \
    --prefix="$LFS/tools" \
    --with-glibc-version=2.44 \
    --with-sysroot="$LFS" \
    --with-newlib \
    --without-headers \
    --enable-default-pie \
    --enable-default-ssp \
    --disable-fixincludes \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++

make
make install

cat ../gcc/{limitx,glimits,limity}.h > \
    $("$LFS_TGT-gcc" -print-file-name=include)/limits.h

cd "$LFS/sources"
rm -rf gcc-16.2.0
'

echo "GCC Pass 1 concluído com sucesso."
