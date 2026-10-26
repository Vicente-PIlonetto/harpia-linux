#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Libpipeline 1.5.8..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf libpipeline-1.5.8
tar -xf "$(find . -maxdepth 1 -type f -name 'libpipeline-1.5.8.tar.*' | head -n1)"
cd libpipeline-1.5.8

./configure --prefix=/usr
make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Testes do Libpipeline não serão executados: requerem a biblioteca Check."
fi

make install

cd /sources
rm -rf libpipeline-1.5.8
CHROOT

echo "Libpipeline concluído com sucesso."
