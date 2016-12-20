#!/bin/bash

# Values to set in Conf file
# COUCHBAK="[path to couchdb-backup.sh]"
# HOST=[host] # http://localhost
# PORT=[port] # probably some variant of 5984
# USER=[username] # possibly 'admin'
# PW=[password]
# BUDIR="[path to backup directory]"

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
JQ=`which jq`

# Get the databases
DBS=`$CURL -X GET -H "Content-Type:application/json" ${HOST}:${PORT}/_all_dbs |  $JQ -r '.[]|.'`

DATE=`date '+%Y%d%m_%H%M'`
if [ ! -d $BUDIR ] ; then
    echo "creating $BUDIR..."
    mkdir $BUDIR
fi
if [ ! -d $BUDIR/$DATE ] ; then
  echo "creating backup dir $BUDIR/$DATE"
  mkdir ${BUDIR}/${DATE}
fi
echo "copying database names into $BUDIR/$DATE/dbnames.txt"
echo "$DBS" > $BUDIR/$DATE/dbnames.txt

for DB in $DBS
do
    BAK=${BUDIR}/${DATE}/${DB}-back-${DATE}.json
    echo "backing up $DB at $DATE into $BAK using user $USER"
    $COUCHBAK -b -H http://localhost -P 15984 -d $DB -f $BAK -u $USER -p $PW
done
