#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando SQLite 3.53.4..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf sqlite-autoconf-3530400
tar -xf "$(find . -maxdepth 1 -type f -name 'sqlite-autoconf-3530400.tar.*' | head -n1)"
cd sqlite-autoconf-3530400
[ ! -f ../sqlite-doc-3530400.zip ] || python3 -m zipfile -e ../sqlite-doc-3530400.zip .
./configure --prefix=/usr \
            --disable-static \
            --enable-fts4 \
            --enable-fts5 \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 -D SQLITE_ENABLE_UNLOCK_NOTIFY=1 -D SQLITE_ENABLE_DBSTAT_VTAB=1 -D SQLITE_SECURE_DELETE=1"
make LDFLAGS.rpath=""
make install
[ ! -d sqlite-doc-3530400 ] || cp -v -R sqlite-doc-3530400 -T /usr/share/doc/sqlite-3.53.4
cd /sources
rm -rf sqlite-autoconf-3530400
CHROOT
echo "SQLite concluído com sucesso."
