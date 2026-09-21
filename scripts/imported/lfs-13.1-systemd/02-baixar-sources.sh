#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

LFS_VERSION="13.1"
LFS_DOWNLOAD_BASE="https://www.linuxfromscratch.org/lfs/downloads/stable-systemd"

echo "LFS $LFS_VERSION"
echo "Preparando para baixar os pacotes"

cd "$LFS/sources" #corrigindo erro do md5Sums 17/09/26 -viko

echo "$LFS/sources"

wget -c "$LFS_DOWNLOAD_BASE/wget-list"
wget -c "$LFS_DOWNLOAD_BASE/md5sums"

wget \
	--input-file=wget-list \
	--continue \
	--directory-prefix="$LFS/sources"

echo "Download dos pacotes completos"

