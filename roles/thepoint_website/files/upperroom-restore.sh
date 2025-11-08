#!/bin/sh

set -e

DB_CONTAINER="${1?No DB container specified}"
APP_CONTAINER="${2?No app container specified}"
MEDIA_BUCKET="${3?No media bucket specified}"
BACKUP_BUCKET="${4?No backup bucket specified}"
CACHE_CONTAINER="${5}"
BACKUP_FILE_DB="${BACKUP_FILE_DB-thepoint.pgsql}"
BACKUP_FILE_MEDIA="${BACKUP_FILE_MEDIA-media}"
DB_NAME="${DB_NAME-thepoint}"
DB_USER="${DB_USER-thepoint}"

docker stop "${APP_CONTAINER}"
[ -z "${DB_ONLY}" ] && aws s3 sync "s3://${BACKUP_BUCKET}/${BACKUP_FILE_MEDIA}/" "s3://${MEDIA_BUCKET}/" --delete
docker exec -i "${DB_CONTAINER}" psql -U "${DB_USER}" -d postgres -c "DROP DATABASE ${DB_NAME}"
docker exec -i "${DB_CONTAINER}" psql -U "${DB_USER}" -d postgres -c "CREATE DATABASE ${DB_NAME}"
aws s3 cp "s3://${BACKUP_BUCKET}/${BACKUP_FILE_DB}" - | docker exec -i "${DB_CONTAINER}" pg_restore --no-acl --no-owner -U "${DB_USER}" -d "${DB_NAME}"
[ -n "${CACHE_CONTAINER}" ] && docker exec -t "${CACHE_CONTAINER}" redis-cli FLUSHALL
docker start "${APP_CONTAINER}"
docker exec "${APP_CONTAINER}" upperroom migrate --no-input
