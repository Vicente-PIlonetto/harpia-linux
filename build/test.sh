#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"
LFS_ROOT="${HARP_LFS_ROOT:-/mnt/lfs}"
MODULES="101-124"
RUN_STATIC=0
RUN_SMOKE=0
LOG_DIR=""

usage() {
    cat <<'HELP'
Harpia Linux - Bulk Validation

Uso:
  ./test.sh --bulk --static --modules 101-124
  sudo ./test.sh --bulk --smoke --modules 101-124
  sudo ./test.sh --bulk --static --smoke --modules 101-124

Opcoes:
  --bulk             validacao em lote
  --static           sintaxe, executavel e ShellCheck
  --smoke            verificacoes no chroot LFS
  --modules N-M      intervalo (padrao: 101-124)
  --root DIR         raiz do LFS (padrao: /mnt/lfs)
  --log-dir DIR      diretorio dos relatorios
  -h, --help         exibir ajuda

Nunca executa scripts de instalacao.
Smoke tests dos modulos 123 e 124 sao proibidos.
HELP
}

while (( $# )); do
    case "$1" in
        --bulk) ;;
        --static) RUN_STATIC=1 ;;
        --smoke) RUN_SMOKE=1 ;;
        --modules|--root|--log-dir)
            opt="$1"
            (( $# >= 2 )) || {
                echo "Falta valor para $opt" >&2
                exit 2
            }
            shift
            case "$opt" in
                --modules) MODULES="$1" ;;
                --root) LFS_ROOT="$1" ;;
                --log-dir) LOG_DIR="$1" ;;
            esac
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Opcao desconhecida: $1" >&2
            usage
            exit 2
            ;;
    esac
    shift
done

if (( ! RUN_STATIC && ! RUN_SMOKE )); then
    RUN_STATIC=1
fi

if [[ ! "$MODULES" =~ ^([0-9]{1,3})-([0-9]{1,3})$ ]]; then
    echo "Intervalo invalido: $MODULES" >&2
    exit 2
fi

FIRST=$((10#${BASH_REMATCH[1]}))
LAST=$((10#${BASH_REMATCH[2]}))

if (( FIRST < 1 || LAST > 124 || FIRST > LAST )); then
    echo "Intervalo permitido: 1-124" >&2
    exit 2
fi

if (( RUN_SMOKE )); then
    (( EUID == 0 )) || {
        echo "Smoke tests exigem sudo." >&2
        exit 2
    }

    [[ "$LFS_ROOT" != / ]] || {
        echo "A raiz do chroot nao pode ser /." >&2
        exit 2
    }

    [[ -x "$LFS_ROOT/bin/bash" ]] || {
        echo "Chroot LFS indisponivel: $LFS_ROOT" >&2
        exit 2
    }

    command -v timeout >/dev/null || {
        echo "Comando timeout indisponivel." >&2
        exit 2
    }
fi

if [[ -z "$LOG_DIR" ]]; then
    LOG_DIR="$(mktemp -d "${TMPDIR:-/tmp}/harpia-bulk.XXXXXXXX")"
else
    mkdir -p -- "$LOG_DIR"
fi

RESULTS="$LOG_DIR/results.tsv"
printf 'module\tmode\tstatus\tdetail\n' > "$RESULTS"

record() {
    local n="$1"
    local mode="$2"
    local status="$3"
    local detail="$4"

    printf '%s\t%s\t%s\t%s\n' \
        "$n" "$mode" "$status" "$detail" >> "$RESULTS"

    printf '[%03d] %-7s %-5s %s\n' \
        "$n" "$mode" "$status" "$detail"
}

static_test() {
    local n="$1"
    local file="$2"
    local log

    log="$LOG_DIR/$(printf '%03d' "$n")-static.log"
    : > "$log"

    if [[ ! -x "$file" ]]; then
        record "$n" static FAIL "sem permissao de execucao"

    elif ! bash -n "$file" &>> "$log"; then
        record "$n" static FAIL "erro de sintaxe Bash"

    elif command -v shellcheck >/dev/null 2>&1; then
        if shellcheck -e SC1091 "$file" &>> "$log"; then
            record "$n" static PASS "Bash, execucao e ShellCheck"
        else
            record "$n" static FAIL "ShellCheck encontrou problemas"
        fi

    else
        record "$n" static WARN "Bash OK; ShellCheck indisponivel"
    fi
}

probe_for() {
    local n="$1"

    PROBE_BIN=""
    PROBE_CMD=""

    case "$n" in
        101) PROBE_BIN="env"; PROBE_CMD='env --version' ;;
        102) PROBE_BIN="diff"; PROBE_CMD='diff --version' ;;
        103) PROBE_BIN="find"; PROBE_CMD='find --version' ;;
        104) PROBE_BIN=groff; PROBE_CMD='groff --version' ;;
        105) PROBE_BIN=grub-mkimage; PROBE_CMD='grub-mkimage --version' ;;
        106) PROBE_BIN=gzip; PROBE_CMD='gzip --version' ;;
        107) PROBE_BIN=ip; PROBE_CMD='ip -V' ;;
        108) PROBE_BIN=loadkeys; PROBE_CMD='loadkeys --version' ;;
        109) PROBE_CMD="compgen -G '/usr/lib/libpipeline.so*' >/dev/null" ;;
        110) PROBE_BIN="make"; PROBE_CMD='make --version' ;;
        111) PROBE_BIN="patch"; PROBE_CMD='patch --version' ;;
        112) PROBE_BIN=tar; PROBE_CMD='tar --version' ;;
        113) PROBE_BIN=makeinfo; PROBE_CMD='makeinfo --version' ;;
        114) PROBE_BIN=vim; PROBE_CMD='vim --version' ;;
        115) PROBE_BIN=python3; PROBE_CMD='PYTHONDONTWRITEBYTECODE=1 python3 -c "import markupsafe"' ;;
        116) PROBE_BIN=python3; PROBE_CMD='PYTHONDONTWRITEBYTECODE=1 python3 -c "import jinja2"' ;;
        117) PROBE_BIN=systemctl; PROBE_CMD='systemctl --version' ;;
        118) PROBE_BIN=dbus-daemon; PROBE_CMD='dbus-daemon --version' ;;
        119) PROBE_BIN="man"; PROBE_CMD='man --version' ;;
        120) PROBE_BIN="ps"; PROBE_CMD='ps --version' ;;
        121) PROBE_BIN=lsblk; PROBE_CMD='lsblk --version' ;;
        122) PROBE_BIN=e2fsck; PROBE_CMD='e2fsck -V' ;;
    esac
}

