#!/bin/bash

MEDIA_DIR="${HOME}/apps/compose/media"
ENV="${HOME}/apps/.env"

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
elif [[ -d "$MEDIA_DIR/$1" ]]; then
    SUBFOLDER="$1"
    shift
    if [[ $# -eq 0 ]]; then
        usage
    fi
    run_compose "$MEDIA_DIR/$SUBFOLDER" "$@"
else
    for dir in "$MEDIA_DIR"/*/; do
        [ -d "$dir" ] || continue
        run_compose "$dir" "$@" &
    done
    wait
fi