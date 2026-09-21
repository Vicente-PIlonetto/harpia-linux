#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Verificando integridade dos soucers"

cd "$LFS/sources"

md5sum -c md5sums

echo "Todos os arquivos foram verificados com sucesso Chefe!" #saco isso



