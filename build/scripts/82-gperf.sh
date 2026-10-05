#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Gperf 3.3..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gperf-3.3
tar -xf gperf-3.3.tar.gz
cd gperf-3.3
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
cd /sources
rm -rf gperf-3.3
CHROOT
echo "Gperf concluído com sucesso."
