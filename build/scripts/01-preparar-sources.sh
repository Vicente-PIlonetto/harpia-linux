#!/bin/bash

set -e

source "$HOME/lfs-build/config.sh"

echo "Preparando diretório de sources em: $LFS/sources"

sudo mkdir -pv "$LFS/sources"
sudo chmod -v a+wt "$LFS/sources"

echo "Diretório sources preparado com sucesso."
