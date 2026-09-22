# Harpia Linux

Distribuição experimental baseada em Linux From Scratch, com foco em controle do usuário, reprodutibilidade, recuperação e automação auditável.

## Estado atual

A Base 0.1 possui:

- documentação e decisões arquiteturais versionadas;
- snapshot histórico sanitizado dos scripts da VM em `scripts/imported/lfs-13.1-systemd/`;
- automação oficial em `build/`, atualmente consolidada até o módulo 72;
- separação explícita entre evidência histórica e scripts revisados;
- execução modular por fases;
- preparação para CI de sintaxe Bash e ShellCheck.

Ainda não há release estável, ISO, instalador ou sistema Harpia bootável validado.

## Build oficial

A árvore `build/` contém a versão revisada do fluxo LFS 13.1-systemd.

```text
build/
├── config/
├── phases/
├── scripts/
├── build.sh
├── deploy.sh
└── validate.sh
```

Os scripts importados da VM permanecem preservados e não devem ser alterados.

## Fases atuais

| Fase | Módulos | Estado |
| --- | ---: | --- |
| Host e ambiente | 01-06 | consolidada |
| Cross-toolchain | 07-11 | consolidada |
| Ferramentas temporárias | 12-28 | consolidada |
| Chroot e preparação | 29-40 | consolidada |
| Limpeza temporária | 41 | protegida/manual |
| Helper de desmontagem | 42 | auxiliar |
| Sistema base | 43-72 | consolidada para teste |

Os módulos seguintes tratarão configuração final, systemd, rede, kernel, UKI e systemd-boot.
