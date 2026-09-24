#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Perl 5.44.0 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf perl-5.44.0
tar -xf "$(find . -maxdepth 1 -type f -name 'perl-5.44.0.tar.*' | head -n1)"
cd perl-5.44.0
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des \
    -D prefix=/usr \
    -D vendorprefix=/usr \
    -D privlib=/usr/lib/perl5/5.44/core_perl \
    -D archlib=/usr/lib/perl5/5.44/core_perl \
    -D sitelib=/usr/lib/perl5/5.44/site_perl \
    -D sitearch=/usr/lib/perl5/5.44/site_perl \
    -D vendorlib=/usr/lib/perl5/5.44/vendor_perl \
    -D vendorarch=/usr/lib/perl5/5.44/vendor_perl \
    -D man1dir=/usr/share/man/man1 \
    -D man3dir=/usr/share/man/man3 \
    -D pager="/usr/bin/less -isR" \
    -D useshrplib \
    -D usethreads
make
[ "$HARP_RUN_TESTS" != "1" ] || TEST_JOBS="${HARP_JOBS:-1}" make test_harness
make install
unset BUILD_ZLIB BUILD_BZIP2
cd /sources
rm -rf perl-5.44.0
CHROOT
echo "Perl final concluído com sucesso."
