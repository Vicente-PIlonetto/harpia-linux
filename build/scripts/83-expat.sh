#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Expat 2.8.3..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf expat-2.8.3
tar -xf "$(find . -maxdepth 1 -type f -name 'expat-2.8.3.tar.*' | head -n1)"
cd expat-2.8.3
./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/expat-2.8.3
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.8.3 2>/dev/null || true
cd /sources
rm -rf expat-2.8.3
CHROOT
echo "Expat concluído com sucesso."
