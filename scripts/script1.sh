#!/bin/bash

#obtenemos el timestamp

timestamp=`date "+%s"`

echo $timestamp
collectionName="mola_"$timestamp
echo $collectionName
#modificamos el fichero config.json
jq --arg collectionName "$collectionName" '.collection = $collectionName' /usr/share/validador/config.json

