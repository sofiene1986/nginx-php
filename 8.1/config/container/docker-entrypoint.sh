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
case $USE_XDEBUG in
  on)
      sudo sed -i 's/^;*\(.*xdebug\.so\)/\1/' /usr/local/etc/php/php.ini
      ;;
  off)
      sudo sed -i 's/^\(.*xdebug\.so\)/;\1/' /usr/local/etc/php/php.ini
      ;;
    *)
      sudo sed -i 's/^\(.*xdebug\.so\)/;\1/' /usr/local/etc/php/php.ini
esac
case $USE_XHPROF in
  on)
      sudo sed -i 's/^;*\(.*tideways_xhprof\.so\)/\1/' /usr/local/etc/php/php.ini
      ;;
  off)
      sudo sed -i 's/^\(.*tideways_xhprof\.so\)/;\1/' /usr/local/etc/php/php.ini
      ;;
    *)
      sudo sed -i 's/^\(.*tideways_xhprof\.so\)/;\1/' /usr/local/etc/php/php.ini
esac
sudo  sed -i "s/DOCUMENTROOT/$documentRoot/g" /etc/nginx/nginx.conf
service nginx start && php-fpm
exec "$@"