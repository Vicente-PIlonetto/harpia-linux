# Roadmap pós-primeiro-boot — Harpia Linux

O módulo 165 continua sendo o marco do primeiro boot.

A partir daí, a Harpia deixa de ser apenas uma base LFS bootável e começa a receber as camadas próprias da distribuição.

## Fase 166+ — Base Harpia

| Módulo | Objetivo |
| ---: | --- |
| 166 | Post-boot baseline |
| 167 | Sistema de perfis |
| 168 | Fly core |
| 169 | Gerenciador de dotfiles |
| 170 | Gerenciador de perfis de pacotes |
| 171 | Detecção de hardware |
| 172 | Desktop base |
| 173 | Base gráfica / DRM / Mesa |
| 174 | Wayland base |
| 175 | Áudio: PipeWire / WirePlumber |
| 176 | XDG / portals |
| 177 | Polkit / sessão / logind |
| 178 | Display manager |

## Fase Harpialand

A partir do módulo 179, a experiência gráfica principal planejada será o **Harpialand**.

Harpialand = Hyprland + dotfiles oficiais da Harpia + integrações próprias.

Objetivos:

- Hyprland funcional;
- XWayland;
- libinput e libxkbcommon;
- configuração Hyprland própria;
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
- integração com PipeWire e portals;
- dotfiles gerenciados pelo Fly.

O Harpialand não será um fork do Hyprland. O compositor continuará vindo do projeto upstream.

## Fase Caelestia

O **Caelestia** será mantido como perfil alternativo e independente do Harpialand.

Ele usa Hyprland como window manager e adiciona sua própria experiência de shell e dotfiles.

```text
harpia-desktop-base
        ├── harpialand
        │     └── Hyprland + Harpia dots
        ├── caelestia
        │     └── Hyprland + Caelestia Shell/dots
        └── plasma
```

O Fly poderá instalar as dependências específicas do Caelestia quando esse perfil for escolhido.

## Fase KDE Plasma

O Plasma será um perfil paralelo e independente da pilha Hyprland:

```text
harpia-desktop-base
        ↓
harpia-plasma
```

## Fly

O **Fly** é o orquestrador da Harpia para instalação, aplicação e manutenção de perfis e dotfiles.

Comandos planejados:

```bash
fly install harpialand
fly install caelestia
fly install plasma

fly apply harpialand
fly status
fly update
fly rollback
```

### Organização planejada

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

### Dotfiles

Os defaults da Harpia deverão ficar fora do `$HOME`, por exemplo:

```text
/usr/share/harpia/dotfiles/
```

O Fly aplica esses arquivos em `~/.config`, `~/.local` e outros destinos apropriados.

O sistema deverá distinguir:

- `managed`;
- `user-modified`;
- `system-default`.

Antes de alterações destrutivas, o Fly deverá:

1. criar backup;
2. opcionalmente criar snapshot Btrfs;
3. aplicar mudanças;
4. validar;
5. permitir rollback se necessário.

A meta é obter a praticidade de um orquestrador de dotfiles sem transformar o ambiente do usuário em uma cópia forçada do repositório.
