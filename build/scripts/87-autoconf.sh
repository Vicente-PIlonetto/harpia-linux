#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Autoconf 2.73..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf autoconf-2.73
tar -xf "$(find . -maxdepth 1 -type f -name 'autoconf-2.73.tar.*' | head -n1)"
cd autoconf-2.73
./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf autoconf-2.73
CHROOT
echo "Autoconf concluído com sucesso."
