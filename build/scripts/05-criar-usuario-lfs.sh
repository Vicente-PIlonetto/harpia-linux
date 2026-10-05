#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Configurando usuário de compilação LFS..."

if ! getent group lfs >/dev/null; then
    sudo groupadd lfs
    echo "Grupo lfs criado."
else
    echo "Grupo lfs já existe."
fi

if ! id lfs >/dev/null 2>&1; then
    sudo useradd \
        -s /bin/bash \
        -g lfs \
        -m \
        -k /dev/null \
        lfs

    echo "Usuário lfs criado."
else
    echo "Usuário lfs já existe."
fi

echo "Ajustando propriedade da estrutura do LFS..."

sudo chown -Rv lfs "$LFS"/{usr,var,etc,tools}

if [ "$(uname -m)" = "x86_64" ]; then
    sudo chown -v lfs "$LFS/lib64"
fi

echo "Usuário lfs configurado com sucesso."
