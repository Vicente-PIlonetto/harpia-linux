# Harpia Linux

Distribuição experimental construída a partir de [Linux From Scratch](https://www.linuxfromscratch.org/), com systemd, foco inicial em x86_64 e controle explícito do usuário.

> **Estado:** planejamento e documentação inicial. Não há imagem, instalador, gerenciador de pacotes próprio ou release publicado.

## Princípios

- Sem telemetria ou envio automático de diagnósticos.
- Configurações, automações e decisões essenciais sob controle do usuário.
- Segurança, recuperação e rollback devem ser testados, não apenas documentados.
- Logs permanecem locais e são exportáveis pelo usuário.

## Documentação

- [Português (Brasil)](docs/pt-BR/visao-geral.md)
- [English](docs/en/overview.md)
- [Decisões e pendências](docs/decisions/README.md)
- [Roadmap e critérios de lançamento](docs/pt-BR/roadmap.md)
- [Como importar scripts da VM com segurança](docs/pt-BR/importar-scripts-vm.md)

O nome e a identidade visual ainda dependem de verificação de disponibilidade. O repositório não possui licença para o código original neste momento; veja [LICENSE-STATUS](LICENSE-STATUS.md).
