#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${HARP_RUNTIME_DIR:-$HOME/lfs-build}"

mkdir -p "$DEST/scripts/lib"

cp -v "$ROOT_DIR/config.sh" "$DEST/config.sh"
cp -v "$ROOT_DIR/scripts/"[0-9][0-9]-*.sh "$DEST/scripts/"
cp -v "$ROOT_DIR/scripts/lib/chroot-common.sh" "$DEST/scripts/lib/chroot-common.sh"

chmod +x "$DEST/config.sh" "$DEST/scripts/"*.sh "$DEST/scripts/lib/"*.sh

echo
echo "Runtime instalado em: $DEST"
echo "Valide com:"
echo "  bash -n $DEST/scripts/*.sh"
echo "  $ROOT_DIR/build.sh --list"
