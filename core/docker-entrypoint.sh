#!/bin/bash -e
set -e
if [ -n "$SERVERNAME" ]; then
  echo $SERVERNAME
  sed -i "s/SERVERNAME/$SERVERNAME/g" /etc/nginx/sites-enabled/vhost
else
  sed -i "s/SERVERNAME/local.localhost.com/g" /etc/nginx/sites-enabled/vhost
fi
if [ -n "$DOCUMENTROOT" ]; then
  echo "/var/www/html/$DOCUMENTROOT"
  sed -i "s/SERVERNAME/$DOCUMENTROOT/g" /etc/nginx/sites-enabled/vhost
else
  echo "/var/www/html"
  sed -i "s/SERVERNAME//g" /etc/nginx/sites-enabled/vhost
fi