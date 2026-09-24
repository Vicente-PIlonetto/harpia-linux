# Roadmap congelado até o primeiro boot

A numeração `83–165` está reservada para evitar renumeração e retrabalho.

**Reservado não significa implementado.**

- 83–100: scripts implementados; testar um por vez.
- 101–124: conclusão do Chapter 8, numeração reservada.
- 125–134: configuração do sistema.
- 135–140: fstab e kernel.
- 141–164: boot stack e preflight específicos da Harpia.
- 165: marco do primeiro boot.

As etapas 141–164 dependem de decisões e dados reais do ambiente (ESP, UUIDs, layout Btrfs e UKI). Por isso a numeração está congelada, mas os scripts não são criados prematuramente.


## Depois do módulo 165

O planejamento pós-boot foi separado em:

```text
build/roadmap/post-boot-fly.md
```

Essa fase introduz a Harpia Base pós-boot, o **Fly**, a base gráfica e os perfis Hyprland, Celestia e Plasma.
