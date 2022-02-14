#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Please supply a subdomain to create a certificate for";
    echo "e.g. example.com"
    exit 1
fi

mkdir -p root sites

if [ ! -f root/ca.pem ]; then
    openssl genrsa -out root/ca.key 2048
    openssl req -x509 -new -nodes -key root/ca.key -sha256 -days 1024 -out root/ca.pem
    chown -R 1000:1000 root
fi

# Create a new private key if one doesnt exist, or use the existing one if it does
if [ -f device.key ]; then
    KEY_OPT="-key"
else
    KEY_OPT="-keyout"
fi

DOMAIN=$1
COMMON_NAME=${2:-*.$1}
SUBJECT="/C=CA/ST=None/L=NB/O=None/CN=$COMMON_NAME"
NUM_OF_DAYS=999
openssl req -new -newkey rsa:2048 -sha256 -nodes $KEY_OPT src/device.key -subj "$SUBJECT" -out sites/device.csr
cat config | sed s/%%DOMAIN%%/"$COMMON_NAME"/g > /tmp/__v3.ext
openssl x509 -req -in sites/device.csr -CA root/ca.pem -CAkey root/ca.key -CAcreateserial -out sites/device.crt -days $NUM_OF_DAYS -sha256 -extfile /tmp/__v3.ext

# move output files to final filenames
mv sites/device.csr "sites/${DOMAIN}.csr"
cp sites/device.crt "sites/${DOMAIN}.crt"

# remove temp file
rm -f sites/device.crt;

chown -R 1000:1000 sites