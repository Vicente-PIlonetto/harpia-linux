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

echo "Iniciando Texinfo temporário..."

run_chroot '
set -e
cd /sources
rm -rf texinfo-7.3
tar -xf texinfo-7.3.tar.xz
cd texinfo-7.3

./configure --prefix=/usr
make
make install

cd /sources
rm -rf texinfo-7.3
'

echo "Texinfo temporário concluído com sucesso."

