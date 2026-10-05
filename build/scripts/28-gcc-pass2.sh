#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Iniciando GCC Pass 2..."

sudo -u lfs bash -c '
set -e
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

unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

../configure \
    --build=$(../config.guess) \
    --host="$LFS_TGT" \
    --target="$LFS_TGT" \
    --prefix=/usr \
    --with-build-sysroot="$LFS" \
    --enable-default-pie \
    --enable-default-ssp \
    --disable-fixincludes \
    --disable-nls \
    --disable-multilib \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libvtv \
    --enable-languages=c,c++ \
    CXX_FOR_TARGET="$LFS_TGT-gcc -nostdinc++" \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc \
    target_configargs=gcc_cv_target_thread_file=posix

make
make DESTDIR="$LFS" install

ln -sfv gcc "$LFS/usr/bin/cc"

cd "$LFS/sources"
rm -rf gcc-16.2.0
'

echo "GCC Pass 2 concluído com sucesso."
