# Harpia Linux

> Uma distribuição experimental baseada em [Linux From Scratch](https://www.linuxfromscratch.org/), pensada para que o usuário mantenha controle explícito do sistema, das automações e da recuperação.

| Estado | Plataforma inicial | Base aprovada |
| --- | --- | --- |
| Planejamento e automação de auditoria | x86_64 | LFS + systemd + UKI + systemd-boot |

## O que existe hoje

Este repositório contém a estrutura documental inicial e ferramentas seguras de auditoria da Base 0.1. **Não há imagem, instalador, release, sistema base completo ou gerenciador de pacotes implementado.**

O avanço da VM de build foi relatado, mas ainda será auditado a partir dos scripts, logs sanitizados, hashes e versões realmente usados. Consulte o [estado atual](docs/pt-BR/estado-atual.md) antes de considerar qualquer etapa do LFS como confirmada.

## Princípios

- Controle do usuário sobre personalização, automações e decisões importantes.
- Sem telemetria ou envio automático de diagnósticos.
- Logs locais e exportáveis pelo usuário.
- Segurança, atualização, recuperação e rollback precisam ser testados.
- Padrões simples, com escolhas explícitas quando houver impacto relevante.

## Direção técnica

| Área | Direção aprovada | Situação |
| --- | --- | --- |
| Base | LFS com systemd; Debian apenas como host de build | planejada |
| Boot | UKI e systemd-boot | planejado |
| Perfis | Server estável e Desktop semirrolling | planejados |
| Pacotes | libalpm/pacman, repositórios próprios e núcleo Rust | planejado |
| Desktop | KDE Plasma ou Hyprland + Caelestia | planejado |
| Recuperação | Btrfs, rollback coordenado, backups opcionais | a validar |

## Comece por aqui

- [Visão geral em português](docs/pt-BR/visao-geral.md) · [English overview](docs/en/overview.md)
- [Estado atual: relatos versus evidências](docs/pt-BR/estado-atual.md)
- [Roadmap e critérios de lançamento](docs/pt-BR/roadmap.md)
- [Matriz de testes](docs/pt-BR/matriz-testes.md)
- [Decisões e pendências técnicas](docs/decisions/README.md)
- [Importação segura dos scripts da VM](docs/pt-BR/importar-scripts-vm.md)

## Base 0.1: ferramentas disponíveis

Os scripts em [`scripts/`](scripts/README.md) são deliberadamente não destrutivos. Eles ajudam a validar o repositório, revisar uma importação de scripts da VM, inspecionar o ambiente e verificar fontes já baixadas contra um lockfile revisado. Não baixam, compilam, montam, formatam ou alteram a VM.

## Contribuição e segurança

Leia [CONTRIBUTING.md](CONTRIBUTING.md) antes de abrir uma alteração. Não inclua credenciais, chaves privadas, IPs pessoais, UUIDs de disco ou logs sem revisão. Vulnerabilidades não devem ser abertas em issues públicas; o canal privado de reporte ainda precisa ser definido em [SECURITY.md](SECURITY.md).

## Licença e identidade

O nome e a identidade visual ainda dependem de verificação de disponibilidade. Nenhuma licença foi escolhida para o código original; um repositório público não equivale a uma concessão de licença open source. Veja [LICENSE-STATUS.md](LICENSE-STATUS.md).
