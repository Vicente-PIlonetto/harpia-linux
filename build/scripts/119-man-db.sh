#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Man-DB 2.13.1..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf man-db-2.13.1
tar -xf "$(find . -maxdepth 1 -type f -name 'man-db-2.13.1.tar.*' | head -n1)"
cd man-db-2.13.1

./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap

make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf man-db-2.13.1
CHROOT

echo "Man-DB concluído com sucesso."
