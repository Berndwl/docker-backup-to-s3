#!/bin/bash

set -e

echo "Job put started: $(date)"

ARCHIVE_DIR="./dump"
rm -rf $ARCHIVE_DIR

FILE_NAME=`date +%m-%d-%Y`.gz
FILE_LOCATION="$ARCHIVE_DIR/$FILE_NAME"

ARCHIVE_COMMAND="--archive=$FILE_NAME --gzip"

if [[ -n "$MONGODB_PARAMS" ]]; then
  ARCHIVE_COMMAND="$MONGODB_PARAMS $ARCHIVE_COMMAND"
fi

echo "Executing $ARCHIVE_COMMAND"
mongodump $ARCHIVE_COMMAND

echo "POSTING to $S3_PATH"
/usr/local/bin/s3cmd put $PARAMS "$FILE_LOCATION" "$S3_PATH"

echo "Job finished: $(date)"

#Remove archive locally
rm -rf $ARCHIVE_DIR
rm $FILE_NAME
