#!/usr/bin/env bash
# Local documentation and template validation; no VM or LFS action.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

for path in README.md CONTRIBUTING.md SECURITY.md mkdocs.yml docs/pt-BR docs/en docs/decisions \
  packages profiles/base profiles/server profiles/desktop tests reports .github/ISSUE_TEMPLATE; do
  [[ -e "${REPO_ROOT}/${path}" ]] || die "required path missing: ${path}"
done

require_command git
git -C "${REPO_ROOT}" diff --check
note "required project paths exist and working-tree diff has no whitespace errors"