chroot_probe() {
    timeout 15s chroot "$LFS_ROOT" /bin/bash -c \
        "export PATH=/usr/sbin:/usr/bin:/sbin:/bin; $1"
}

smoke_test() {
    local n="$1"
    local log

    log="$LOG_DIR/$(printf '%03d' "$n")-smoke.log"
    : > "$log"

    if (( n >= 123 )); then
        record "$n" smoke SKIP "operacao destrutiva protegida"
        return
    fi

    probe_for "$n"

    if [[ -z "$PROBE_CMD" ]]; then
        record "$n" smoke SKIP "sem teste definido"
        return
    fi

    if [[ -n "$PROBE_BIN" ]] &&
       ! chroot_probe "command -v '$PROBE_BIN' >/dev/null 2>&1" &>> "$log"; then
        record "$n" smoke SKIP "comando ausente no LFS"
        return
    fi

    if chroot_probe "$PROBE_CMD" &>> "$log"; then
        record "$n" smoke PASS "verificacao basica no chroot"

    elif [[ "$n" == 109 ]] ||
         { (( n == 115 || n == 116 )) &&
           grep -q 'ModuleNotFoundError' "$log"; }; then
        record "$n" smoke SKIP "biblioteca ainda ausente"

    else
        record "$n" smoke FAIL "falha no teste; consultar log"
    fi
}

printf 'Harpia Linux - Bulk Validation %s\n' "$MODULES"
printf 'Logs: %s\n\n' "$LOG_DIR"

shopt -s nullglob

for (( n=FIRST; n<=LAST; n++ )); do

    if (( n == 42 )); then
        record "$n" bulk SKIP "modulo auxiliar"
        continue
    fi

    printf -v prefix '%02d' "$n"
    matches=("$SCRIPTS_DIR"/"$prefix"-*.sh)

    if (( ${#matches[@]} != 1 )); then
        record "$n" bulk FAIL \
            "esperado um script; encontrados ${#matches[@]}"
        continue
    fi

    if (( RUN_STATIC )); then
        static_test "$n" "${matches[0]}"
    fi

    if (( RUN_SMOKE )); then
        smoke_test "$n"
    fi
done

echo

awk -F '\t' '
NR > 1 { n[$3]++ }
END {
    printf "Resumo: PASS=%d WARN=%d SKIP=%d FAIL=%d\n",
        n["PASS"], n["WARN"], n["SKIP"], n["FAIL"]
}' "$RESULTS"

printf 'Relatorio: %s\n' "$RESULTS"

if awk -F '\t' '
NR > 1 && $3 == "FAIL" { failed=1 }
END { exit !failed }
' "$RESULTS"; then
    exit 1
fi
