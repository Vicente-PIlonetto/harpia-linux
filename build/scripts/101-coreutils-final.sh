#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Coreutils 9.11 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf coreutils-9.11
tar -xf "$(find . -maxdepth 1 -type f -name 'coreutils-9.11.tar.*' | head -n1)"
cd coreutils-9.11

patch -Np1 -i ../coreutils-9.11-i18n-1.patch
autoreconf -fv
automake -af

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr
make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do Coreutils..."
    make NON_ROOT_USERNAME=tester check-root

    groupdel dummy 2>/dev/null || true
    groupadd -g 102 dummy -U tester
    chown -R tester .

    set +e
    su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" \
        < /dev/null 2>&1 | tee /sources/coreutils-9.11-check.log
    test_rc=${PIPESTATUS[0]}
    set -e

    chown -R root:root .
    groupdel dummy 2>/dev/null || true

    if [ "$test_rc" -ne 0 ]; then
        echo
        echo "ERRO: testes do Coreutils retornaram código $test_rc."
        echo "Log: /sources/coreutils-9.11-check.log"
        exit "$test_rc"
    fi
fi

make install

mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

cd /sources
rm -rf coreutils-9.11
CHROOT

echo "Coreutils final concluído com sucesso."
