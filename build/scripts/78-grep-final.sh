#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Grep 3.12 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf grep-3.12
tar -xf grep-3.12.tar.xz
cd grep-3.12
sed -i "s/echo/#echo/" src/egrep.sh
./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf grep-3.12
CHROOT
echo "Grep final concluído com sucesso."
