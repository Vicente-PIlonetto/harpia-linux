# Scripts

These are safe Base 0.1 preparation tools, not LFS build automation:

- `preflight.sh`: read-only environment inspection and optional reviewed-value comparison.
- `verify-sources.sh`: verifies already-downloaded sources against a reviewed lock file.
- `check-import.sh`: heuristic scan before importing a sanitized VM-script copy.
- `validate-repository.sh`: checks required repository paths and whitespace errors.

They do not download, compile, mount, chroot, partition, format, change swap or
modify system configuration. No source versions or LFS book edition are encoded
until the actual VM scripts and source records are audited.

Import existing VM scripts only after sanitization and review, following the
[import guide](../docs/pt-BR/importar-scripts-vm.md).
