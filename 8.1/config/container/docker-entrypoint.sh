#!/bin/bash -e
set -e
if [ -n "$SERVERNAME" ]; then
  sed -i "s/SERVERNAME/$SERVERNAME/g" /etc/nginx/nginx.conf
  else
    sed -i "s/SERVERNAME/localhost/g" /etc/nginx/nginx.conf
fi
if [ -n "$DOCUMENTROOT" ]; then
   documentRoot="\/var\/www\/html\/$DOCUMENTROOT"
else
 documentRoot="\/var\/www\/html"
fi
sudo  sed -i "s/DOCUMENTROOT/$documentRoot/g" /etc/nginx/nginx.conf
service nginx start && php-fpm
exec "$@"