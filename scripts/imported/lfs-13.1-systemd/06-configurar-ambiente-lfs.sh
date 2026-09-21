#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Configurando ambiente do usuário lfs..."

LFS_HOME="$(getent passwd lfs | cut -d: -f6)"

if [ -z "$LFS_HOME" ]; then
    echo "Erro: não foi possível localizar o diretório home do usuário lfs."
    exit 1
fi

sudo tee "$LFS_HOME/.bash_profile" >/dev/null <<'EOF'
exec env -i \
    HOME=$HOME \
    TERM=$TERM \
    PS1='\u:\w\$ ' \
    /bin/bash
EOF

sudo tee "$LFS_HOME/.bashrc" >/dev/null <<EOF
set +h
umask 022

LFS=$LFS
LC_ALL=POSIX
LFS_TGT=\$(uname -m)-lfs-linux-gnu

PATH=/usr/bin

if [ ! -L /bin ]; then
    PATH=/bin:\$PATH
fi

PATH=\$LFS/tools/bin:\$PATH
CONFIG_SITE=\$LFS/usr/share/config.site

export LFS LC_ALL LFS_TGT PATH CONFIG_SITE

MAKEFLAGS="-j\$(nproc)"
export MAKEFLAGS
EOF

sudo chown lfs:lfs "$LFS_HOME/.bash_profile" "$LFS_HOME/.bashrc"

echo "Ambiente do usuário lfs configurado com sucesso."


