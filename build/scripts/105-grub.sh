#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando GRUB 2.14 (ferramentas x86_64 UEFI)..."
echo "OBS: o boot padrão da Harpia continua planejado como UKI + systemd-boot."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf grub-2.14
tar -xf "$(find . -maxdepth 1 -type f -name 'grub-2.14.tar.*' | head -n1)"
cd grub-2.14

unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS

sed 's/--image-base/--nonexist-linker-option/' -i configure

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --target=x86_64     \
            --with-platform=efi \
            --disable-efiemu    \
            --disable-werror

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Testes do GRUB não serão executados automaticamente."
    echo "A suíte não é recomendada no ambiente LFS limitado."
fi

make install

cd /sources
rm -rf grub-2.14
CHROOT

echo "GRUB concluído com sucesso."
