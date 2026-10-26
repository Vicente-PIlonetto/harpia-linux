#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Util-linux 2.42.2 final..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf util-linux-2.42.2
tar -xf "$(find . -maxdepth 1 -type f -name 'util-linux-2.42.2.tar.*' | head -n1)"
cd util-linux-2.42.2

./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.42.2

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Testes do Util-linux adiados até o primeiro boot."
    echo "A suíte completa não é segura/recomendada dentro deste chroot."
fi

make install

cd /sources
rm -rf util-linux-2.42.2
CHROOT

echo "Util-linux final concluído com sucesso."
