#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"
echo "Instalando Python 3.14.7 final..."
run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf Python-3.14.7
tar -xf "$(find . -maxdepth 1 -type f -name 'Python-3.14.7.tar.*' | head -n1)"
cd Python-3.14.7
patch -Np1 -i ../Python-3.14.7-openssl_4-1.patch
./configure --prefix=/usr \
            --enable-shared \
            --with-system-expat \
            --enable-optimizations \
            --without-static-libpython
make
[ "$HARP_RUN_TESTS" != "1" ] || make test TESTOPTS="--timeout 120"
make install
cat > /etc/pip.conf <<'EOF'
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
if [ -f ../python-3.14.7-docs-html.tar.bz2 ]; then
    install -v -dm755 /usr/share/doc/python-3.14.7/html
    tar --strip-components=1 --no-same-owner --no-same-permissions \
        -C /usr/share/doc/python-3.14.7/html \
        -xvf ../python-3.14.7-docs-html.tar.bz2
fi
cd /sources
rm -rf Python-3.14.7
CHROOT
echo "Python final concluído com sucesso."
