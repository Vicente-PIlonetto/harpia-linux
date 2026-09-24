#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Gettext 1.0 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gettext-1.0
tar -xf gettext-1.0.tar.xz
cd gettext-1.0
./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/gettext-1.0
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
cd /sources
rm -rf gettext-1.0
CHROOT
echo "Gettext final concluído com sucesso."
