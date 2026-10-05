#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

LFS_VERSION="13.1"
LFS_DOWNLOAD_BASE="https://www.linuxfromscratch.org/lfs/downloads/stable-systemd"

echo "LFS $LFS_VERSION"
echo "Preparando para baixar os pacotes"

cd "$LFS/sources"

wget -c "$LFS_DOWNLOAD_BASE/wget-list"
wget -c "$LFS_DOWNLOAD_BASE/md5sums"

wget \
    --input-file=wget-list \
    --continue \
    --directory-prefix="$LFS/sources" || true

# Fallbacks para mirrors GNU que eventualmente retornem 404.
if [ ! -f "$LFS/sources/bash-5.3.tar.gz" ]; then
    wget -c https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz -P "$LFS/sources"
fi

if [ ! -f "$LFS/sources/grub-2.14.tar.xz" ]; then
    wget -c https://ftp.gnu.org/gnu/grub/grub-2.14.tar.xz -P "$LFS/sources"
fi

echo "Download dos pacotes completo."
