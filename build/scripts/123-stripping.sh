#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

if [ "${HARP_ALLOW_STRIP:-0}" != "1" ]; then
    echo "ERRO: stripping bloqueado por segurança."
    echo
    echo "Este módulo modifica binários e bibliotecas do sistema."
    echo "Crie/confirme um snapshot antes de continuar."
    echo
    echo "Para liberar:"
    echo "  HARP_ALLOW_STRIP=1 $0"
    exit 2
fi

echo "Executando stripping final..."

run_chroot <<'CHROOT'
set -e

save_usrlib="$(cd /usr/lib; ls ld-linux*[^g] 2>/dev/null | head -n1)
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.36
             libitm.so.1.0.0
             libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    if [ ! -e "$LIB" ]; then
        echo "AVISO: biblioteca esperada não encontrada: /usr/lib/$LIB"
        continue
    fi
    objcopy --only-keep-debug --compress-debug-sections=zstd "$LIB" "$LIB.dbg"
    cp "$LIB" "/tmp/$LIB"
    strip --strip-unneeded "/tmp/$LIB"
    objcopy --add-gnu-debuglink="$LIB.dbg" "/tmp/$LIB"
    install -vm755 "/tmp/$LIB" /usr/lib
    rm -f "/tmp/$LIB"
done

online_usrbin="bash find strip"
online_usrlib="libbfd-2.47.20260726.so
               libsframe.so.3.0.0
               libhistory.so.8.3
               libncursesw.so.6.6
               libm.so.6
               libreadline.so.8.3
               libz.so.1.3.2
               libzstd.so.1.5.7
               $(cd /usr/lib; find libnss*.so* -type f -printf '%f\n')"

for BIN in $online_usrbin; do
    [ -e "/usr/bin/$BIN" ] || continue
    cp "/usr/bin/$BIN" "/tmp/$BIN"
    strip --strip-unneeded "/tmp/$BIN"
    install -vm755 "/tmp/$BIN" /usr/bin
    rm -f "/tmp/$BIN"
done

for LIB in $online_usrlib; do
    [ -e "/usr/lib/$LIB" ] || continue
    cp "/usr/lib/$LIB" "/tmp/$LIB"
    strip --strip-unneeded "/tmp/$LIB"
    install -vm755 "/tmp/$LIB" /usr/lib
    rm -f "/tmp/$LIB"
done

while IFS= read -r -d '' i; do
    case " $online_usrbin $online_usrlib $save_usrlib " in
        *" $(basename "$i") "*)
            ;;
        *)
            strip --strip-unneeded "$i" 2>/dev/null || true
            ;;
    esac
done < <(
    find /usr/lib -type f \( -name '*.so*' -o -name '*.a' \) ! -name '*dbg' -print0
    find /usr/bin /usr/sbin /usr/libexec -type f -print0
)

unset BIN LIB save_usrlib online_usrbin online_usrlib
CHROOT

echo "Stripping concluído com sucesso."
