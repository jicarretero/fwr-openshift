#!/bin/sh

echo "Starting with KIND=${KIND}"

if [ "x$KIND" = "xbroker" ]; then
    echo BROKER....
    java -jar cepheus-broker.jar -Dserver.port=8081
elif [ "x$KIND" = "xcep" ]; then
    echo CEP....
    java -jar cepheus-cep.jar -Dserver.port=8080
else
    echo "Try using KIND=cep|broker"
fi
