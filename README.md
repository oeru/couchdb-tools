Couchdb-tools
=============

Requires bash and jq (JSON Query tool) and the included couchdb-backup.sh tool

These tools provide scripts to
* backup/export (as JSON files) all the databases in a CouchDB instance, to which you have web-based access. Each backup is made in a designated backup directory, and in a dated directory within it, with a JSON file for each database exported as well as a list of the database names.
* delete all existing DBs in CouchDB instance (use carefully!)
* restore/import (from JSON files created by the backup process) databases into an existing CouchDB instance. Will not overwrite existing databases (they must be deleted to be replaced). When restoring you can choose a backup date from those previously backed up in your designated backup directory.

This set of tools was written to copy a set of databases from a production CouchDB instance and recreate the database on a local development server.

Each script has its own configuration file (with the same name as the relevant script) to help avoid inadvertently working on the wrong CouchDB.

Note: tested on Ubuntu Linux, but should on any system running bash and relevant dependencies

Provided by the Open Education Resource Foundation (http://oerfoundation.org), who are committed to using open source technologies to develop an openly licensed (CC-By or CC-By-SA) tertiary curriculum (assembled on http://wikieducator.org) for the benefit of learners and tertiary institutions of the world via the OERuniversitas project: http://oeru.org

See our Technology Blog for more open source projects: https://tech.oeru.org
