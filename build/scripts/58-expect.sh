#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Expect 5.45.4..."

run_chroot <<'CHROOT'
set -e

python3 -c 'from pty import spawn; spawn(["echo", "ok"])'

cd /sources
rm -rf expect5.45.4
tar -xf expect5.45.4.tar.gz
cd expect5.45.4

patch -Np1 -i ../expect-5.45.4-gcc15-1.patch

./configure --prefix=/usr \
            --with-tcl=/usr/lib \
            --enable-shared \
            --disable-rpath \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make
[ "$HARP_RUN_TESTS" != "1" ] || make test
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

cd /sources
rm -rf expect5.45.4
CHROOT

echo "Expect concluído com sucesso."
