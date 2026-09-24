#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Bison 3.8.2 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf bison-3.8.2
tar -xf bison-3.8.2.tar.xz
cd bison-3.8.2
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf bison-3.8.2
CHROOT
echo "Bison final concluído com sucesso."
