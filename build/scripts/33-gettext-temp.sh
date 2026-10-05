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

echo "Iniciando Gettext temporário..."

run_chroot '
set -e
cd /sources
rm -rf gettext-1.0
tar -xf gettext-1.0.tar.xz
cd gettext-1.0

./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

cd /sources
rm -rf gettext-1.0
'

echo "Gettext temporário concluído com sucesso."
