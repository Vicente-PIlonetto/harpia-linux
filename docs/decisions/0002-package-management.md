# ADR-0002: Package-management direction

- **Status:** approved direction; not implemented.
- **Decision:** use libalpm/pacman as engine, own repositories and recipes, and a Rust core with progressive CLI, TUI and Qt/QML GUI.
- **Constraints:** no presumed Arch/AUR package compatibility. External sources need explicit origin and key approval; invalid signatures are blocked. Unsigned packages require a manual per-install exception.
- **Follow-up:** specify package format, trust roots, database schema, sandboxing, rollback coordination and UX transaction confirmation.
