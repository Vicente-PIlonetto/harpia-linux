#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Libtool 2.6.2..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf libtool-2.6.2
tar -xf libtool-2.6.2.tar.xz
cd libtool-2.6.2
./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
rm -fv /usr/lib/libltdl.a
cd /sources
rm -rf libtool-2.6.2
CHROOT
echo "Libtool concluído com sucesso."
