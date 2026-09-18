#!/usr/bin/env bash
# Read-only LFS environment preflight. It never builds, downloads, mounts or formats.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: scripts/preflight.sh [--expected-env FILE]

Checks the current shell against a reviewed environment file. The expected
environment file is optional and must be created from lfs.env.example only
after the actual VM state and LFS book edition have been audited.

This script is read-only: it does not compile, download, mount, chroot,
partition, alter swap, or change system configuration.
EOF
}

expected_env=""
while (($#)); do
  case "$1" in
    --expected-env) expected_env="@{2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

for command_name in bash uname; do
  require_command "${command_name}"
done

note "host architecture: $(uname -m)"
note "bash version: ${BASH_VERSION}"
note "LFS: ${LFS:-UNSET}"
note "LFS_TGT: ${LFS_TGT:-UNSET}"
note "MAKEFLAGS: ${MAKEFLAGS:-UNSET}"
note "PATH: ${PATH}"

if [[ -n "${expected_env}" ]]; then
  [[ -f "${expected_env}" ]] || die "expected environment file not found: ${expected_env}"
  # shellcheck disable=SC1090
  source "${expected_env}"
  [[ -n "${EXPECTED_LFS:-}" ]] || die "EXPECTED_LFS is absent in ${expected_env}"
  [[ -n "${EXPECTED_LFS_TGT:-}" ]] || die "EXPECTED_LFS_TGT is absent in ${expected_env}"
  [[ "${LFS:-}" == "${EXPECTED_LFS}" ]] || die "LFS does not match reviewed expectation"
  [[ "${LFS_TGT:-}" == "${EXPECTED_LFS_TGT}" ]] || die "LFS_TGT does not match reviewed expectation"
  note "reviewed environment values match"
else
  note "no expected environment supplied; no pass/fail claim for the VM environment"
fi
