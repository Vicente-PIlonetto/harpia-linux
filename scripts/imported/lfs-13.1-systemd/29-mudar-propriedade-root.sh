#!/bin/bash
set -e
source "$HOME/lfs-build/config.sh"

echo "Transferindo propriedade da árvore LFS para root..."

sudo chown --from lfs -R root:root "$LFS"/{usr,var,etc,tools}

case "$(uname -m)" in
    x86_64)
        sudo chown --from lfs -R root:root "$LFS/lib64"
    ;;
esac

echo "Propriedade ajustada com sucesso."

