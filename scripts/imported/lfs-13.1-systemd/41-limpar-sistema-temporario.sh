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

echo "Limpando sistema temporário dentro do chroot..."

run_chroot '
set -e
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name "*.la" -delete
rm -rf /tools
'

echo "Limpeza do sistema temporário concluída."

