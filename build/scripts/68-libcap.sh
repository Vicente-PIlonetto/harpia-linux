#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Libcap 2.78..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf libcap-2.78
tar -xf libcap-2.78.tar.xz
cd libcap-2.78

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib

if [ "$HARP_RUN_TESTS" = "1" ]; then
    make test
fi

make prefix=/usr lib=lib install

cd /sources
rm -rf libcap-2.78
CHROOT

echo "Libcap concluído com sucesso."
