#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando M4 1.4.21 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf m4-1.4.21
tar -xf m4-1.4.21.tar.xz
cd m4-1.4.21

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf m4-1.4.21
CHROOT

echo "M4 final concluído com sucesso."
