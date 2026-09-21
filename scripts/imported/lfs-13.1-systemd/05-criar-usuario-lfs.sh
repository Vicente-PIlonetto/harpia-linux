#!/bin//bash

set -e

source "$HOME/lfs-build/config.sh"

echo "COnfigurando usuario de compilação LFS..."

if ! getent group lfs >/dev/null; then
	sudo groupadd lfs
	echo "Grupo do LFS criado"
else
	echo "Grupo lfs já existe chapa"
fi

if ! id lfs >/dev/null 2>&1; then
	sudo useradd \
		-s /bin/bash \
		-g lfs \
		-m \
		-k /dev/null \
		lfs

	echo "Usuario lfs Criado"
else
	echo "Usuario lfs já existe!"

fi

echo "Ajustando propiedade da estrutuda do LFS"

sudo chown -v lfs "$LFS"/{usr{,/*},lib,var,etc,tools} #Corrigido de urs para usr - Viko 17/09/26

if [ "$(uname -m)" = "x86_64" ]; then
	sudo chown -v lfs "$LFS/lib64"
fi

echo "Usuario LFS configurado com sucesso chefe!"

