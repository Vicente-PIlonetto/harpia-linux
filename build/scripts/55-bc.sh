#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Bc 7.0.3..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf bc-7.0.3
tar -xf bc-7.0.3.tar.xz
cd bc-7.0.3

CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r
make
[ "$HARP_RUN_TESTS" != "1" ] || make test
make install

cd /sources
rm -rf bc-7.0.3
CHROOT

echo "Bc concluído com sucesso."
