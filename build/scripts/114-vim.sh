#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/chroot-common.sh"

echo "Instalando Vim 9.2.1025..."

run_chroot <<'CHROOT'
set -e
cd /sources
rm -rf vim-9.2.1025
tar -xf "$(find . -maxdepth 1 -type f -name 'vim-9.2.1025.tar.*' | head -n1)"
cd vim-9.2.1025

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr
make

if [ "$HARP_RUN_TESTS" = "1" ]; then
    echo "Executando testes do Vim..."
    chown -R tester .
    sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak

    set +e
    su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
        &> /sources/vim-9.2.1025-test.log
    test_rc=$?
    set -e

    chown -R root:root .

    if [ "$test_rc" -ne 0 ]; then
        echo "AVISO: suíte do Vim retornou código $test_rc."
        echo "São conhecidas falhas em Test_client_server_stopinsert() e Test_popup_setbuf()."
        echo "Log: /sources/vim-9.2.1025-test.log"
        tail -n 30 /sources/vim-9.2.1025-test.log || true
    fi
fi

make install

ln -sfv vim /usr/bin/vi
for L in /usr/share/man/{,*/}man1/vim.1; do
    [ -e "$L" ] || continue
    ln -sfv vim.1 "$(dirname "$L")/vi.1"
done
ln -sfv ../vim/vim92/doc /usr/share/doc/vim-9.2.1025

cat > /etc/vimrc <<'EOF'
" Begin /etc/vimrc
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1
set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif
" End /etc/vimrc
EOF

cd /sources
rm -rf vim-9.2.1025
CHROOT

echo "Vim concluído com sucesso."
