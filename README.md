## C'est image docker est optimsé pour drupal

### Docker-compose:

      version: "3"
      services:
        web:
          image: sofiene1986/nginx-php:TAG
          environment:
            - SERVERNAME=localhost
            - DOCUMENTROOT=
            # DOCUMENTROOT=   (vide) document root sera /var/www/html
            # DOCUMENTROOT=web   (vide) document root sera /var/www/html/web
            - USE_XDEBUG=on ou USE_XDEBUG=off 
            - USE_XHPROF=on ou USE_XHPROF=off 
          volumes:
            - ./html/:/var/www/html/
          ports:
            - "80:80"
            - "443:443"
          extra_hosts:
            - "hostname:ip de la machine host" ## utilisé pour xdebug
#### Quelques commandes utils:
    addvhost Hostname DocRoot, exemple: addvhost monlocalhost web 
    delvhost Hostname, exemple: delvhost monlocalhost 

#### Pour ajouter une tache cron, connecter au contenaire et executer les commandes suivante:
    crontab -e
    Exemple de tache cron:  
    */15 * * * * wget -q -o /dev/null http://localhost/cron/M8RKg-2INkb5ftW3-nbEeaOXfOaclufPmzKJU_43h5Z8khzXveBk0-5mAWC0mIDjF2gJNhFY5w
    Echap + :wq!      
#### Pour installer une nouvelle version de nodejs, connecter au contenaire et executer les commandes suivante:
    install-nodejs 18 (exemple)