#!/bin/sh

openssl s_client -showcerts -connect ${STACKATO_HOST}:443 </dev/null | openssl x509 > /tmp/cert

keytool -import -noprompt -file /tmp/cert -alias ${STACKATO_HOST} -storepass changeit -keystore /usr/lib/jvm/java-7-oracle/jre/lib/security/cacerts

cd /cflab

git pull
mvn -q clean package exec:java -Dexec.args="https://${STACKATO_HOST} ${STACKATO_USER} ${STACKATO_PW}"
