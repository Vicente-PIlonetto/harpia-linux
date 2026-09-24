<div align="center">

<img src="assets/branding/harpia-logo.png" alt="Harpia Linux logo" width="280">

# Harpia Linux

### Linux sob seu controle.

Distribuição Linux experimental construída do zero com Linux From Scratch, com foco em transparência, modularidade, recuperação e liberdade de escolha.

**Base atual:** LFS 13.1-systemd · x86_64  
**Boot planejado:** UKI + systemd-boot  
**Filesystem:** Btrfs  
**Perfis planejados:** Server estável · Desktop semirrolling

</div>

---

## Estado atual

A Harpia está sendo construída e validada incrementalmente em VM. Ainda não existe release para uso diário.

| Área | Estado |
| --- | :---: |
| Filosofia e arquitetura | ✅ |
| Scripts históricos preservados | ✅ |
| Módulos 01–71 | ✅ validados na VM |
| Módulo 72 — GCC final | 🟡 em validação |
| Módulos 73–82 | 🟡 implementados |
| Módulos 83–100 | 🟡 implementados, aguardando teste |
| Módulos 101–124 | 📌 numeração reservada |
| Configuração/kernel 125–140 | 📌 roadmap congelado |
| Boot/preflight 141–164 | 📌 roadmap congelado |
| Primeiro boot | 🎯 módulo 165 |

## Meta congelada até o primeiro boot

```text
01–124   sistema base LFS
125–134  configuração do sistema
135–140  fstab + kernel
141–164  boot stack e preparação Harpia
165      PRIMEIRO BOOT
```

A definição detalhada está em [`build/roadmap/first-boot.tsv`](build/roadmap/first-boot.tsv).

> Numeração reservada não significa script implementado. Apenas módulos existentes em `build/scripts/` entram no runtime.

## Correções descobertas em validação real

O teste na VM já revelou e incorporou ajustes importantes:

- `config.site` com detecção de `posix_spawn_*`;
- propagação de `HARP_TIMEZONE` no chroot;
- teste PTY do Expect isolado de `stdin`;
- scripts de chroot sem dependência do `$HOME` preservado por `sudo`.

## Arquitetura planejada

| Área | Direção |
| --- | --- |
| Base | LFS 13.1-systemd |
| Arquitetura inicial | x86_64 |
| ARM64 | futuro |
| Boot | UKI + systemd-boot |
| Filesystem | Btrfs |
| Rede Server | systemd-networkd |
| Rede Desktop | NetworkManager |
| Pacotes | libalpm/pacman + camada própria |
| Shell de sistema | Bash |
| Shell de usuário Desktop | Fish |
| Containers | Podman + Docker |
| Desktop | KDE Plasma ou Hyprland |
| Compatibilidade X11 | XWayland |
| Acesso remoto | Tailscale + WireGuard |

## Build

```bash
cd harpia-linux/build
./validate.sh
./deploy.sh
./build.sh --list
```

Na primeira validação de cada módulo, execute-o individualmente. O projeto prioriza reprodutibilidade e diagnóstico antes de automação em lote.

## Estrutura

```text
harpia-linux/
├── assets/branding/
├── build/
│   ├── phases/
│   ├── roadmap/
│   ├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   └── validate.sh
├── docs/
├── packages/
├── profiles/
├── reports/
├── scripts/
└── tests/
```

## Roadmap

```text
LFS base
   ↓
Configuração
   ↓
Kernel
   ↓
UKI + systemd-boot
   ↓
Primeiro boot
   ↓
Harpia Base pós-boot
   ↓
Fly
   ↓
Desktop Base
   ↓
Harpialand / Caelestia / Plasma
   ↓
Btrfs rollback + gerenciador de pacotes
   ↓
Server / Desktop
```


## Fly — orquestrador de perfis e dotfiles

Após o primeiro boot, a Harpia terá um orquestrador próprio chamado **Fly**.

