#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Packaging 26.3..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf packaging-26.3
tar -xf "$(find . -maxdepth 1 -type f -name 'packaging-26.3.tar.*' | head -n1)"
cd packaging-26.3
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist packaging
cd /sources
rm -rf packaging-26.3
CHROOT
echo "Packaging concluído com sucesso."
