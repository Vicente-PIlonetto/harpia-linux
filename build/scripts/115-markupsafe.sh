#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando MarkupSafe 3.0.3..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf markupsafe-3.0.3
tar -xf "$(find . -maxdepth 1 -type f -name 'markupsafe-3.0.3.tar.*' | head -n1)"
cd markupsafe-3.0.3

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist Markupsafe

cd /sources
rm -rf markupsafe-3.0.3
CHROOT

echo "MarkupSafe concluído com sucesso."
