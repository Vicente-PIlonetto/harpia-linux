#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Make 4.4.1 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf make-4.4.1
tar -xf "$(find . -maxdepth 1 -type f -name 'make-4.4.1.tar.*' | head -n1)"
cd make-4.4.1

./configure --prefix=/usr
make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    chown -R tester .
    set +e
    su tester -c "PATH=$PATH make check" 2>&1 | tee /sources/make-4.4.1-check.log
    test_rc=${PIPESTATUS[0]}
    set -e
    chown -R root:root .

    if [ "$test_rc" -ne 0 ]; then
        echo "ERRO: testes do Make retornaram código $test_rc."
        echo "Log: /sources/make-4.4.1-check.log"
        exit "$test_rc"
    fi
fi

make install

cd /sources
rm -rf make-4.4.1
CHROOT

echo "Make final concluído com sucesso."
