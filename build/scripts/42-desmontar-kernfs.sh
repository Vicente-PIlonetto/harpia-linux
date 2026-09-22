#!/bin/bash
set -e
source "$HOME/lfs-build/config.sh"

echo "Desmontando sistemas de arquivos virtuais..."

mountpoint -q "$LFS/dev/shm" && sudo umount "$LFS/dev/shm" || true
mountpoint -q "$LFS/dev/pts" && sudo umount "$LFS/dev/pts" || true
mountpoint -q "$LFS/sys" && sudo umount "$LFS/sys" || true
mountpoint -q "$LFS/proc" && sudo umount "$LFS/proc" || true
mountpoint -q "$LFS/run" && sudo umount "$LFS/run" || true
mountpoint -q "$LFS/dev" && sudo umount "$LFS/dev" || true

echo "Sistemas de arquivos virtuais desmontados."
