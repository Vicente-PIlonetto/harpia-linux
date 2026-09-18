#!/usr/bin/env bash
# Verify only previously downloaded files against a reviewed lock file.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: scripts/verify-sources.sh --sources DIR --lock FILE

The lock file is tab-separated: filename, sha256, origin URL, signature state.
Comment and empty lines are ignored. This script does not download sources or
verify signatures; signature verification requires a separately reviewed key.
EOF
}

sources=""
lock=""
while (($#)); do
  case "$1" in
    --sources) sources="@{2:-}"; shift 2 ;;
    --lock) lock="@{2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

[[ -n "${sources}" && -n "${lock}" ]] || die "--sources and --lock are required"
[[ -d "${sources}" ]] || die "sources directory not found: ${sources}"
[[ -f "${lock}" ]] || die "lock file not found: ${lock}"
require_command sha256sum

checked=0
while IFS=$'\t' read -r filename expected_sha256 origin signature_state; do
  [[ -z "${filename}" || "${filename}" == "#"* ]] && continue
  [[ -n "${expected_sha256}" && -n "${origin}" && -n "${signature_state}" ]] ||
    die "invalid lock entry for ${filename}"
  [[ "${expected_sha256}" =~ ^[a-fA-F0-9]{64}$ ]] ||
    die "invalid SHA-256 for ${filename}"
  [[ -f "${sources}/${filename}" ]] || die "missing source: ${filename}"
  actual_sha256="$(sha256sum "${sources}/${filename}" | awk '{print $1}')"
  [[ "${actual_sha256}" == "${expected_sha256}" ]] ||
    die "SHA-256 mismatch: ${filename}"
  printf 'verified: %s (%s)\n' "${filename}" "${signature_state}"
  checked=$((checked + 1))
done < "${lock}"

[[ "${checked}" -gt 0 ]] || die "no reviewed sources in lock file"
note "verified ${checked} source file(s); signature verification is separate"
