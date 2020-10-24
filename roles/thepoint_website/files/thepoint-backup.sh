#!/bin/sh

set -e

DB_CONTAINER="${1?No DB container specified}"
MEDIA_BUCKET="${2?No media bucket specified}"
BACKUP_BUCKET="${3?No backup bucket specified}"
BACKUP_FILE_DB="${4-thepoint.pgsql}"
BACKUP_FILE_MEDIA="${5-media}"

docker exec "${DB_CONTAINER}" pg_dump -Fc -U thepoint | aws s3 cp - "s3://${BACKUP_BUCKET}/${BACKUP_FILE_DB}"
aws s3 sync "s3://${MEDIA_BUCKET}/" "s3://${BACKUP_BUCKET}/${BACKUP_FILE_MEDIA}/" --quiet --delete
