#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Diffutils 3.12 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf diffutils-3.12
tar -xf "$(find . -maxdepth 1 -type f -name 'diffutils-3.12.tar.*' | head -n1)"
cd diffutils-3.12

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf diffutils-3.12
CHROOT

echo "Diffutils final concluído com sucesso."
