<div align="center">

<img src="assets/branding/harpia-logo.png" alt="Harpia Linux logo" width="280">

# Harpia Linux

### Linux sob seu controle.

Uma distribuição Linux experimental construída **do zero com Linux From Scratch**, com foco em transparência, modularidade, recuperação e liberdade de escolha.

**Base atual:** LFS 13.1 · systemd · x86_64  
**Objetivo de boot:** UKI + systemd-boot  
**Perfis planejados:** Server estável · Desktop semirrolling

</div>

---

## O que é a Harpia Linux?

A **Harpia Linux** nasceu de uma ideia simples:

> O sistema deve ajudar o usuário sem esconder dele como as coisas funcionam.

Em vez de começar a partir de outra distribuição pronta, a Harpia está sendo construída sobre o **Linux From Scratch (LFS)**. Isso permite compreender, controlar e documentar cada camada do sistema — da toolchain ao boot, do gerenciador de pacotes ao ambiente gráfico.

A intenção não é criar apenas "mais uma distro", mas uma base Linux que combine:

- controle técnico sem exigir complexidade desnecessária;
- automação sem transformar o sistema em uma caixa-preta;
- segurança sem retirar autonomia do usuário;
- atualizações com caminhos claros de recuperação;
- perfis diferentes para servidor e desktop usando a mesma filosofia.

---

## Filosofia

### Controle pertence ao usuário

A Harpia pode oferecer padrões e automações, mas decisões importantes devem permanecer visíveis e reversíveis.

### Simples para usar, transparente para entender

A interface pode esconder complexidade operacional, mas nunca deve esconder o estado real do sistema.

Arquivos de configuração, logs, decisões de atualização e mecanismos de recuperação devem poder ser inspecionados.

### Automação auditável

Automatizar não significa executar ações invisíveis.

Os processos de build são divididos em módulos pequenos, versionados e verificáveis. Etapas destrutivas ou de alto impacto recebem tratamento explícito.

### Recuperação é parte do sistema

Rollback e snapshots não são considerados recursos extras.

A arquitetura planejada utiliza **Btrfs**, snapshots e mecanismos coordenados de recuperação para que uma atualização com problema não signifique reinstalar o sistema.

### Sem telemetria obrigatória

Diagnósticos e logs são locais por padrão.

Nenhum dado deve ser enviado automaticamente sem conhecimento e escolha do usuário.

### Escolha sem transformar tudo em configuração manual

A Harpia procura equilibrar duas coisas que normalmente entram em conflito:

**liberdade de escolha** e **boa experiência padrão**.

Quando uma escolha técnica não precisa ser exposta ao usuário, a distribuição pode selecionar um padrão seguro. Quando a escolha altera significativamente o comportamento do sistema, ela deve ser explícita e modificável posteriormente.

---

## Por que o nome Harpia?

A **harpia brasileira** representa a identidade visual e conceitual do projeto.

É uma ave forte, precisa e adaptada ao seu ambiente — características que combinam com a proposta de um sistema enxuto, controlável e preparado para diferentes perfis de uso.

---

## Arquitetura planejada

| Área | Direção |
| --- | --- |
| Base | Linux From Scratch 13.1 + systemd |
| Arquitetura inicial | x86_64 |
| ARM64 | Planejado posteriormente |
| Boot | UKI + systemd-boot |
| Filesystem | Btrfs |
| Rede Server | systemd-networkd |
| Rede Desktop | NetworkManager |
| Pacotes | libalpm / pacman + infraestrutura própria |
| Núcleo de ferramentas | Rust |
| Shell de sistema | Bash |
| Shell de usuário Desktop | Fish |
| Containers | Podman + Docker |
| Desktop | KDE Plasma ou Hyprland |
| Compatibilidade X11 | XWayland |
| Acesso remoto | Tailscale + WireGuard |
| Server | canal estável |
| Desktop | modelo semirrolling |

---

## Dois perfis, uma mesma base

### Harpia Server

O perfil Server prioriza:

- baixo consumo de recursos;
- estabilidade;
- kernel de suporte prolongado;
- serviços mínimos;
- administração previsível;
- containers;
- servidores web;
- bancos de dados.

A meta inicial é manter uma instalação base extremamente enxuta.

### Harpia Desktop

O perfil Desktop acrescenta uma experiência moderna sobre a mesma base:

- Wayland;
- KDE Plasma ou Hyprland;
- XWayland;
- Steam e Proton;
- Wine e Lutris;
- GameMode e MangoHud;
- Sunshine e Moonlight;
- toolchains para desenvolvimento.

A proposta é oferecer desempenho e flexibilidade sem transformar o sistema em uma instalação inflada por padrão.

---

## Gerenciamento de pacotes

A direção atual prevê **libalpm/pacman como engine**, com uma camada própria da Harpia sobre ela.

O objetivo não é apenas instalar pacotes. O gerenciador deverá integrar:

