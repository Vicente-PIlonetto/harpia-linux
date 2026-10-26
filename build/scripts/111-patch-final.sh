#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Patch 2.8 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf patch-2.8
tar -xf "$(find . -maxdepth 1 -type f -name 'patch-2.8.tar.*' | head -n1)"
cd patch-2.8

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf patch-2.8
CHROOT

echo "Patch final concluído com sucesso."
