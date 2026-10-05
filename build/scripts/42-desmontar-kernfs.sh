#!/bin/bash
set -e

source "$HOME/lfs-build/config.sh"

echo "Desmontando sistemas de arquivos virtuais..."

if mountpoint -q "$LFS/dev/shm"; then
    sudo umount "$LFS/dev/shm"
fi

if mountpoint -q "$LFS/dev/pts"; then
    sudo umount "$LFS/dev/pts"
fi

if mountpoint -q "$LFS/sys"; then
    sudo umount "$LFS/sys"
fi

if mountpoint -q "$LFS/proc"; then
    sudo umount "$LFS/proc"
fi

if mountpoint -q "$LFS/run"; then
    sudo umount "$LFS/run"
fi

if mountpoint -q "$LFS/dev"; then
    sudo umount "$LFS/dev"
fi

echo "Sistemas de arquivos virtuais desmontados."
