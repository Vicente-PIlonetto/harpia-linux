#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Bash 5.3 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf bash-5.3
tar -xf bash-5.3.tar.gz
cd bash-5.3
./configure --prefix=/usr \
            --without-bash-malloc \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3
make
if [ "$HARP_RUN_TESTS" = "1" ]; then
    chown -R tester .
    LC_ALL=C.UTF-8 su -s /usr/bin/expect tester <<'EXPECT'
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EXPECT
    chown -R root:root .
fi
make install
cd /sources
rm -rf bash-5.3
CHROOT
echo "Bash final concluído com sucesso."
