#!/bin/bash

set -e

: ${S3_PATH:?"S3_PATH env variable is required"}
FILE_NAME=`date +%m-%d-%Y`.archive
export DATA_PATH="${DATA_PATH:-/data/}$FILE_NAME"
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ -n "$ACCESS_KEY"  &&  -n "$SECRET_KEY" ]]; then
    echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
    echo "secret_key=$SECRET_KEY" >> /root/.s3cfg
else
	${ACCESS_KEY:?"No ACCESS_KEY env variable found"}
	${SECRET_KEY:?"No SECRET_KEY env variable found"}
fi
if [[ -n "$HOST_BASE" && -n "$HOST_BUCKET" ]]; then
    echo "host_base=$HOST_BUCKET" >> /root/.s3cfg
    echo "host_bucket=%(bucket)$HOST_BASE" >> /root/.s3cfg
else
	${HOST_BASE:?"No HOST_BASE env variable found"}
	${HOST_BUCKET:?"No HOST_BUCKET env variable found"}
fi


LOGFIFO='/var/log/cron.fifo'
if [[ ! -e "$LOGFIFO" ]]; then
    mkfifo "$LOGFIFO"
fi
CRON_ENV="PARAMS='$PARAMS'"
CRON_ENV="$CRON_ENV\nDATA_PATH='$DATA_PATH'"
CRON_ENV="$CRON_ENV\nS3_PATH='$S3_PATH'"
CRON_ENV="$CRON_ENV\nCONTAINER_NAME='$CONTAINER_NAME'"
CRON_ENV="$CRON_ENV\nMONGODB_PARAMS='$MONGODB_PARAMS'"
echo -e "$CRON_ENV\n$CRON_SCHEDULE /put.sh > $LOGFIFO 2>&1" | crontab -
crontab -l
cron
tail -f "$LOGFIFO"

