#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Sed 4.10 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf sed-4.10
tar -xf sed-4.10.tar.xz
cd sed-4.10
./configure --prefix=/usr
make
make html
if [ "$HARP_RUN_TESTS" = "1" ]; then
    chown -R tester .
    su tester -c "PATH=$PATH make check"
    chown -R root:root .
fi
make install
install -vDm644 doc/sed.html -t /usr/share/doc/sed-4.10
cd /sources
rm -rf sed-4.10
CHROOT
echo "Sed final concluído com sucesso."
