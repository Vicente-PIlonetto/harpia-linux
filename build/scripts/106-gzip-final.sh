#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Gzip 1.14 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gzip-1.14
tar -xf "$(find . -maxdepth 1 -type f -name 'gzip-1.14.tar.*' | head -n1)"
cd gzip-1.14

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf gzip-1.14
CHROOT

echo "Gzip final concluído com sucesso."
