#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Jinja2 3.1.6..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf jinja2-3.1.6
tar -xf "$(find . -maxdepth 1 -type f -name 'jinja2-3.1.6.tar.*' | head -n1)"
cd jinja2-3.1.6

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps "$PWD"
pip3 install --no-index --find-links dist Jinja2

cd /sources
rm -rf jinja2-3.1.6
CHROOT

echo "Jinja2 concluído com sucesso."
