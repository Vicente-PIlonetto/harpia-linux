#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Groff 1.24.1..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf groff-1.24.1
tar -xf "$(find . -maxdepth 1 -type f -name 'groff-1.24.1.tar.*' | head -n1)"
cd groff-1.24.1

PAGE=A4 ./configure --prefix=/usr
make -j1

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do Groff..."
    echo "OBS: neqn-smoke-test.sh é conhecido por falhar."
    set +e
    make check 2>&1 | tee /sources/groff-1.24.1-check.log
    test_rc=${PIPESTATUS[0]}
    set -e

    if [ "$test_rc" -ne 0 ]; then
        echo
        echo "AVISO: a suíte do Groff retornou código $test_rc."
        echo "Confirme se a falha está limitada ao neqn-smoke-test.sh."
        echo "Log: /sources/groff-1.24.1-check.log"
    fi
fi

make install

cd /sources
rm -rf groff-1.24.1
CHROOT

echo "Groff concluído com sucesso."
