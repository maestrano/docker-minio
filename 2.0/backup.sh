#!/bin/sh
#
# This script creates a full backup of the minio object store
# and rollover the backup files 
#
set -e

# Configuration
BKUP_DIR=${BKUP_DIR:-"/snapshots"}
BKUP_RETENTION=${BKUP_RETENTION:-20}

# Ensure backup directory exists
mkdir -p $BKUP_DIR

# Perform backup
cd /tmp
ts=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
tar -zcf $ts.tar.gz /export/
mv /tmp/$ts.tar.gz $BKUP_DIR/

# Keep limited number of backups
ls -1 $BKUP_DIR/*.tar.gz | head -n -${BKUP_RETENTION} | xargs rm -f --
