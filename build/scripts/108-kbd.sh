#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Kbd 2.10.0..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf kbd-2.10.0
tar -xf "$(find . -maxdepth 1 -type f -name 'kbd-2.10.0.tar.*' | head -n1)"
cd kbd-2.10.0

patch -Np1 -i ../kbd-2.10.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cp -R -v docs/doc -T /usr/share/doc/kbd-2.10.0

cd /sources
rm -rf kbd-2.10.0
CHROOT

echo "Kbd concluído com sucesso."
