#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Readline 8.3..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf readline-8.3
tar -xf readline-8.3.tar.gz
cd readline-8.3

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

sed -e '270a\
     else\
       chars_avail = 1;'      \
    -e '288i\   result = -1;' \
    -i.orig input.c

./configure --prefix=/usr \
            --disable-static \
            --with-curses \
            --docdir=/usr/share/doc/readline-8.3

make SHLIB_LIBS="-lncursesw"
make install

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3 || true

cd /sources
rm -rf readline-8.3
CHROOT

echo "Readline concluído com sucesso."
