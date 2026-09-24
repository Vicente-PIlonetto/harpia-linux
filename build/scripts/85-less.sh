#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Less 704..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf less-704
tar -xf "$(find . -maxdepth 1 -type f -name 'less-704.tar.*' | head -n1)"
cd less-704
./configure --prefix=/usr --sysconfdir=/etc
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf less-704
CHROOT
echo "Less concluído com sucesso."
