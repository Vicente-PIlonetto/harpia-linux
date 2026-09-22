#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Man-pages 6.18..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf man-pages-6.18
tar -xf man-pages-6.18.tar.xz
cd man-pages-6.18

rm -v man3/crypt*
make -R GIT=false prefix=/usr install

cd /sources
rm -rf man-pages-6.18
CHROOT

echo "Man-pages concluído com sucesso."
