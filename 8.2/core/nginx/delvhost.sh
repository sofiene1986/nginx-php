#!/bin/bash -e
set -e
vhost=$1
if [ -n "$vhost" ]; then
  if [ -f "/etc/nginx/sites-enabled/$vhost.conf" ]; then
    sudo rm /etc/nginx/sites-enabled/$vhost.conf
    echo "$vhost is deleted"
    sudo service nginx restart
  else
    echo "$vhost does'nt exist"
  fi
else
  echo "$vhost is required"
fi