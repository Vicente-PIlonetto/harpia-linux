#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.sh"

echo "Iniciando M4..."

sudo -u lfs bash -c '
source /home/lfs/.bashrc

cd "$LFS/sources"
rm -rf m4-1.4.21
tar -xf m4-1.4.21.tar.xz
cd m4-1.4.21

./configure \
    --prefix=/usr \
    --host="$LFS_TGT" \
    --build=$(build-aux/config.guess)

make
make DESTDIR="$LFS" install

mkdir -pv "$LFS/usr/share"
cat > "$LFS/usr/share/config.site" <<EOF
ac_cv_func_posix_spawn_file_actions_addchdir=yes
ac_cv_func_posix_spawn_file_actions_addfchdir=yes
EOF

cd "$LFS/sources"
rm -rf m4-1.4.21
'

echo "M4 concluído com sucesso."
