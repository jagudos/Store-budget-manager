#!/bin/bash

# $1 nombre del fichero zip
# $2 password del zip
# $3 nombre del fichero


timestamp=`date "+%s"`
FILE=Lista_Blanca.txt

echo $timestamp

7za e $1 -p$2 

#ejecutamos la importación
echo INICIO IMPORTACION
mongoimport -d validador -c identification_$timestamp --type csv --file $3 --headerline

echo INICIO INDICE
#mongo validador --eval "db.identification_%timestamp%.createIndex( { CIF_NIF: 1 } );"
mongo validador --eval "db.identification_$timestamp.createIndex( { CIF_NIF: 1 } );"

echo INICIO CAMBIO CONFIG.JSON
collectionName="identification_"$timestamp
#modificamos el fichero config.json
tmp=$(mktemp)
jq --arg collectionName "$collectionName" '.identification = $collectionName' /usr/share/validador/config.json > "$tmp" && mv "$tmp" /usr/share/validador/config.json
echo BORRADO
rm -f $3
echo FIN