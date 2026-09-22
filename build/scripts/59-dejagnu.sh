#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando DejaGNU 1.6.3..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf dejagnu-1.6.3
tar -xf dejagnu-1.6.3.tar.gz
cd dejagnu-1.6.3

mkdir -v build
cd build

../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi

[ "$HARP_RUN_TESTS" != "1" ] || make check

make install
install -v -dm755 /usr/share/doc/dejagnu-1.6.3
install -v -m644 doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

cd /sources
rm -rf dejagnu-1.6.3
CHROOT

echo "DejaGNU concluído com sucesso."
