#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Zstd 1.5.7..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf zstd-1.5.7
tar -xf zstd-1.5.7.tar.gz
cd zstd-1.5.7

make prefix=/usr
[ "$HARP_RUN_TESTS" != "1" ] || make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a

cd /sources
rm -rf zstd-1.5.7
CHROOT

echo "Zstd concluído com sucesso."
