#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Setuptools 84.0.0..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf setuptools-84.0.0
tar -xf "$(find . -maxdepth 1 -type f -name 'setuptools-84.0.0.tar.*' | head -n1)"
cd setuptools-84.0.0
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist setuptools
cd /sources
rm -rf setuptools-84.0.0
CHROOT
echo "Setuptools concluído com sucesso."
