# Roadmap e critérios de lançamento

## Progresso mensurável proposto

O valor histórico de 10% não é auditado. Para acompanhamento futuro, usar pesos por entrega e somente marcar itens com evidência versionada:

| Marco | Peso |
| --- | ---: |
| Base 0.1: importação e auditoria de scripts/fontes | 15% |
| Base 0.1: toolchain, chroot, base e boot | 20% |
| Base 0.1: pacotes, recuperação e imagem VM | 15% |
| Alpha 0.2: perfis e componentes iniciais | 15% |
| Alpha 0.2: interfaces, atualização e instaladores | 10% |
| 1.0: segurança, recovery, hardware e reprodutibilidade | 20% |

Mudanças de escopo devem registrar impacto nos pesos. A cada 10% consolidado, publicar o [modelo de relatório](../../reports/README.md) em Markdown e PDF após revisão de dados sensíveis.

## Bloqueios de lançamento

- Duas builds limpas independentes com pacotes byte a byte idênticos; assinaturas verificadas separadamente.
- Instalação, atualização, remoção, boot em VM, rollback e recuperação validados.
- Testes de componentes comuns e exclusivos nos perfis corretos.
- Aprovação no Dell Vostro 3510 e desktop i5-12400F/RX 7600, incluindo rede, áudio, gráficos e dual boot.
- Para 1.0: documentação PT-BR/EN completa e política de suporte publicada.

Imagens finais byte a byte idênticas não são exigência inicial. Snapshot Btrfs não é assumido como cobertura automática da EFI.
