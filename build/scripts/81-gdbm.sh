#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando GDBM 1.26..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gdbm-1.26
tar -xf gdbm-1.26.tar.gz
cd gdbm-1.26
./configure --prefix=/usr --disable-static --enable-libgdbm-compat
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf gdbm-1.26
CHROOT
echo "GDBM concluído com sucesso."
