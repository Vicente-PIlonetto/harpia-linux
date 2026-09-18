#!/usr/bin/env bash
# Detect review-sensitive material before committing a copy of VM scripts.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: scripts/check-import.sh PATH

Scans a proposed import for likely secrets and local infrastructure identifiers.
It does not alter files. A clean result is not proof that sensitive data is absent;
review each file before committing.
EOF
}

[[ $# -eq 1 ]] || { usage >&2; exit 2; }
target="$1"
[[ -e "${target}" ]] || die "path not found: ${target}"
require_command rg

pattern='BEGIN (RSA |OPENSSH |EC )?PRIVATE KEY|gh[pousr]_[A-Za-z0-9_]+|password[[:space:]]*[:=]|token[[:space:]]*[:=]|api[_-]?key[[:space:]]*[:=]|[0-9a-fA-F]{8}-[0-9a-fA-F-]{27,}'
if rg -n -i --hidden --glob '!.git' --glob '!*.lock' "${pattern}" "${target}"; then
  die "review-sensitive matches found; sanitize or explicitly justify before import"
fi
note "no heuristic matches found; manual review is still required"
