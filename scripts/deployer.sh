#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APPS_DIR="$ROOT_DIR/apps"

if [[ -z "${ENV_FILE:-}" && -f "$ROOT_DIR/.env" ]]; then
  # Load ENV_FILE from .env if present.
  set -a
  # shellcheck disable=SC1091
  source "$ROOT_DIR/.env"
  set +a
fi

if [[ -z "${ENV_FILE:-}" ]]; then
  ENV_FILE="$ROOT_DIR/.env"
fi

usage() {
  cat <<'USAGE'
Usage:
  bash scripts/deployer.sh [name] <up|down>

Examples:
  bash scripts/deployer.sh up
  bash scripts/deployer.sh pg up
  ENV_FILE=/path/to/.env bash scripts/deployer.sh pg down
USAGE
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

if [[ $# -eq 1 ]]; then
  action="$1"
  name_filter=""
else
  name_filter="$1"
  action="$2"
fi

if [[ "$action" != "up" && "$action" != "down" ]]; then
  echo "Unsupported action: $action" >&2
  usage
  exit 1
fi

mapfile -t compose_files < <(find "$APPS_DIR" -type f -name compose.yml | sort)

if [[ ${#compose_files[@]} -eq 0 ]]; then
  echo "No compose.yml files found under $APPS_DIR" >&2
  exit 1
fi

extract_name() {
  local file="$1"
  awk -F: '/^[[:space:]]*name:[[:space:]]*/ {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); gsub(/["\047]/, "", $2); print $2; exit}' "$file"
}

run_compose() {
  local file="$1"
  if [[ "$action" == "up" ]]; then
    docker compose --env-file "$ENV_FILE" -f "$file" up -d --remove-orphans
  else
    docker compose --env-file "$ENV_FILE" -f "$file" down --remove-orphans
  fi
}

if [[ -n "$name_filter" ]]; then
  for file in "${compose_files[@]}"; do
    name="$(extract_name "$file")"
    if [[ -n "$name" && "$name" == "$name_filter" ]]; then
      run_compose "$file"
      exit 0
    fi
  done

  echo "Unknown name: $name_filter" >&2
  echo "Available names:" >&2
  for file in "${compose_files[@]}"; do
    name="$(extract_name "$file")"
    if [[ -n "$name" ]]; then
      echo "  $name" >&2
    fi
  done
  exit 1
fi

for file in "${compose_files[@]}"; do
  run_compose "$file"
done
