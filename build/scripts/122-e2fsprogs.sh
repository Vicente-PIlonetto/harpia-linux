#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando E2fsprogs 1.47.4..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf e2fsprogs-1.47.4
tar -xf "$(find . -maxdepth 1 -type f -name 'e2fsprogs-1.47.4.tar.*' | head -n1)"
cd e2fsprogs-1.47.4

mkdir -v build
cd build

../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck

make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do E2fsprogs..."
    echo "OBS: m_assume_storage_prezeroed e, em filesystem não-ext4, m_rootdir_acl podem falhar."

    set +e
    make check 2>&1 | tee /sources/e2fsprogs-1.47.4-check.log
    test_rc=${PIPESTATUS[0]}
    set -e

    if [ "$test_rc" -ne 0 ]; then
        echo
        echo "AVISO: testes do E2fsprogs retornaram código $test_rc."
        echo "Log: /sources/e2fsprogs-1.47.4-check.log"
    fi
fi

make install
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

if [ -f /usr/share/info/libext2fs.info.gz ]; then
    gunzip -v /usr/share/info/libext2fs.info.gz
fi
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

cd /sources
rm -rf e2fsprogs-1.47.4
CHROOT

echo "E2fsprogs concluído com sucesso."
