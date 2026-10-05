#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Tcl 8.6.18..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf tcl8.6.18
tar -xf tcl8.6.18-src.tar.gz
cd tcl8.6.18

SRCDIR=$(pwd)
cd unix

./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --disable-rpath

make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|" \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.13|/usr/lib/tdbc1.1.13|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.13/generic|/usr/include|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.13/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.13|/usr/include|" \
    -i pkgs/tdbc1.1.13/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.7|/usr/lib/itcl4.3.7|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.7/generic|/usr/include|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.7|/usr/include|" \
    -i pkgs/itcl4.3.7/itclConfig.sh

unset SRCDIR

[ "$HARP_RUN_TESTS" != "1" ] || LC_ALL=C.UTF-8 make test

make install
chmod 644 /usr/lib/libtclstub8.6.a
chmod -v u+w /usr/lib/libtcl8.6.so
make install-private-headers
ln -sfv tclsh8.6 /usr/bin/tclsh
mv -v /usr/share/man/man3/{Thread,Tcl_Thread}.3

cd ..
tar -xf ../tcl8.6.18-html.tar.gz --strip-components=1
mkdir -v -p /usr/share/doc/tcl-8.6.18
cp -v -r ./html/* /usr/share/doc/tcl-8.6.18

cd /sources
rm -rf tcl8.6.18
CHROOT

echo "Tcl concluído com sucesso."
