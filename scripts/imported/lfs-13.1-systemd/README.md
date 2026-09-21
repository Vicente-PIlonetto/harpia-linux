# Importação preservada — LFS 13.1-systemd

**Status:** evidência histórica importada da VM em 2026-09-21; não aprovada para execução.

Esta cópia contém os 42 scripts encontrados em `~/lfs-build/scripts/` na VM. O conteúdo foi preservado, exceto pela normalização de quebra de linha final ausente em alguns arquivos pelo processo de patch. `VM-SHA256SUMS` registra os bytes originais da VM e `SHA256SUMS` registra a cópia versionada. O contexto compartilhado observado foi `LFS=/mnt/lfs`; ele é documentado no relatório de auditoria, mas não foi copiado como arquivo operacional.

## Regras

- Não execute estes scripts diretamente.
- Não os trate como implementação validada ou reproduzível.
- Cada alteração futura deve ocorrer em uma cópia revisada, com versão do livro, fontes, hashes, pré-condições, logs e resultado registrados.
- Consulte [o relatório de auditoria](../../../docs/pt-BR/auditoria-scripts-vm.md) antes de trabalhar neles.

`VM-SHA256SUMS` contém os hashes dos arquivos originalmente coletados da VM.
`SHA256SUMS` contém os hashes da cópia versionada após a normalização.
