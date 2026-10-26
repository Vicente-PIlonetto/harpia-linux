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
| Módulos 01–100 | ✅ validados na VM |
| Módulos 101–124 | 🟡 implementados, aguardando validação |
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

## Validação atual

O sistema base foi validado incrementalmente até o módulo **100 — Kmod**.

O bloco mais recente concluído foi:

```text
83   Expat
84   Inetutils
85   Less
86   Perl
87   Autoconf
88   Automake
89   OpenSSL
90   Libelf
91   Libffi
92   SQLite
93   mpdecimal
94   Python
95   Flit-Core
96   Packaging
97   Wheel
98   Setuptools
99   Meson
100  Kmod
```

Os módulos **101–124** já possuem scripts implementados e serão validados individualmente na VM antes de qualquer execução em lote.

Próximo módulo:

```text
101 — Coreutils
```

## Correções descobertas em validação real

O teste na VM já revelou e incorporou ajustes importantes:

- `config.site` com detecção de `posix_spawn_*`;
- propagação de `HARP_TIMEZONE` no chroot;
- teste PTY do Expect isolado de `stdin`;
- scripts de chroot sem dependência do `$HOME` preservado por `sudo`;
- proteção explícita contra execução acidental de etapas destrutivas;
- validação correta do código de retorno das suítes de teste;
- suporte correto a módulos com numeração de três dígitos no deploy;
- correções de sintaxe e ShellCheck incorporadas ao CI;
- remontagem dos pseudo-filesystems após reboot antes de continuar o chroot;
- criação de `/etc/resolv.conf` no LFS para permitir resolução DNS durante testes dependentes de rede;
- logs preservados para testes com falhas conhecidas;
- validação individual de cada pacote antes de avançar para o próximo módulo.

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

Na primeira validação de cada módulo, execute-o individualmente.

O projeto prioriza:

- reprodutibilidade;
- validação incremental;
- diagnóstico antes de automação;
- logs preservados;
- proteção de operações destrutivas;
- rollback por snapshot quando necessário.

## Estado dos módulos

```text
01–100    validados na VM
101–124   implementados, aguardando validação
125–165   roadmap reservado
```

### Próximo bloco

```text
101  Coreutils
102  Diffutils
103  Findutils
104  Groff
105  GRUB
106  Gzip
107  IPRoute2
108  Kbd
109  Libpipeline
110  Make
111  Patch
112  Tar
113  Texinfo
114  Vim
115  MarkupSafe
116  Jinja2
117  Systemd
118  D-Bus
119  Man-DB
120  Procps-ng
121  Util-linux
122  E2fsprogs
123  Stripping
124  Cleaning Up
```

Os módulos `123` e `124` são considerados sensíveis.

O módulo `123 — Stripping` exige liberação explícita:

```bash
HARP_ALLOW_STRIP=1
```

O módulo `124 — Cleaning Up` exige:

```bash
HARP_ALLOW_CLEANUP=1
```

Antes dessas etapas, deve existir um snapshot Btrfs válido.

## Estrutura

```text
harpia-linux/
├── assets/
│   └── branding/
├── build/
│   ├── config/
│   ├── phases/
│   ├── roadmap/
│   ├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   └── validate.sh
├── desktop/
├── docs/
├── fly/
├── packages/
├── profiles/
├── reports/
├── scripts/
└── tests/
```

## Roadmap até o primeiro boot

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
```

A numeração está congelada da seguinte forma:

```text
01–124   sistema base LFS

125      configuração geral de rede
126      hostname
127      /etc/hosts
128      dispositivos e módulos
129      relógio do sistema
130      console Linux
131      locale
132      /etc/inputrc
133      /etc/shells
134      configuração systemd

135      /etc/fstab
136      preparar Linux 7.1.8
137      configurar kernel
138      compilar kernel
139      instalar módulos
140      instalar artefatos do kernel

141      preparar EFI System Partition
142      configurar systemd-boot
143      preparar initramfs
144      gerar UKI
145      criar entrada Harpia
146      configurar root Btrfs
147      configurar subvolumes Btrfs
148      snapshots iniciais
149      configurar conta root
150      criar usuário Harpia
151      privilégios administrativos
152      serviço inicial de rede
153      machine-id
154      DNS/resolver
155      timezone final
156      validação final de locale
157      hardening base
158      validação linker/bibliotecas
159      validação de serviços systemd
160      validação kernel/UKI
161      preflight do primeiro boot
162      limpeza final
163      snapshot pré-primeiro-boot
164      desmontar kernfs
165      PRIMEIRO BOOT
```

## Boot da Harpia

A arquitetura de boot planejada da Harpia é:

```text
UEFI
  ↓
systemd-boot
  ↓
UKI
  ↓
Linux
  ↓
