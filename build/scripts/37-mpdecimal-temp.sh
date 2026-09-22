#!/bin/bash
set -e
source "$HOME/lfs-build/config.sh"


run_chroot() {
    sudo chroot "$LFS" /usr/bin/env -i \
        HOME=/root \
        TERM="${TERM:-xterm}" \
        PS1='(lfs chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin \
        MAKEFLAGS="-j$(nproc)" \
        TESTSUITEFLAGS="-j$(nproc)" \
        /bin/bash --login -c "$1"
}

echo "Iniciando mpdecimal temporário..."

run_chroot '
set -e
cd /sources
rm -rf mpdecimal-4.0.1
tar -xf mpdecimal-4.0.1.tar.gz
cd mpdecimal-4.0.1

./configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/mpdecimal-4.0.1
make
make install

cd /sources
rm -rf mpdecimal-4.0.1
'

echo "mpdecimal temporário concluído com sucesso."
