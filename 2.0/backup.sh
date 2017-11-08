#!/bin/bash
#
# This script creates a full backup of the mysql database
# and rolls backup files over
#
set -e

# Configuration
BKUP_DIR=${BKUP_DIR:-"/snapshots"}
BKUP_RETENTION=${BKUP_RETENTION:-20}

# Ensure backup directory exists
mkdir -p $BKUP_DIR

# Perform backup
ts=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
tar -zcf $ts.tar.gz /export/
mv /tmp/$ts.sql.gz $BKUP_DIR/

# Keep limited number of backups
ls -1 $BKUP_DIR/*.tar.gz | head -n -${BKUP_RETENTION} | xargs -d '\n' rm -f --
