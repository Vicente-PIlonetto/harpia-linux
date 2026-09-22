#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Zlib 1.3.2..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf zlib-1.3.2
tar -xf zlib-1.3.2.tar.gz
cd zlib-1.3.2

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
rm -fv /usr/lib/libz.a

cd /sources
rm -rf zlib-1.3.2
CHROOT

echo "Zlib concluído com sucesso."
