#!/bin/bash -e
set -e
vhost=$1
documentRoot=$2
if [ -n "$documentRoot" ]; then
   echo "Document root /var/www/html/$documentRoot"
   documentRoot="\/var\/www\/html\/$documentRoot"
else
 documentRoot="\/var\/www\/html"
fi

if [ -n "$vhost" ]; then
  if [ -f "/etc/nginx/sites-enabled/$vhost.conf" ]; then
    echo "$vhost is already exist"
  else
    sudo cp /etc/nginx/vhost-skeleton/skeleton /etc/nginx/sites-enabled/$vhost.conf
    sudo sed -i "s/SERVERNAME/$vhost/g" /etc/nginx/sites-enabled/$vhost.conf
    sudo  sed -i "s/DOCUMENTROOT/$documentRoot/g" /etc/nginx/sites-enabled/$vhost.conf
    echo "$vhost created success"
    sudo service nginx restart
  fi
else
  echo "$vhost is required"
fi