#!/bin/bash -e
set -e
status=$1
case $status in
  on)
      sudo sed -i 's/^;*\(.*tideways_xhprof\.so\)/\1/' /usr/local/etc/php/php.ini
      echo "xhprof on";
      sudo service apache2 reload
      ;;
  off)
      sudo sed -i 's/^\(.*tideways_xhprof\.so\)/;\1/' /usr/local/etc/php/php.ini
      echo "xhprof off";
      sudo service apache2 reload
      ;;
    *)
      echo "usage xhprof: on|off" 1>&2;
esac