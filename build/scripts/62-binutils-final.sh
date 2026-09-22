#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Binutils 2.47 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf binutils-2.47
tar -xf binutils-2.47.tar.xz
cd binutils-2.47

mkdir -v build
cd build

../configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --enable-ld=default \
    --enable-plugins \
    --enable-shared \
    --disable-werror \
    --enable-64-bit-bfd \
    --enable-new-dtags \
    --with-system-zlib \
    --with-lib-path=/usr/lib \
    --enable-default-hash-style=gnu

make tooldir=/usr

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes críticos do Binutils..."
    set +e
    make -k check 2>&1 | tee /sources/binutils-2.47-check.log
    rc=${PIPESTATUS[0]}
    set -e

    echo "Resumo de FAILs:"
    grep '^FAIL:' $(find -name '*.log') || true

    if [ "$rc" -ne 0 ]; then
        echo
        echo "AVISO: Binutils reportou falhas na suíte."
        echo "Uma falha relacionada a gprofng é conhecida no LFS 13.1."
        echo "Revise /sources/binutils-2.47-check.log antes de prosseguir."
    fi
fi

make tooldir=/usr install

rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/

cd /sources
rm -rf binutils-2.47
CHROOT

echo "Binutils final concluído."
