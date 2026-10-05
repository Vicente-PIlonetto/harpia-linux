#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando OpenSSL 4.0.1..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf openssl-4.0.1
tar -xf "$(find . -maxdepth 1 -type f -name 'openssl-4.0.1.tar.*' | head -n1)"
cd openssl-4.0.1
./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
make
[ "$HARP_RUN_TESTS" != "1" ] || HARNESS_JOBS="${HARP_JOBS:-1}" make test
make INSTALL_LIBS= MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-4.0.1
cp -vfr doc/* /usr/share/doc/openssl-4.0.1
cd /sources
rm -rf openssl-4.0.1
CHROOT
echo "OpenSSL concluído com sucesso."
