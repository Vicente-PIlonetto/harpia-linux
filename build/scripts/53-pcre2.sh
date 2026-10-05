#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Pcre2 10.47..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf pcre2-10.47
tar -xf pcre2-10.47.tar.bz2
cd pcre2-10.47

./configure --prefix=/usr \
            --docdir=/usr/share/doc/pcre2-10.47 \
            --enable-unicode \
            --enable-jit \
            --enable-pcre2-16 \
            --enable-pcre2-32 \
            --enable-pcre2grep-libz \
            --enable-pcre2grep-libbz2 \
            --enable-pcre2test-libreadline \
            --disable-static

make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install

cd /sources
rm -rf pcre2-10.47
CHROOT

echo "Pcre2 concluído com sucesso."
