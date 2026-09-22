#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Lz4 1.10.0..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf lz4-1.10.0
tar -xf lz4-1.10.0.tar.gz
cd lz4-1.10.0

make BUILD_STATIC=no PREFIX=/usr
[ "$HARP_RUN_TESTS" != "1" ] || make -j1 check
make BUILD_STATIC=no PREFIX=/usr install

cd /sources
rm -rf lz4-1.10.0
CHROOT

echo "Lz4 concluído com sucesso."
