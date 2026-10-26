#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando IPRoute2 7.1.0..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf iproute2-7.1.0
tar -xf "$(find . -maxdepth 1 -type f -name 'iproute2-7.1.0.tar.*' | head -n1)"
cd iproute2-7.1.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install

install -vDm644 COPYING README* -t /usr/share/doc/iproute2-7.1.0

cd /sources
rm -rf iproute2-7.1.0
CHROOT

echo "IPRoute2 concluído com sucesso."
