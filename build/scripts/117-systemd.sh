#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Systemd 261.2..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf systemd-261.2
tar -xf "$(find . -maxdepth 1 -type f -name 'systemd-261.2.tar.*' | head -n1)"
cd systemd-261.2

sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in

mkdir -p build
cd build

meson setup ..                \
      --prefix=/usr           \
      --buildtype=release     \
      -D default-dnssec=no    \
      -D firstboot=false      \
      -D install-tests=false  \
      -D ldconfig=false       \
      -D sysusers=false       \
      -D rpmmacrosdir=no      \
      -D homed=disabled       \
      -D man=disabled         \
      -D mode=release         \
      -D pamconfdir=no        \
      -D dev-kvm-mode=0660    \
      -D nobody-group=nogroup \
      -D sysupdate=disabled   \
      -D ukify=disabled       \
      -D docdir=/usr/share/doc/systemd-261.2

ninja

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo 'NAME="Harpia Linux"' > /etc/os-release
    echo "Executando testes do Systemd em namespace de montagem separado..."
    echo "OBS: alguns testes são conhecidos por falhar no chroot LFS."

    set +e
    unshare -m ninja test 2>&1 | tee /sources/systemd-261.2-check.log
    test_rc=${PIPESTATUS[0]}
    set -e

    if [ "$test_rc" -ne 0 ]; then
        echo
        echo "AVISO: suíte do Systemd retornou código $test_rc."
        echo "Falhas conhecidas incluem test-namespace, test-chase e test-systemd-tmpfiles."
        echo "Log: /sources/systemd-261.2-check.log"
    fi
fi

ninja install

tar -xf ../../systemd-man-pages-261.2.tar.xz \
    --no-same-owner --strip-components=1 \
    -C /usr/share/man

systemd-machine-id-setup
systemctl preset-all

cd /sources
rm -rf systemd-261.2
CHROOT

echo "Systemd concluído com sucesso."