O Fly será responsável por aplicar e manter perfis de desktop, dependências, serviços, temas e dotfiles de forma modular, reexecutável e auditável.

Exemplos planejados:

```bash
fly install harpialand
fly install caelestia
fly install plasma

fly apply harpialand
fly status
fly update
fly rollback
```

A ideia é separar o sistema base das experiências de desktop:

```text
harpia-base
    ↓
harpia-desktop-base
    ├── harpialand
    │     └── Hyprland + dotfiles oficiais da Harpia
    ├── caelestia
    │     └── Hyprland + Caelestia Shell / dots
    └── plasma
```

O **Harpialand** será a experiência Hyprland oficial da Harpia, baseada em um conjunto próprio de dotfiles, temas, keybinds e integrações.  
O **Caelestia** permanecerá como uma alternativa independente, também baseada em Hyprland, sem ser requisito para o Harpialand.

Os defaults da distribuição ficarão versionados no repositório, e o Fly aplicará esses arquivos ao perfil do usuário sem depender de sobrescrever cegamente todo o `$HOME`.

Estrutura planejada:

```text
desktop/
├── common/
│   ├── dotfiles/
│   ├── services/
│   ├── themes/
│   └── packages/
├── harpialand/
│   ├── dotfiles/
│   │   ├── hypr/
│   │   ├── waybar/
│   │   ├── rofi/
│   │   ├── mako/
│   │   ├── kitty/
│   │   └── fish/
│   ├── scripts/
│   ├── services/
│   ├── themes/
│   └── packages.list
├── caelestia/
│   ├── dotfiles/
│   ├── scripts/
│   └── packages.list
└── plasma/
    ├── dotfiles/
    ├── scripts/
    └── packages.list

fly/
├── fly.sh
├── lib/
├── stages/
└── profiles/
```

Princípios do Fly:

- idempotente: poder ser executado novamente sem quebrar a instalação;
- modular: cada etapa em um script separado;
- reversível: backup e rollback de configurações;
- integrado ao Btrfs: snapshots antes de alterações de alto impacto;
- consciente de arquivos modificados pelo usuário;
- capaz de instalar, aplicar, atualizar e alternar perfis;
- preparado para Harpialand, Caelestia e KDE Plasma.

O comando `fly` será a interface final para o usuário, enquanto `fly.sh` poderá permanecer como engine interna durante o desenvolvimento.

---


## Perfis de desktop planejados

A Harpia Desktop terá três experiências principais:

```text
1. Harpialand
   Hyprland + dotfiles oficiais da Harpia

2. Caelestia
   Hyprland + Caelestia Shell / dots

3. KDE Plasma
```

### Harpialand

O **Harpialand** será o conjunto oficial de dotfiles e integrações Hyprland da Harpia Linux.

Ele poderá incluir, de forma modular:

- configuração Hyprland própria;
- Waybar;
- launcher;
- notificações;
- lockscreen;
- idle manager;
- terminal padrão;
- Fish;
- temas Harpia;
- keybinds oficiais;
- wallpapers;
- scripts e utilitários do desktop;
- integração com o Fly.

O Harpialand não será um fork do Hyprland. Ele será a experiência visual e funcional da Harpia construída sobre o compositor upstream.

### Caelestia

O **Caelestia** será mantido como perfil alternativo sobre Hyprland.

A Harpia não dependerá visualmente do Caelestia para existir. O Fly poderá instalar e configurar a pilha necessária quando esse perfil for escolhido.

### Plasma

O KDE Plasma permanecerá como alternativa completa de desktop, independente da pilha Harpialand/Caelestia.

---
## Contribuindo

Consulte `CONTRIBUTING.md`, `SECURITY.md` e `docs/` antes de enviar alterações.

Não envie credenciais, chaves privadas, IPs pessoais, UUIDs de discos ou logs sem sanitização.

---

<div align="center">

**Controle quando importa. Automação quando ajuda. Recuperação quando algo dá errado.**

</div>
