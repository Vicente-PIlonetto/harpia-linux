#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Procps-ng 4.0.7..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf procps-ng-4.0.7
tar -xf "$(find . -maxdepth 1 -type f -name 'procps-ng-4.0.7.tar.*' | head -n1)"
cd procps-ng-4.0.7

./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.7 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit                      \
            --with-systemd

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    chown -R tester .
    set +e
    su tester -c "PATH=$PATH make check" 2>&1 | tee /sources/procps-ng-4.0.7-check.log
    test_rc=${PIPESTATUS[0]}
    set -e
    chown -R root:root .

    if [ "$test_rc" -ne 0 ]; then
        echo "AVISO: testes do Procps-ng retornaram código $test_rc."
        echo "O teste de bsdtime/cputime/etime/etimes pode falhar sem CONFIG_BSD_PROCESS_ACCT."
        echo "Log: /sources/procps-ng-4.0.7-check.log"
    fi
fi

make install

cd /sources
rm -rf procps-ng-4.0.7
CHROOT

echo "Procps-ng concluído com sucesso."
