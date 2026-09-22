#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Pkgconf 3.0.5..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf pkgconf-3.0.5 meson-1.12.0
tar -xf pkgconf-3.0.5.tar.xz
cd pkgconf-3.0.5

tar -xf ../meson-1.12.0.tar.gz

mkdir -v build
cd build

python3 ../meson-1.12.0/meson.py setup \
    --prefix=/usr \
    --buildtype=release \
    ..

ninja

if [ "$HARP_RUN_TESTS" = "1" ]; then
    ninja test
fi

ninja install

mv /usr/share/doc/pkgconf{,-3.0.5}

ln -sv pkgconf /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

cd /sources
rm -rf pkgconf-3.0.5
CHROOT

echo "Pkgconf concluído com sucesso."
