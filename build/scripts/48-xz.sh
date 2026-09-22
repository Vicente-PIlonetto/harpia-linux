#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Xz 5.8.3..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf xz-5.8.3
tar -xf xz-5.8.3.tar.xz
cd xz-5.8.3

./configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.3

make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf xz-5.8.3
CHROOT

echo "Xz concluído com sucesso."
