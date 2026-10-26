#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Findutils 4.11.0 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf findutils-4.11.0
tar -xf "$(find . -maxdepth 1 -type f -name 'findutils-4.11.0.tar.*' | head -n1)"
cd findutils-4.11.0

./configure --prefix=/usr --localstatedir=/var/lib/locate
make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do Findutils..."
    echo "OBS: test-regex-el é conhecido por falhar nesta versão."
    chown -R tester .

    set +e
    su tester -c "PATH=$PATH make check -k" \
        2>&1 | tee /sources/findutils-4.11.0-check.log
    test_rc=${PIPESTATUS[0]}
    set -e

    chown -R root:root .

    if [ "$test_rc" -ne 0 ]; then
        echo
        echo "AVISO: a suíte do Findutils retornou código $test_rc."
        echo "Verifique se a falha está limitada ao teste conhecido test-regex-el."
        echo "Log: /sources/findutils-4.11.0-check.log"
    fi
fi

make install

cd /sources
rm -rf findutils-4.11.0
CHROOT

echo "Findutils final concluído com sucesso."
