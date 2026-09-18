#!/usr/bin/env bash
# Shared helpers for Harpia Linux repository checks. No build action lives here.

set -o errexit
set -o nounset
set -o pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

note() {
  printf 'note: %s\n' "$*"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}
