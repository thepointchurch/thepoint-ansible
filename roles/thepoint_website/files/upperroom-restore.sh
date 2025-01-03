#!/bin/sh

set -e

DB_CONTAINER="${1?No DB container specified}"
APP_CONTAINER="${2?No app container specified}"
MEDIA_BUCKET="${3?No media bucket specified}"
BACKUP_BUCKET="${4?No backup bucket specified}"
BACKUP_FILE_DB="${5-thepoint.pgsql}"
BACKUP_FILE_MEDIA="${6-media}"
CACHE_CONTAINER="${7}"

docker stop "${APP_CONTAINER}"
aws s3 sync "s3://${BACKUP_BUCKET}/${BACKUP_FILE_MEDIA}/" "s3://${MEDIA_BUCKET}/" --delete
docker exec -i "${DB_CONTAINER}" psql -U thepoint -d postgres -c 'DROP DATABASE thepoint'
docker exec -i "${DB_CONTAINER}" psql -U thepoint -d postgres -c 'CREATE DATABASE thepoint'
aws s3 cp "s3://${BACKUP_BUCKET}/${BACKUP_FILE_DB}" - | docker exec -i "${DB_CONTAINER}" pg_restore --no-acl --no-owner -U thepoint -d thepoint
if [ -n "${CACHE_CONTAINER}" ]; then
    docker exec -t "${CACHE_CONTAINER}" redis-cli FLUSHALL
fi
docker start "${APP_CONTAINER}"
docker exec "${APP_CONTAINER}" upperroom migrate --no-input
