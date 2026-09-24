#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME_DIR="${HARP_RUNTIME_DIR:-$HOME/lfs-build}"
SCRIPT_DIR="$RUNTIME_DIR/scripts"

usage() {
    cat <<'EOF'
Harpia Linux - orquestrador LFS 13.1-systemd

Uso:
  ./build.sh --list
  ./build.sh --phase host --execute
  ./build.sh --phase cross --execute
  ./build.sh --phase temporary --execute
  ./build.sh --phase chroot --execute
  ./build.sh --cleanup --execute
  ./build.sh --phase base --execute
  ./build.sh --phase base-next --execute
  ./build.sh --from N --to N --execute

Fases:
  host       01-06
  cross      07-11
  temporary  12-28
  chroot     29-40
  cleanup    41
  helper     42
  base       43-100
  base-next  83-100

Roadmap 101-165:
  build/roadmap/first-boot.tsv

Antes de executar:
  ./deploy.sh
EOF
}

list_scripts() {
    find "$SCRIPT_DIR" -maxdepth 1 -type f -name '[0-9][0-9]*-*.sh' -printf '%f\n' | sort -V
}

require_execute=0
mode=""
from=""
to=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --execute) require_execute=1 ;;
        --list) mode="list" ;;
        --phase) shift; mode="${1:-}" ;;
        --cleanup) mode="cleanup" ;;
        --from) shift; from="${1:-}" ;;
        --to) shift; to="${1:-}" ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Argumento desconhecido: $1"; usage; exit 2 ;;
    esac
    shift
done

if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Runtime não encontrado em: $RUNTIME_DIR"
    echo "Rode primeiro: $ROOT_DIR/deploy.sh"
    exit 1
fi

if [ "$mode" = "list" ]; then
    list_scripts
    exit 0
fi

if [ "$require_execute" -ne 1 ]; then
    echo "Nada foi executado. Use --execute após revisar a fase."
    usage
    exit 2
fi

run_range() {
    local a="$1" b="$2"
    local n file
    for n in $(seq "$a" "$b"); do
        [ "$n" -eq 42 ] && continue
        file="$(find "$SCRIPT_DIR" -maxdepth 1 -type f -name "$(printf '%02d' "$n")-*.sh" -o -name "${n}-*.sh" | sort -V | head -n1)"
        if [ -z "$file" ]; then
            echo "ERRO: módulo $n não encontrado."
            exit 1
        fi
        echo
        echo "============================================================"
        echo "Executando $(basename "$file")"
        echo "============================================================"
        "$file"
    done
}

case "$mode" in
    host) run_range 1 6 ;;
    cross) run_range 7 11 ;;
    temporary) run_range 12 28 ;;
    chroot) run_range 29 40 ;;
    cleanup)
        if [ "${HARP_ALLOW_CLEANUP:-0}" != "1" ]; then
            echo "Para liberar: HARP_ALLOW_CLEANUP=1 ./build.sh --cleanup --execute"
            exit 2
        fi
        run_range 41 41
        ;;
    base) run_range 43 100 ;;
    base-next) run_range 83 100 ;;
    "")
        if [ -n "$from" ] && [ -n "$to" ]; then
            run_range "$from" "$to"
        else
            usage
            exit 2
        fi
        ;;
    *) echo "Fase inválida: $mode"; usage; exit 2 ;;
esac
