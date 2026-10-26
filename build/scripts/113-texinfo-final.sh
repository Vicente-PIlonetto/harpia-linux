#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Texinfo 7.3 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf texinfo-7.3
tar -xf "$(find . -maxdepth 1 -type f -name 'texinfo-7.3.tar.*' | head -n1)"
cd texinfo-7.3

./configure --prefix=/usr
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
make TEXMF=/usr/share/texmf install-tex

cd /sources
rm -rf texinfo-7.3
CHROOT

echo "Texinfo final concluído com sucesso."
