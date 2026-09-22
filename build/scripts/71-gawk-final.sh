#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Gawk 5.4.1 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gawk-5.4.1
tar -xf gawk-5.4.1.tar.xz
cd gawk-5.4.1

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    chown -R tester .
    su tester -c "PATH=$PATH make check"
    chown -R root:root .
fi

rm -f /usr/bin/gawk-5.4.1
make install

ln -sv gawk.1 /usr/share/man/man1/awk.1

install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} \
    -t /usr/share/doc/gawk-5.4.1 || true

cd /sources
rm -rf gawk-5.4.1
CHROOT

echo "Gawk final concluído com sucesso."
