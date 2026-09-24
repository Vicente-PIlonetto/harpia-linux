#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Wheel 0.48.0..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf wheel-0.48.0
tar -xf "$(find . -maxdepth 1 -type f -name 'wheel-0.48.0.tar.*' | head -n1)"
cd wheel-0.48.0
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist wheel
cd /sources
rm -rf wheel-0.48.0
CHROOT
echo "Wheel concluído com sucesso."
