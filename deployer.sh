#!/bin/bash

APPS_DIR="${HOME}/apps"
COMPOSE_DIR="$APPS_DIR/compose"
ENV="$APPS_DIR/.env"

usage() {
    echo "Usage:"
    echo "  $0 {compose-args...}            # Run for all subfolders"
    echo "  $0 <subfolder> {compose-args...} # Run for specific subfolder"
    exit 1
}

run_compose() {
    local dir="$1"
    shift
    local args=("$@")
    local dirName
    dirName=$(basename "$dir")
    echo "$dirName: docker compose ${args[*]}"
    (cd "$dir" && docker compose --env-file "$ENV" "${args[@]}")
}

if [[ $# -eq 0 ]]; then
    usage
elif [[ -d "$COMPOSE_DIR/$1" ]]; then
    TARGET="$COMPOSE_DIR/$1"
    shift
    if [[ $# -eq 0 ]]; then
        usage
    fi
    # Find subfolders (depth 1, exclude . itself)
    subdirs=($(find "$TARGET" -mindepth 1 -maxdepth 1 -type d))
    if [[ ${#subdirs[@]} -gt 0 ]]; then
        for dir in "${subdirs[@]}"; do
            run_compose "$dir" "$@" &
        done
        wait
    else
        run_compose "$TARGET" "$@"
    fi
else
    # Find all directories containing a compose.yml in COMPOSE_DIR or its subfolders
    compose_dirs=($(find "$COMPOSE_DIR" -type f -name 'compose.yml' -exec dirname {} \; | sort -u))
    for dir in "${compose_dirs[@]}"; do
        run_compose "$dir" "$@" &
    done
    wait
fi