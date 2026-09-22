#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Libxcrypt 4.5.2..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf libxcrypt-4.5.2
tar -xf libxcrypt-4.5.2.tar.xz
cd libxcrypt-4.5.2

sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

./configure \
    --prefix=/usr \
    --enable-hashes=strong,glibc \
    --enable-obsolete-api=no \
    --disable-static \
    --disable-failure-tokens

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    make check
fi

make install

cd /sources
rm -rf libxcrypt-4.5.2
CHROOT

echo "Libxcrypt concluído com sucesso."
