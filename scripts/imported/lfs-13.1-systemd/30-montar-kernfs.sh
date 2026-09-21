#!/bin/bash
set -e
source "$HOME/lfs-build/config.sh"

echo "Preparando sistemas de arquivos virtuais..."

sudo mkdir -pv "$LFS"/{dev,proc,sys,run}

if ! mountpoint -q "$LFS/dev"; then
    sudo mount -v --bind /dev "$LFS/dev"
fi

if ! mountpoint -q "$LFS/dev/pts"; then
    sudo mount -vt devpts devpts -o gid=5,mode=0620 "$LFS/dev/pts"
fi

if ! mountpoint -q "$LFS/proc"; then
    sudo mount -vt proc proc "$LFS/proc"
fi

if ! mountpoint -q "$LFS/sys"; then
    sudo mount -vt sysfs sysfs "$LFS/sys"
fi

if ! mountpoint -q "$LFS/run"; then
    sudo mount -vt tmpfs tmpfs "$LFS/run"
fi

if [ -h "$LFS/dev/shm" ]; then
    sudo install -v -d -m 1777 "$LFS$(realpath /dev/shm)"
elif ! mountpoint -q "$LFS/dev/shm"; then
    sudo mount -vt tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
fi

echo "Sistemas de arquivos virtuais montados."

