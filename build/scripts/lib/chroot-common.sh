#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

HARP_RUN_TESTS="${HARP_RUN_TESTS:-1}"
HARP_JOBS="${HARP_JOBS:-$(nproc)}"

require_chroot_mounts() {
    local missing=0

    for path in dev proc sys run; do
        if ! mountpoint -q "$LFS/$path"; then
            echo "ERRO: $LFS/$path não está montado."
            missing=1
        fi
    done

    if [ "$missing" -ne 0 ]; then
        echo
        echo "Rode primeiro:"
        echo "  ~/lfs-build/scripts/30-montar-kernfs.sh"
        exit 1
    fi
}

run_chroot() {
    require_chroot_mounts

    sudo chroot "$LFS" /usr/bin/env -i \
        HOME=/root \
        TERM="${TERM:-xterm}" \
        PS1='(harpia-lfs chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin \
        MAKEFLAGS="-j${HARP_JOBS}" \
        TESTSUITEFLAGS="-j${HARP_JOBS}" \
        HARP_RUN_TESTS="${HARP_RUN_TESTS}" \
        HARP_JOBS="${HARP_JOBS}" \
        /bin/bash -s
}
