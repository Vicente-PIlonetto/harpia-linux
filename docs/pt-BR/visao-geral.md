# Visão geral

Harpia Linux é uma distribuição em desenvolvimento, baseada em Linux From Scratch (LFS), cujo primeiro alvo é x86_64. A base aprovada usa systemd, UKI e systemd-boot desde a primeira distribuição própria. Debian é somente o host de construção.

## Perfis planejados

| Perfil | Direção | Kernel | Rede | Meta de RAM ociosa |
| --- | --- | --- | --- | --- |
| Server | estável | LTS | systemd-networkd | 500 MB |
| Desktop | semirrolling | recente | NetworkManager | 1 GB |

As metas de RAM são objetivos de otimização, não garantias. Medições deverão identificar hardware, serviços e ambiente gráfico.

O Desktop pretende oferecer KDE Plasma e Hyprland + Caelestia, sem ambiente pré-selecionado pelo instalador. Wayland é prioritário, com XWayland sob demanda; SDDM, Kitty, Fish, PipeWire e Flatpak estão planejados, não integrados.

## Limites atuais

Não há scripts da VM neste repositório, nem confirmação da edição LFS, versões efetivas, hardening SSH, snapshot Proxmox, boot próprio ou componentes posteriores a Linux API Headers. Não use esta documentação como instrução para retomar a build até a auditoria das fontes reais.
