#!/bin/bash

set -e

	source "$HOME/lfs-build/config.sh"

	echo "A preparar o diretorio de Sources em: $LFS/sources"

	sudo mkdir -pv "$LFS/sources"
	sudo chmod -v a+wt "$LFS/sources"

	echo "Diretorio de sources preparado com sucesso"



