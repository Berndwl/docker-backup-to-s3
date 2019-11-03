#!/bin/bash

set -e

echo "Job put started: $(date)"

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
else
  if [[ -n "$MONGODB_USER"  &&  -n "$MONGODB_PASSWORD" &&  -n "$MONGODB_AUTHDB" ]]; then
    EXECUTION_COMMAND="mongodump -u $MONGODB_USER -p $MONGODB_PASSWORD --authenticationDatabase $MONGODB_AUTHDB --archive"
  else
  	EXECUTION_COMMAND="mongodump --archive"
  fi
  if [[ -n "$BACKUP_DB" &&  -n "$BACKUP_COL" ]]; then
      EXECUTION_COMMAND="$EXECUTION_COMMAND --db $BACKUP_DB --collection $BACKUP_COL"
  elif [[ -n "$BACKUP_DB" &&  -z "$BACKUP_COL" ]]; then
        EXECUTION_COMMAND="$EXECUTION_COMMAND --db $BACKUP_DB"
  fi

  echo "Executing $EXECUTION_COMMAND"

  docker exec mongo sh -c $EXECUTION_COMMAND > $DATA_PATH
  /usr/local/bin/s3cmd put $PARAMS "$DATA_PATH" "$S3_PATH"

  echo "Job finished: $(date)"
fi