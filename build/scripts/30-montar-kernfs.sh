#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

echo "Preparando sistemas de arquivos virtuais..."

sudo mkdir -pv "$LFS"/{dev,proc,sys,run}

mountpoint -q "$LFS/dev"     || sudo mount -v --bind /dev "$LFS/dev"
mountpoint -q "$LFS/dev/pts" || sudo mount -vt devpts devpts -o gid=5,mode=0620 "$LFS/dev/pts"
mountpoint -q "$LFS/proc"    || sudo mount -vt proc proc "$LFS/proc"
mountpoint -q "$LFS/sys"     || sudo mount -vt sysfs sysfs "$LFS/sys"
mountpoint -q "$LFS/run"     || sudo mount -vt tmpfs tmpfs "$LFS/run"

if [ -h "$LFS/dev/shm" ]; then
    sudo install -v -d -m 1777 "$LFS$(realpath /dev/shm)"
elif ! mountpoint -q "$LFS/dev/shm"; then
    sudo mount -vt tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
fi

echo "Sistemas de arquivos virtuais montados."
