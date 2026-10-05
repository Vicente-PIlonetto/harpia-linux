#!/bin/bash
set -euo pipefail

source "$HOME/lfs-build/config.sh"

if [ "${HARP_ALLOW_CLEANUP:-0}" != "1" ]; then
    echo "ERRO: limpeza bloqueada por segurança."
    echo
    echo "Este módulo remove arquivos temporários e /tools."
    echo "Execute somente quando tiver certeza de que deseja continuar."
    echo
    echo "Para liberar:"
    echo "  HARP_ALLOW_CLEANUP=1 $0"
    exit 2
fi

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
