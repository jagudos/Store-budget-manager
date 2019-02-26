#!/bin/bash

# obtenemos el timestamp
# $1 nombre del fichero zip
# $2 password del zip
# $3 nombre del password

timestamp=`date "+%s"`
FILE=Lista_Blanca.txt

echo $timestamp

7za e $1 -p$2 

echo 'ejecutamos la importación con nombre' listin_$timestamp

mongoimport -d validador -c listin_$timestamp --type csv --file $3 --headerline

echo 'ejecutamos la creación del index'

mongo validador --eval "db.listin_$timestamp.createIndex( { NVOMSISDN: 1 } );"

collectionName="listin_"$timestamp
echo 'modificamos el fichero config.json'
tmp=$(mktemp)
jq --arg collectionName "$collectionName" '.telefon = $collectionName' /usr/share/validador/config.json > "$tmp" && mv "$tmp" /usr/share/validador/config.json
rm -f $3
