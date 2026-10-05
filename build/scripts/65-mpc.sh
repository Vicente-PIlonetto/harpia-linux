#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando MPC 1.4.1..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf mpc-1.4.1
tar -xf mpc-1.4.1.tar.xz
cd mpc-1.4.1

./configure \
    --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/mpc-1.4.1

make
make html

if [ "$HARP_RUN_TESTS" = "1" ]; then
    make check
fi

make install
make install-html

cd /sources
rm -rf mpc-1.4.1
CHROOT

echo "MPC concluído com sucesso."
