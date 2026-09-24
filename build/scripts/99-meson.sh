#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Meson 1.12.0..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf meson-1.12.0
tar -xf "$(find . -maxdepth 1 -type f -name 'meson-1.12.0.tar.*' | head -n1)"
cd meson-1.12.0
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
cd /sources
rm -rf meson-1.12.0
CHROOT
echo "Meson concluído com sucesso."
