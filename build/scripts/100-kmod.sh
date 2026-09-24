#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Kmod 34.2..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf kmod-34.2
tar -xf "$(find . -maxdepth 1 -type f -name 'kmod-34.2.tar.*' | head -n1)"
cd kmod-34.2
mkdir -p build
cd build
meson setup --prefix=/usr .. --buildtype=release -D manpages=false
ninja
ninja install
cd /sources
rm -rf kmod-34.2
CHROOT
echo "Kmod concluído com sucesso."
