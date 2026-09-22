#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Flex 2.6.4..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf flex-2.6.4
tar -xf flex-2.6.4.tar.gz
cd flex-2.6.4

./configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/flex-2.6.4

make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

ln -sv flex /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

cd /sources
rm -rf flex-2.6.4
CHROOT

echo "Flex concluído com sucesso."
