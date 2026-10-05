#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Iana-Etc 20260805..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf iana-etc-20260805
tar -xf iana-etc-20260805.tar.gz
cd iana-etc-20260805

cp -v services protocols /etc

cd /sources
rm -rf iana-etc-20260805
CHROOT

echo "Iana-Etc concluído com sucesso."
