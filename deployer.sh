#!/bin/bash

MEDIA_DIR="${HOME}/apps/compose/media"
ENV="${HOME}/apps/.env"

usage() {
    echo "Usage:"
    echo "  $0 {up|down|stop|start|pull|restart}"
    echo "  $0 <subfolder> {up|down|stop|start|pull|restart}"
    exit 1
}

if [[ $# -eq 1 ]]; then
    # Loop through all subfolders
    ACTION="$1"
    for dir in "$MEDIA_DIR"/*/; do
        [ -d "$dir" ] || continue
        echo "$ACTION $(basename "$dir")"
        (cd "$dir" && docker compose --env-file $ENV  $ACTION)
    done
elif [[ $# -eq 2 ]]; then
    # Run in a specific subfolder
    SUBFOLDER="$1"
    ACTION="$2"
    TARGET="$MEDIA_DIR/$SUBFOLDER"
    if [ -d "$TARGET" ]; then
        echo "$ACTION $(basename "$dir")"
        (cd "$TARGET" && docker compose --env-file $ENV $ACTION)
    else
        echo "Error: Subfolder '$SUBFOLDER' not found in $MEDIA_DIR"
        exit 2
    fi
else
    usage
fi