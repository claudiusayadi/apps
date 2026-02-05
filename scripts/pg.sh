#!/bin/bash

BACKUP_DIR="/home/dovely/apps/backups/pg"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
MAX_BACKUPS=2

mkdir -p "$BACKUP_DIR"

# Back up all databases
docker exec pg pg_dumpall -U postgres | gzip > "$BACKUP_DIR/backup_$TIMESTAMP.sql.gz"

# Keep only the 2 most recent backups
ls -t "$BACKUP_DIR"/backup_*.sql.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm

echo "Backup completed: backup_$TIMESTAMP.sql.gz"

   0 12 * * * /home/dovely/apps/scripts/pg.sh >> /home/dovely/apps/backups/logs/pg.log 2>&1