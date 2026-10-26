#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

if [ "${HARP_ALLOW_CLEANUP:-0}" != "1" ]; then
    echo "ERRO: limpeza final bloqueada por segurança."
    echo
    echo "Este módulo remove arquivos temporários, arquivos .la,"
    echo "resíduos do toolchain temporário e o usuário tester."
    echo "Crie/confirme um snapshot antes de continuar."
    echo
    echo "Para liberar:"
    echo "  HARP_ALLOW_CLEANUP=1 $0"
    exit 2
fi

echo "Executando limpeza final do Chapter 8..."

run_chroot <<'CHROOT'
set -e

rm -rf /tmp/{*,.*} 2>/dev/null || true

find /usr/lib /usr/libexec -name '*.la' -delete

find /usr -depth -name "$(uname -m)-lfs-linux-gnu*" -print0 |
    xargs -0 -r rm -rf

if id tester >/dev/null 2>&1; then
    userdel -r tester
fi
CHROOT

echo "Limpeza final concluída com sucesso."
