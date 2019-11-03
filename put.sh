#!/bin/bash

set -e

echo "Job put started: $(date)"

: ${CONTAINER_NAME:?"CONTAINER_NAME env variable is required"}

EXECUTION_COMMAND="mongodump --archive"

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
else
  if [[ -n "$MONGODB_PARAMS" ]]; then
    EXECUTION_COMMAND="$EXECUTION_COMMAND $MONGODB_PARAMS"
  fi

  echo "Executing $EXECUTION_COMMAND"

  docker exec $CONTAINER_NAME sh -c '$EXECUTION_COMMAND' > $DATA_PATH
  /usr/local/bin/s3cmd put $PARAMS "$DATA_PATH" "$S3_PATH"

  echo "Job finished: $(date)"
fi