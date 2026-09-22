#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Shadow 4.20.2..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf shadow-4.20.2
tar -xf shadow-4.20.2.tar.xz
cd shadow-4.20.2

find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -e 's:#ENCRYPT_METHOD SHA512:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:' \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
    -i etc/login.defs

touch /usr/bin/passwd

./configure \
    --sysconfdir=/etc \
    --disable-static \
    --with-bcrypt \
    --with-yescrypt \
    --without-libbsd \
    --disable-logind \
    --with-group-name-max-length=32

make
make exec_prefix=/usr install
make -C man install-man

pwconv
grpconv

mkdir -p /etc/default
useradd -D --gid 999

touch /etc/subuid /etc/subgid

cd /sources
rm -rf shadow-4.20.2
CHROOT

echo "Shadow concluído com sucesso."
echo
echo "ATENÇÃO: a senha do root NÃO foi definida automaticamente."
echo "Ela será tratada em um módulo de configuração para não colocar"
echo "senha em texto puro nos scripts da Harpia."
