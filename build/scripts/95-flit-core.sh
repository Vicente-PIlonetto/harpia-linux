#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Flit-Core 4.0.2..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf flit_core-4.0.2
tar -xf "$(find . -maxdepth 1 -type f -name 'flit_core-4.0.2.tar.*' | head -n1)"
cd flit_core-4.0.2
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist flit_core
cd /sources
rm -rf flit_core-4.0.2
CHROOT
echo "Flit-Core concluído com sucesso."
