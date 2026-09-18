# ADR-0001: Base with systemd, UKI and systemd-boot

- **Status:** approved architecture; not implemented.
- **Decision:** use LFS with systemd, x86_64 first, and UKI + systemd-boot from the first proprietary distribution build.
- **Consequences:** EFI, UKIs, package database and snapshots require coordinated recovery testing. A Btrfs snapshot alone is not considered EFI recovery.
- **Follow-up:** document signing, Secure Boot enrollment/recovery, UKI lifecycle and rollback behavior with real tests.
