#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Automake 1.18.1..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf automake-1.18.1
tar -xf "$(find . -maxdepth 1 -type f -name 'automake-1.18.1.tar.*' | head -n1)"
cd automake-1.18.1
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1
make
if [ "$HARP_RUN_TESTS" = "1" ]; then
    jobs="${HARP_JOBS:-4}"
    [ "$jobs" -ge 4 ] || jobs=4
    make -j"$jobs" check
fi
make install
cd /sources
rm -rf automake-1.18.1
CHROOT
echo "Automake concluído com sucesso."
