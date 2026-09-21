#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Criando a estrutuda base do LFS em: $LFS"

sudo mkdir -pv "$LFS"/{etc,var}
sudo mkdir -pv "$LFS/usr"/{bin,lib,slib}

for dir in bin lib slib
do
	if [ ! -e "$LFS/$dir" ]; then
		sudo ln -sv "usr/$dir" "$LFS/$dir"
	fi
done

if [ "$(uname -m)" = "x86_64" ]; then
	sudo mkdir -pv "$LFS/lib64"
fi

sudo mkdir -pv "$LFS/tools"

echo "Estrutura base do LFS criada com sucesso chefe!"


