#!/bin/bash

# curl script to invoke Stackato or CF REST API

TARGET=$(cat ~/.stackato/client/target)
TOKEN=$(json < ~/.stackato/client/token [\"$TARGET\"])
PUTDATA='{"console":true,"state":"STARTED"}'
GUID="c9042bdf-8b25-433a-9e42-7038ab6d613f"

echo "TARGET: ${TARGET}"
echo "TOKEN: ${TOKEN}"
echo "PUTDATA: ${PUTDATA}"
echo "GUID: ${GUID}"

curl -X GET --silent -k --header "Authorization:${TOKEN}" $TARGET/v2/apps

curl --data ${PUTDATA} -X PUT --silent -k --header "Authorization:${TOKEN}" $TARGET/v2/apps/${GUID}?stage_async=true
