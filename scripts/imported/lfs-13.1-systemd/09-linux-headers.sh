#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Instalando Linux API Headers..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"

rm -rf linux-7.1.8
tar -xf linux-7.1.8.tar.xz
cd linux-7.1.8

make mrproper
make headers

find usr/include -type f ! -name "*.h" -delete

cp -rv usr/include "$LFS/usr"

cd "$LFS/sources"
rm -rf linux-7.1.8
'

echo "Linux API Headers concluído com sucesso."

