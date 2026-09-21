# Auditoria inicial dos scripts da VM

**Data da coleta:** 2026-09-21  
**Origem:** diretório `~/lfs-build/scripts/` da VM de build  
**Estado:** inventário e revisão estática iniciais concluídos; execução e reprodutibilidade permanecem pendentes.

## Evidências coletadas

- 42 arquivos de script foram coletados e preservados em [scripts/imported/lfs-13.1-systemd](../../scripts/imported/lfs-13.1-systemd/).
- Todos os arquivos com extensão `.sh` passaram em `bash -n`.
- O `config.sh` compartilhado continha somente `export LFS=/mnt/lfs`.
- A inspeção por padrões de segredos não encontrou chaves privadas, tokens, senhas ou IPs externos. Há `127.0.0.1 localhost $(hostname)` em `32-arquivos-essenciais.sh`; é uma entrada local de hosts, não evidência de IP pessoal.
- Os hashes dos bytes coletados na VM estão em [VM-SHA256SUMS](../../scripts/imported/lfs-13.1-systemd/VM-SHA256SUMS). A cópia importada normalizou a quebra de linha final ausente em alguns arquivos; seus hashes versionados estão em [SHA256SUMS](../../scripts/imported/lfs-13.1-systemd/SHA256SUMS).

## Sequência observada

1. Preparação de `$LFS/sources`, download e verificação por MD5.
2. Layout inicial, usuário `lfs` e ambiente de compilação.
3. Binutils Pass 1, GCC Pass 1 e Linux API Headers.
4. Glibc Pass 1, libstdc++ e ferramentas temporárias.
5. Binutils/GCC Pass 2, mudança de propriedade, montagem de kernfs e chroot.
6. Componentes temporários dentro do chroot e limpeza.

As versões declaradas estão alinhadas em grande parte à linha LFS 13.1-systemd, incluindo Binutils 2.47, GCC 16.2.0, Glibc 2.44 e Linux 7.1.8. A versão estável 13.1-systemd foi publicada em 2026-09-01; o livro atual também expõe revisões posteriores, portanto as fontes precisam ser fixadas antes de uma nova execução. [Livro LFS systemd atual](https://www.linuxfromscratch.org/lfs/view/systemd/), [lançamento 13.1](https://linuxfromscratch.org/news.html).

## Pontos que bloqueiam execução futura

- `02-baixar-sources.sh` usa um endpoint móvel (`stable-systemd`) e não fixa o arquivo de fontes recuperado. É necessário versionar URL, hash do manifesto, hashes fortes e estado de assinatura.
- `03-Verificar_sources.sh` verifica somente MD5. Isso preserva o procedimento histórico, mas não satisfaz a política planejada de verificação forte e assinaturas.
- Há operações destrutivas ou de alto impacto: `rm -rf`, `sudo`, `chown -R`, mounts, unmounts e chroot. Elas devem ter guardas de caminho, confirmação explícita e logs antes de serem usadas novamente.
- O script 05 tem shebang `#!/bin//bash`; ele funciona em sistemas usuais, mas deve ser normalizado numa cópia revisada.
- Alguns scripts imprimem sucesso após a sequência, mas não registram versão, hashes, testes ou artefatos. Uma saída sem erro não é evidência suficiente de conclusão.
- O script 32 altera `/etc/passwd`, `/etc/group` e `/etc/hosts` dentro do chroot; requer comparação linha a linha com a edição LFS que será fixada.
- O script 41 remove conteúdo e `/tools`; só pode ser executado após uma validação completa do estágio e do estado de recuperação.

## Próximos passos

1. Criar cópias revisadas, não modificar a evidência importada.
2. Fixar uma única revisão do livro LFS 13.1-systemd e obter manifestos de fontes verificáveis.
3. Criar um lockfile com SHA-256, origem, assinatura e licença de cada fonte.
4. Adicionar pré-condições e guardas de segurança para cada script de alto impacto.
5. Confirmar na VM, por logs e estado de filesystem, até qual etapa foi realmente concluída.
6. Executar somente a próxima etapa aprovada, com log sanitizado e resultado registrado.
