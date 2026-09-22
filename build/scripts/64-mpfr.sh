#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando MPFR 4.2.2..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf mpfr-4.2.2
tar -xf mpfr-4.2.2.tar.xz
cd mpfr-4.2.2

./configure \
    --prefix=/usr \
    --disable-static \
    --enable-thread-safe \
    --docdir=/usr/share/doc/mpfr-4.2.2

make
make html

if [ "$HARP_RUN_TESTS" = "1" ]; then
    make check
fi

make install
make install-html

cd /sources
rm -rf mpfr-4.2.2
CHROOT

echo "MPFR concluído com sucesso."
