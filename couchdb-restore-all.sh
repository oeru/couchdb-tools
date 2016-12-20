#!/bin/bash
# Copyright 2016 OER Foundation
# Author: Dave Lane <dave@oerfoundation.org>
# see LICENSE for terms of reuse

# This script will create local JSON exports (suitable for re-importing) for each database in
# a couchdb instance. These files, placed in a dated directory within the designated backup directory
# will have a filename in the form dbname-backup-date_time.json

# read in config info, from the config
# file provided, or, if none is provided
# from the default file...
BASE=`basename -s .sh $0`
CONF=./${BASE}.conf

if test -r $CONF ; then
    . $CONF
    echo "Reading config file: $CONF"
else
    echo "Config file $CONF does not exist!"
    exit 1
fi

# standard commands
CURL=`which curl`

# Select the backup to restore
echo "Please select a backup to restore from the following dated backups"
BUS=`find $BUDIR -name "dbnames.txt" -exec dirname {} \;`
select BU in $BUS;
do
  test -n "$BU" && break
  echo ">>> Invalid Selection"
  exit 1
done
# if we get here, a $BU has been selected
echo "Restoring from $BU"

# Get the databases
if [ -f "$BU/dbnames.txt" ]; then
    DBS=`cat $BU/dbnames.txt`
    EXISTING=`$CURL -X GET -H "Content-Type:application/json" ${HOST}:${PORT}/_all_dbs`

    for DB in $DBS
    do
        if [[ ! "$EXISTING" = *"\"${DB}\""* ]]; then
            echo "creating $DB"
            $CURL -X PUT http://${USER}:${PW}@${HOST}:${PORT}/${DB}
            echo "restoring database $DB"
            FILES=( ${BU}/${DB}-back-*.json )
            FILE=${FILES[-1]}
            $CURL -d @${FILE} -X POST http://${USER}:${PW}@${HOST}:${PORT}/${DB}/_bulk_docs -H "Content-Type:application/json"
        else
            echo "$DB already exists, skipping"
        fi
    done
else
    echo "dbnames.txt file NOT found in $BU"
    exit 1
fi
