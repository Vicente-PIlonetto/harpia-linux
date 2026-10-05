#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando GMP 6.3.0..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gmp-6.3.0
tar -xf gmp-6.3.0.tar.xz
cd gmp-6.3.0

sed -i '/long long t1;/,+1s/()/(...)/' configure

./configure \
    --prefix=/usr \
    --enable-cxx \
    --disable-static \
    --docdir=/usr/share/doc/gmp-6.3.0

make
make html

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes críticos do GMP..."
    make check | tee /sources/gmp-6.3.0-check.log

    pass_count="$(cat $(find -name '*.log') | grep -c '^PASS' || true)"
    echo "Testes GMP marcados como PASS: $pass_count"

    if [ "$pass_count" -lt 199 ]; then
        echo "ERRO: menos de 199 testes GMP passaram."
        echo "Revise /sources/gmp-6.3.0-check.log"
        exit 1
    fi
fi

make install
make install-html

cd /sources
rm -rf gmp-6.3.0
CHROOT

echo "GMP concluído com sucesso."
