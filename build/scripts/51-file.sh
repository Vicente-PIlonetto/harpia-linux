#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando File 5.48..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf file-5.48
tar -xf file-5.48.tar.gz
cd file-5.48

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf file-5.48
CHROOT

echo "File concluído com sucesso."
