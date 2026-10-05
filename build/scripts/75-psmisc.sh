#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Psmisc 23.7..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf psmisc-23.7
tar -xf "$(find . -maxdepth 1 -type f -name 'psmisc-23.7.tar.*' | head -n1)"
cd psmisc-23.7
./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf psmisc-23.7
CHROOT
echo "Psmisc concluído com sucesso."
