#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Tar 1.35 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf tar-1.35
tar -xf "$(find . -maxdepth 1 -type f -name 'tar-1.35.tar.*' | head -n1)"
cd tar-1.35

patch -Np1 -i ../tar-1.35-acl_fix-1.patch

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

cd /sources
rm -rf tar-1.35
CHROOT

echo "Tar final concluído com sucesso."
