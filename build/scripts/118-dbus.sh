#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando D-Bus 1.16.2..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf dbus-1.16.2
tar -xf "$(find . -maxdepth 1 -type f -name 'dbus-1.16.2.tar.*' | head -n1)"
cd dbus-1.16.2

mkdir -p build
cd build

meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..
ninja
[ "$HARP_RUN_TESTS" != "1" ] || ninja test
ninja install

ln -sfv /etc/machine-id /var/lib/dbus

cd /sources
rm -rf dbus-1.16.2
CHROOT

echo "D-Bus concluído com sucesso."
