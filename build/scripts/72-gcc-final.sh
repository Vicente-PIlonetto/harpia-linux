#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando GCC 16.2.0 final..."
echo "Este é um dos módulos mais demorados desta fase."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf gcc-16.2.0
tar -xf gcc-16.2.0.tar.xz
cd gcc-16.2.0

case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
    ;;
esac

mkdir -v build
cd build

../configure \
    --prefix=/usr \
    LD=ld \
    --enable-languages=c,c++ \
    --enable-default-pie \
    --enable-default-ssp \
    --enable-host-pie \
    --enable-targets=all \
    --disable-multilib \
    --disable-bootstrap \
    --disable-fixincludes \
    --with-system-zlib

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do GCC. Isso pode demorar bastante..."

    ulimit -s -H unlimited || true
    chown -R tester .

    set +e
    su tester -c "PATH=$PATH make -k -j${HARP_JOBS:-1} check" \
        2>&1 | tee /sources/gcc-16.2.0-check.log
    set -e

    chown -R root:root .

    ../contrib/test_summary -t \
        2>&1 | tee /sources/gcc-16.2.0-test-summary.log || true

    echo
    echo "Resumo GCC salvo em:"
    echo "  /sources/gcc-16.2.0-test-summary.log"
fi

make install

chown -v -R root:root $(gcc -print-file-name=include){,-fixed}

ln -svr /usr/bin/cpp /usr/lib
ln -sv gcc.1 /usr/share/man/man1/cc.1
ln -sfvr $(gcc -print-prog-name=liblto_plugin.so) /usr/lib/bfd-plugins/

echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log

echo "=== Interpretador ELF ==="
readelf -l a.out | grep ': /lib'

echo "=== Start files ==="
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log

echo "=== Headers ==="
grep -B4 '^ /usr/include' dummy.log

echo "=== Search path do linker ==="
grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'

echo "=== libc ==="
grep '/lib.*/libc.so.6 ' dummy.log

echo "=== Dynamic linker ==="
grep found dummy.log

rm -v a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
if compgen -G "/usr/lib/*gdb.py" > /dev/null; then
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
fi

cd /sources
rm -rf gcc-16.2.0
CHROOT

echo "GCC final concluído com sucesso."
