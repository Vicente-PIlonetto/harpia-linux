#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Libffi 3.8.0..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf libffi-3.8.0
tar -xf "$(find . -maxdepth 1 -type f -name 'libffi-3.8.0.tar.*' | head -n1)"
cd libffi-3.8.0
./configure --prefix=/usr --disable-static --with-gcc-arch=native
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf libffi-3.8.0
CHROOT
echo "Libffi concluído com sucesso."
