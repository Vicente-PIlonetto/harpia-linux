#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Attr 2.6.0..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf attr-2.6.0
tar -xf attr-2.6.0.tar.gz
cd attr-2.6.0

./configure \
    --prefix=/usr \
    --disable-static \
    --sysconfdir=/etc \
    --docdir=/usr/share/doc/attr-2.6.0

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    make check
fi

make install

cd /sources
rm -rf attr-2.6.0
CHROOT

echo "Attr concluído com sucesso."
