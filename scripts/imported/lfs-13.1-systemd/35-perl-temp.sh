#!/bin/bash
set -e
source "$HOME/lfs-build/config.sh"


run_chroot() {
    sudo chroot "$LFS" /usr/bin/env -i \
        HOME=/root \
        TERM="${TERM:-xterm}" \
        PS1='(lfs chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin \
        MAKEFLAGS="-j$(nproc)" \
        TESTSUITEFLAGS="-j$(nproc)" \
        /bin/bash --login -c "$1"
}

echo "Iniciando Perl temporário..."

run_chroot '
set -e
cd /sources
rm -rf perl-5.44.0
tar -xf perl-5.44.0.tar.xz
cd perl-5.44.0

sh Configure -des \
             -D prefix=/usr \
             -D vendorprefix=/usr \
             -D useshrplib \
             -D privlib=/usr/lib/perl5/5.44/core_perl \
             -D archlib=/usr/lib/perl5/5.44/core_perl \
             -D sitelib=/usr/lib/perl5/5.44/site_perl \
             -D sitearch=/usr/lib/perl5/5.44/site_perl \
             -D vendorlib=/usr/lib/perl5/5.44/vendor_perl \
             -D vendorarch=/usr/lib/perl5/5.44/vendor_perl
make
make install

cd /sources
rm -rf perl-5.44.0
'

echo "Perl temporário concluído com sucesso."

