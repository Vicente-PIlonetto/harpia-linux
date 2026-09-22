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

echo "Iniciando Python temporário..."

run_chroot '
set -e
cd /sources
rm -rf Python-3.14.7
tar -xf Python-3.14.7.tar.xz
cd Python-3.14.7

./configure --prefix=/usr \
            --enable-shared \
            --without-ensurepip \
            --without-static-libpython
make
make install

cd /sources
rm -rf Python-3.14.7
'

echo "Python temporário concluído com sucesso."
