#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Acl 2.4.0..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf acl-2.4.0
tar -xf acl-2.4.0.tar.xz
cd acl-2.4.0

./configure \
    --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/acl-2.4.0

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do Acl..."
    echo "OBS: test/cp.run é uma falha conhecida nesta etapa do LFS."
    set +e
    make check 2>&1 | tee /sources/acl-2.4.0-check.log
    set -e
fi

make install

cd /sources
rm -rf acl-2.4.0
CHROOT

echo "Acl concluído com sucesso."
