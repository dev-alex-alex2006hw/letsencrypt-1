#!/bin/sh

set -e

letsencrypt $@ &&
[ -d "/etc/letsencrypt/live" ] && find /etc/letsencrypt/live -name 'privkey.pem' |
while read line; do
  KEY_FILE="$line"
  CERT_FILE="$(dirname $line)/fullchain.pem"
  HAPROXY_FILE="$(dirname $line)/haproxy.pem"
  DOMAIN_NAME="$(basename "$(dirname $line)")"
  cat "$CERT_FILE" "$KEY_FILE" > $HAPROXY_FILE
  mkdir -p /etc/letsencrypt/haproxy
  cp "$HAPROXY_FILE" "/etc/letsencrypt/haproxy/$DOMAIN_NAME.pem"
done
