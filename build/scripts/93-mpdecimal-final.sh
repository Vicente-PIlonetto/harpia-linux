#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando mpdecimal 4.0.1 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf mpdecimal-4.0.1
tar -xf "$(find . -maxdepth 1 -type f -name 'mpdecimal-4.0.1.tar.*' | head -n1)"
cd mpdecimal-4.0.1
./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpdecimal-4.0.1
make
[ "$HARP_RUN_TESTS" != "1" ] || make check_local
make install
cd /sources
rm -rf mpdecimal-4.0.1
CHROOT
echo "mpdecimal final concluído com sucesso."
