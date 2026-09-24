#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Ncurses 6.6 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf ncurses-6.6
tar -xf ncurses-6.6.tar.gz
cd ncurses-6.6
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --with-shared \
            --without-debug \
            --without-normal \
            --with-cxx-shared \
            --enable-pc-files \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make DESTDIR="$PWD/dest" install
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i dest/usr/include/curses.h
cp --remove-destination -av dest/* /
for lib in ncurses form panel menu; do
    ln -sfv "lib${lib}w.so" "/usr/lib/lib${lib}.so"
    ln -sfv "${lib}w.pc" "/usr/lib/pkgconfig/${lib}.pc"
done
ln -sfv libncursesw.so /usr/lib/libcurses.so
cp -v -R doc -T /usr/share/doc/ncurses-6.6
cd /sources
rm -rf ncurses-6.6
CHROOT
echo "Ncurses final concluído com sucesso."
