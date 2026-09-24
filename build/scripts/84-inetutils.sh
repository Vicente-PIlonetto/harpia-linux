#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Inetutils 2.8..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf inetutils-2.8
tar -xf "$(find . -maxdepth 1 -type f -name 'inetutils-2.8.tar.*' | head -n1)"
cd inetutils-2.8
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c
./configure --prefix=/usr \
            --bindir=/usr/bin \
            --localstatedir=/var \
            --disable-logger \
            --disable-whois \
            --disable-rcp \
            --disable-rexec \
            --disable-rlogin \
            --disable-rsh \
            --disable-servers
make
[ "$HARP_RUN_TESTS" != "1" ] || make check
make install
mv -v /usr/{,s}bin/ifconfig
cd /sources
rm -rf inetutils-2.8
CHROOT
echo "Inetutils concluído com sucesso."