Btrfs root
```

O GRUB permanece disponível no sistema base por compatibilidade, ferramentas e possibilidade de recuperação, mas **não é o bootloader principal planejado da Harpia**.

A direção principal continua sendo:

```text
UKI + systemd-boot
```

## Filesystem e recuperação

A Harpia utiliza Btrfs como filesystem principal planejado.

Objetivos:

- root em subvolume;
- snapshots antes de alterações críticas;
- snapshot antes do primeiro boot;
- integração futura com o Fly;
- rollback de sistema;
- separação entre sistema e dados do usuário;
- recuperação sem depender de reinstalação completa.

Operações destrutivas ou de alto impacto devem ser precedidas por snapshot sempre que possível.

## Roadmap pós-primeiro-boot

Após o primeiro boot:

```text
Harpia Base
   ↓
Fly
   ↓
Desktop Base
   ↓
Harpialand / Caelestia / Plasma
   ↓
Btrfs rollback
   ↓
Gerenciamento de pacotes
   ↓
Perfis Desktop / Server
```

A definição inicial está em:

```text
build/roadmap/post-boot-fly.md
```

## Fly — orquestrador de perfis e dotfiles

Após o primeiro boot, a Harpia terá um orquestrador próprio chamado **Fly**.

O Fly será responsável por aplicar e manter:

- perfis;
- dependências;
- serviços;
- temas;
- dotfiles;
- configurações de desktop;
- snapshots;
- rollback.

A arquitetura deve permanecer modular, reexecutável e auditável.

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

O **Harpialand** será a experiência Hyprland oficial da Harpia, baseada em um conjunto próprio de:

- dotfiles;
- temas;
- keybinds;
- scripts;
- integrações.

O **Caelestia** permanecerá como alternativa independente baseada em Hyprland.

O **KDE Plasma** permanecerá como perfil gráfico completo e independente.

Os defaults da distribuição ficarão versionados no sistema e serão aplicados ao usuário pelo Fly sem sobrescrever cegamente todo o `$HOME`.

## Estrutura planejada do desktop

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
```

## Estrutura planejada do Fly

```text
fly/
├── fly.sh
├── lib/
├── stages/
│   ├── 01-dependencies.sh
│   ├── 02-graphics.sh
│   ├── 03-wayland.sh
│   ├── 04-audio.sh
│   ├── 05-desktop.sh
│   ├── 06-dotfiles.sh
│   ├── 07-themes.sh
│   ├── 08-services.sh
│   └── 09-validation.sh
└── profiles/
    ├── harpialand.conf
    ├── caelestia.conf
    └── plasma.conf
```

## Princípios do Fly

O Fly deverá ser:

- **idempotente:** poder ser executado novamente sem quebrar a instalação;
- **modular:** cada etapa separada;
- **reversível:** permitir backup e rollback;
- **integrado ao Btrfs:** snapshots antes de alterações críticas;
- **consciente de alterações do usuário:** não sobrescrever configurações modificadas sem controle;
- **auditável:** alterações rastreáveis;
- **extensível:** permitir novos perfis no futuro.

O sistema deverá distinguir arquivos:

```text
managed
user-modified
system-default
```

Antes de alterações destrutivas, o Fly deverá:

```text
1. criar backup
2. criar snapshot quando aplicável
3. aplicar mudanças
4. validar
5. permitir rollback
```

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

Ele poderá incluir:

- Hyprland;
- Waybar;
- launcher;
- notificações;
- lockscreen;
- idle manager;
- wallpaper;
- terminal padrão;
- Fish;
- temas Harpia;
- keybinds oficiais;
- scripts próprios;
- PipeWire;
- WirePlumber;
- XDG portals;
- XWayland;
- integração com o Fly.

O Harpialand **não será um fork do Hyprland**.

O compositor continuará vindo do projeto upstream.

A Harpia fornecerá a experiência visual, configurações e integrações sobre ele.

### Caelestia

O **Caelestia** será mantido como perfil alternativo sobre Hyprland.

A Harpia não dependerá visualmente dele para existir.

O Fly poderá instalar e configurar suas dependências quando o perfil for escolhido.

### Plasma

O KDE Plasma permanecerá como alternativa completa e independente da pilha Hyprland.

## Filosofia

A Harpia busca equilibrar:

```text
controle
+
automação
+
transparência
+
recuperação
```

O sistema deve automatizar tarefas repetitivas sem esconder do usuário o que está acontecendo.

A filosofia geral é:

> Controle quando importa. Automação quando ajuda. Recuperação quando algo dá errado.

## Contribuindo

Consulte:

```text
CONTRIBUTING.md
SECURITY.md
docs/
```

antes de enviar alterações.

Não envie:

- credenciais;
- chaves privadas;
- tokens;
- IPs pessoais;
- UUIDs de discos;
- logs contendo informações sensíveis.

---

<div align="center">

**Controle quando importa. Automação quando ajuda. Recuperação quando algo dá errado.**

</div>