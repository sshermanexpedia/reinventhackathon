#!/bin/bash

# WARNING  order is significant here!
SOURCES=(
https://s3-us-west-2.amazonaws.com/reinventhackathon/04-open_data-projects.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/05-open_data-resources.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/02-open_data-essays.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/01-open_data-donations.csv.gz
https://s3-us-west-2.amazonaws.com/reinventhackathon/03-open_data-giftcards.csv.gz
)

bomb() {
echo >&2
echo "$0: $@" >&2
exit 1
}

SAFE=false
[ "x$1" = "x-n" ] && SAFE=true
echo -n "Clearing out old files..."
$SAFE || rm -f 0*
echo "done."

FILES=
SEP=

for src in "${SOURCES[@]}"; do
# Cheat - use basename to get the leafnode in the URL
FNAME=`basename "$src"`
echo -n "Fetching $FNAME..."
# Grab the file
$SAFE || wget -q $src || bomb "couldn't wget $src"
# We should really check the filename ends in .gz in case they
# decide to use xz or similar later
echo -n "unzipping..."
$SAFE || gunzip $FNAME || bomb "couldn't unzip $src"
FILES="${FILES}${SEP}`basename $FNAME .gz`"
SEP=' '
echo "done."
done

export FILES

DBUSER=donoruser
DBHOST=localhost
DBNAME=donorschoose

(
DO_SEP=false
for file in $FILES; do
 $DO_SEP && echo '\.'
 DO_SEP=true
 grep '^[a-f0-9_]' $file | grep -v '^[0-9a-f][0-9a-f]*[^0-9a-f,]'
 done
) | psql -d $DBNAME -f load-script.sql