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

echo "Contando módulos..."
count="$(find "$ROOT_DIR/scripts" -maxdepth 1 -type f -name '[0-9][0-9]-*.sh' | wc -l)"
echo "Módulos encontrados: $count"

for n in $(seq 1 72); do
    [ "$n" -eq 42 ] && continue
    if ! find "$ROOT_DIR/scripts" -maxdepth 1 -type f -name "$(printf '%02d' "$n")-*.sh" | grep -q .; then
        echo "FALTANDO: módulo $(printf '%02d' "$n")"
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    exit 1
fi

echo "Validação estrutural concluída."
