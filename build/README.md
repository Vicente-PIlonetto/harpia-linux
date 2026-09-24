# Build oficial da Harpia Linux

## Estado

- 01–71: validados incrementalmente na VM.
- 72: GCC final em validação.
- 73–82: implementados e preparados para teste.
- 83–100: implementados nesta atualização e aguardando teste.
- 101–165: numeração congelada no roadmap, ainda não executável.

Roadmap:

```text
build/roadmap/first-boot.tsv
```

## Atualizar runtime

```bash
cd ~/harpia-linux/build
./validate.sh
./deploy.sh
```

## Teste incremental

Na primeira passagem, execute um módulo por vez. Exemplo:

```bash
HOME=/home/viko HARP_RUN_TESTS=1 HARP_JOBS=8 \
~/lfs-build/scripts/83-expat.sh
```

A fase `base-next` existe somente para uso depois da validação individual:

```bash
HARP_JOBS=8 ./build.sh --phase base-next --execute
```
