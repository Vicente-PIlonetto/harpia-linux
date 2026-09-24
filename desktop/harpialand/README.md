# Harpialand

**Harpialand** é o nome do conjunto oficial de dotfiles e integrações Hyprland da Harpia Linux.

## Definição

```text
Harpialand =
    Hyprland
  + Harpia dotfiles
  + Harpia themes
  + Harpia keybinds
  + Harpia services
  + Harpia desktop utilities
  + integração com Fly
```

O projeto não começa como fork do Hyprland. O compositor será mantido upstream e o Harpialand fornecerá a experiência própria da distribuição.

## Estrutura planejada

```text
desktop/harpialand/
├── dotfiles/
│   ├── hypr/
│   ├── waybar/
│   ├── rofi/
│   ├── mako/
│   ├── kitty/
│   └── fish/
├── scripts/
├── services/
├── themes/
├── wallpapers/
└── packages.list
```

## Configuração modular

Os dots do Hyprland devem ser separados por responsabilidade:

```text
hypr/
├── hyprland.conf
├── autostart.conf
├── appearance.conf
├── animations.conf
├── environment.conf
├── input.conf
├── keybinds.conf
├── monitors.conf
├── rules.conf
└── workspaces.conf
```

Configurações pessoais devem poder sobrepor os defaults sem serem destruídas por atualizações do Fly.

## Relação com Caelestia

Caelestia é uma opção alternativa, não uma dependência do Harpialand:

```text
Harpia Desktop
├── Harpialand
│   └── Hyprland + Harpia dots
├── Caelestia
│   └── Hyprland + Caelestia Shell/dots
└── KDE Plasma
```

## Fly

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

O Fly deverá preservar alterações do usuário e oferecer backup/rollback antes de aplicar mudanças relevantes.
