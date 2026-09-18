# Estado atual e evidências

## Relatos recebidos — ainda pendentes de auditoria

- VM Proxmox com Debian trixie mínimo; 4 vCPU e 6 GiB RAM.
- Disco LFS com EFI FAT32, swap e Btrfs; subvolumes `@` e `@snapshots`.
- `LFS=/mnt/lfs`, EFI em `/mnt/lfs/boot/efi`, alvo `x86_64-lfs-linux-gnu`, `MAKEFLAGS=-j4`.
- SSH, sudo, QEMU Guest Agent e Tailscale preparados; montagem e swaps reportados após reboot.
- Binutils Pass 1, GCC Pass 1 e Linux API Headers reportados como concluídos.
- Os scripts estariam em `~/lfs-build/scripts/` na VM.

## Evidência versionada neste repositório

Ainda não há evidência de build, logs sanitizados, scripts importados ou artefatos de teste. Este commit inicial cria apenas estrutura e modelos de documentação.

## Próxima confirmação obrigatória

Quando o acesso à VM retornar, importar uma cópia sanitizada dos scripts e inventariar hashes, versão/edição do livro LFS, fontes usadas e logs relevantes. Não reiniciar a construção nem misturar versões antes dessa comparação.
