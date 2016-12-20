#!/bin/bash

# This removes all the DBs for an instance of CouchDB, usually to replace them for development purposes

# Values to set in Conf file
# HOST=[host] # http://localhost
# PORT=[port] # probably some variant of 5984
# USER=[username] # possibly 'admin'
# PW=[password]

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



CURL=`which curl`

EXISTING=`$CURL -X GET -H "Content-Type:application/json" ${HOST}:${PORT}/_all_dbs`

echo "Are you sure you want to remove the following databases:\n ${EXISTING}"
echo "On the http://${HOST}:${PORT}"
# requires user input
select yn in "Yes" "No"; do
    case $yn in
        Yes ) DELETE=true; break;;
        No ) exit 1;;
    esac
done

# Get the databases
if [ $DELETE ]; then

    echo "Deleting $EXISTING..."
    for DB in $DBS
    do
        if [[ ! "$EXISTING" = *"\"${DB}\""* ]]; then
            echo "creating $DB"
            $CURL -X PUT http://${USER}:${PW}@${HOST}:${PORT}/${DB}
            echo "restoring database $DB"
            FILES=( ${BUDIR}/${BU}/${DB}-back-*.json )
            FILE=${FILES[-1]}
            $CURL -d @${FILE} -X POST http://${USER}:${PW}@${HOST}:${PORT}/${DB}/_bulk_docs -H "Content-Type:application/json"
        else
            echo "$DB already exists, skipping"
        fi
   done
else
    echo "dbnames.txt file NOT found in $BUDIR/$BU"
    exit 1
fi