- CLI;
- TUI;
- interface gráfica;
- canais de atualização;
- histórico;
- rollback de pacotes;
- integração com snapshots;
- validação de dependências;
- repositórios próprios.

A Harpia pretende separar a estabilidade do Server da evolução mais rápida do Desktop sem manter duas distribuições completamente diferentes.

---

## Estado atual

A Harpia ainda está em desenvolvimento inicial.

O projeto possui documentação, auditoria dos scripts originais da VM e uma nova árvore de build reproduzível em construção.

| Componente | Estado |
| --- | :---: |
| Filosofia e arquitetura | ✅ Definidas |
| Documentação inicial | ✅ |
| Auditoria dos scripts da VM | ✅ |
| Build LFS modular | 🟡 Em desenvolvimento |
| Módulos 01–72 | 🟡 Preparados para teste |
| CI de scripts | 🟡 Inicial |
| Sistema base bootável validado | ⏳ |
| Kernel final | ⏳ |
| UKI / systemd-boot | ⏳ |
| Gerenciador de pacotes | ⏳ |
| Perfil Server | ⏳ |
| Perfil Desktop | ⏳ |
| Instalador | ⏳ |
| ISO pública | ⏳ |

> **Importante:** ainda não existe uma release pronta para uso diário.

---

## Como o build está organizado

Os scripts coletados originalmente da VM são preservados como **evidência histórica**:

```text
scripts/imported/lfs-13.1-systemd/
```

Eles não devem ser alterados.

A implementação revisada vive em:

```text
build/
├── config/
├── phases/
├── scripts/
│   └── lib/
├── build.sh
├── deploy.sh
└── validate.sh
```

Essa separação permite comparar o que foi originalmente executado com a versão corrigida e reproduzível.

---

## Fases atuais do LFS

| Fase | Módulos | Situação |
| --- | ---: | --- |
| Preparação do host | 01–06 | consolidada |
| Cross-toolchain | 07–11 | consolidada |
| Ferramentas temporárias | 12–28 | consolidada |
| Chroot e preparação | 29–40 | consolidada |
| Limpeza temporária | 41 | protegida / manual |
| Helper kernfs | 42 | auxiliar |
| Sistema base | 43–72 | preparado para teste |
| Configuração final | 73+ | próximo estágio |
| Kernel e boot | futuro estágio | pendente |

O módulo `41` é propositalmente protegido porque remove `/tools`.  
O módulo `42` é auxiliar e não participa da execução linear automática.

---

## Segurança e reprodutibilidade

O projeto procura evoluir de um build manual para um processo verificável e reproduzível.

A direção inclui:

- versões fixadas;
- SHA-256 para fontes;
- origem registrada;
- logs de build por módulo;
- guardas antes de operações destrutivas;
- validação de sintaxe;
- ShellCheck;
- testes automatizados;
- runner de CI;
- snapshots antes de etapas críticas.

Scripts históricos não são considerados automaticamente confiáveis apenas porque executaram sem erro.

---

## Estrutura do repositório

```text
harpia-linux/
├── .github/
│   └── workflows/
├── assets/
│   └── branding/
│       └── harpia-logo.png
├── build/
├── docs/
├── packages/
├── profiles/
├── reports/
├── scripts/
├── tests/
├── CONTRIBUTING.md
├── SECURITY.md
└── README.md
```

---

## Testando o build

O ambiente de desenvolvimento atual usa Debian como host.

Depois de clonar o repositório:

```bash
cd harpia-linux/build
./validate.sh
./deploy.sh
```

Listar módulos:

```bash
./build.sh --list
```

Executar uma fase:

```bash
./build.sh --phase cross --execute
```

Executar uma faixa específica:

```bash
./build.sh --from 7 --to 11 --execute
```

Etapas de alto impacto devem ser executadas somente após validação e, preferencialmente, com snapshot da VM.

---

## Roadmap resumido

```text
LFS reproduzível
       ↓
Sistema base bootável
       ↓
Kernel + UKI + systemd-boot
       ↓
Rede e serviços fundamentais
       ↓
Sistema de pacotes
       ↓
Rollback + snapshots
       ↓
Perfil Server
       ↓
Perfil Desktop
       ↓
Instalador
       ↓
Primeira release pública
```

---

## Desenvolvimento

A Harpia está sendo construída de forma incremental.

> Primeiro tornar uma etapa compreensível e reproduzível. Depois automatizá-la.

---

## Contribuindo

Antes de contribuir, consulte:

- [`CONTRIBUTING.md`](CONTRIBUTING.md)
- [`SECURITY.md`](SECURITY.md)
- [`docs/`](docs/)

Não envie credenciais, chaves privadas, IPs pessoais, UUIDs de discos ou logs sem sanitização.

---

## Licença

A licença do código original da Harpia Linux ainda está em definição.

Consulte [`LICENSE-STATUS.md`](LICENSE-STATUS.md) para o estado atual.

---

<div align="center">

### Harpia Linux

**Controle quando importa. Automação quando ajuda. Recuperação quando algo dá errado.**

</div>
