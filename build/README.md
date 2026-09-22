# Build oficial da Harpia Linux

Esta árvore consolida o fluxo LFS 13.1-systemd revisado até o módulo 72.

## Preparar runtime na VM

```bash
cd harpia-linux/build
./validate.sh
./deploy.sh
```

Isso cria/atualiza `~/lfs-build`, layout ainda esperado pelos módulos atuais.

## Execução por fase

```bash
./build.sh --phase host --execute
./build.sh --phase cross --execute
./build.sh --phase temporary --execute
./build.sh --phase chroot --execute
```

Depois de validar 29-40:

```bash
HARP_ALLOW_CLEANUP=1 ./build.sh --cleanup --execute
./build.sh --phase base --execute
```

O módulo 42 desmonta kernfs e é auxiliar:

```bash
~/lfs-build/scripts/42-desmontar-kernfs.sh
```

Ele não é chamado pelo master.

## Retomar de um ponto específico

```bash
./build.sh --from 7 --to 11 --execute
```

Use snapshots da VM antes das fases de alto impacto.
