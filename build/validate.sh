#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
failed=0

echo "Validando sintaxe Bash..."
while IFS= read -r -d '' f; do
    if ! bash -n "$f"; then
        echo "FALHA: $f"
        failed=1
    fi
done < <(find "$ROOT_DIR" -type f -name '*.sh' -print0)

echo "Validando módulos implementados..."
for n in $(seq 1 100); do
    [ "$n" -eq 42 ] && continue
    pattern="$(printf '%02d' "$n")"
    if [ "$n" -ge 100 ]; then pattern="$n"; fi
    if ! find "$ROOT_DIR/scripts" -maxdepth 1 -type f -name "${pattern}-*.sh" | grep -q .; then
        echo "FALTANDO: módulo $n"
        failed=1
    fi
done

count="$(find "$ROOT_DIR/scripts" -maxdepth 1 -type f -name '[0-9]*-*.sh' | wc -l)"
echo "Scripts de módulo encontrados: $count"

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo "Validação estrutural concluída."
