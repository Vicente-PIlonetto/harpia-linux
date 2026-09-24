#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Libelf (Elfutils 0.195)..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf elfutils-0.195
tar -xf "$(find . -maxdepth 1 -type f -name 'elfutils-0.195.tar.*' | head -n1)"
cd elfutils-0.195
./configure --prefix=/usr --disable-debuginfod --enable-libdebuginfod=dummy
make -C lib
make -C libelf
[ "$HARP_RUN_TESTS" != "1" ] || make -k check
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm -f /usr/lib/libelf.a
cd /sources
rm -rf elfutils-0.195
CHROOT
echo "Libelf concluído com sucesso."
