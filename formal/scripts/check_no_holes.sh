#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if rg --glob '*.lean' --glob '!.lake/**' \
  '(^|[^[:alnum:]_])(sorry|admit|axiom)([^[:alnum:]_]|$)|set_option[[:space:]]+autoImplicit[[:space:]]+true' \
  "$project_dir"; then
  echo "proof-hole gate failed" >&2
  exit 1
fi

echo "proof-hole gate passed"
