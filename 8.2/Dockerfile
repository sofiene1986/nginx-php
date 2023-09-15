FROM php:8.2-fpm
RUN apt-get update && apt-get install -y --fix-missing software-properties-common ca-certificates lsb-release apt-transport-https gnupg vim wget nginx

RUN apt-get install --fix-missing -y \
  ruby-dev \
  rubygems \
  imagemagick \
  graphviz \
  memcached \
  libmemcached-tools \
  libmemcached-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libxml2-dev \
  libxslt1-dev \
  default-mysql-client \
  sudo \
  git \
  vim \
  zip \
  wget \
  htop \
  iputils-ping \
  dnsutils \
  telnet \
  linux-libc-dev \
  libyaml-dev \
  libpng-dev \
  zlib1g-dev \
  libzip-dev \
  libicu-dev \
  libpq-dev \
  bash-completion \
  libldap2-dev \
  libssl-dev \
  libwebp-dev


###########################################################################
#                             PHP EXTENSIONS                              #
###########################################################################

RUN docker-php-ext-install opcache pdo_mysql && docker-php-ext-install mysqli
RUN docker-php-ext-configure gd --with-jpeg --with-webp
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN apt-get install libonig-dev
RUN docker-php-ext-install gd mbstring zip soap xsl calendar intl exif pgsql pdo_pgsql ftp bcmath ldap
# Custom Opcache
RUN ( \
  echo "opcache.memory_consumption=128"; \
  echo "opcache.interned_strings_buffer=8"; \
  echo "opcache.max_accelerated_files=20000"; \
  echo "opcache.revalidate_freq=5"; \
  echo "opcache.fast_shutdown=1"; \
  echo "opcache.enable_cli=1"; \
  ) >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Install xdebug.
RUN cd /tmp/ && wget https://github.com/xdebug/xdebug/archive/refs/tags/3.2.2.zip && unzip 3.2.2.zip && cd xdebug-3.2.2/ && phpize && ./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config && make && make install
RUN cd /tmp/xdebug-3.2.2 && cp modules/xdebug.so /usr/local/lib/php/extensions/
RUN touch /usr/local/etc/php/php.ini &&\
    echo 'zend_extension=xdebug.so' >> /usr/local/etc/php/php.ini
RUN touch /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.mode=debug' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.discover_client_host=0' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.client_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.log=/tmp/php8-xdebug.log' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.client_host=hostname' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.idekey=PHPSTORM' >> /usr/local/etc/php/conf.d/xdebug.ini

# Install php-xhprof
RUN cd /tmp && git clone "https://github.com/tideways/php-xhprof-extension.git" && cd php-xhprof-extension && phpize && ./configure && make && make install
RUN touch /usr/local/etc/php/php.ini &&\
 echo ";extension=tideways_xhprof.so" >>  /usr/local/etc/php/php.ini

# Install imagick
RUN apt-get install -y libmagickwand-dev
RUN cd /tmp &&  wget https://pecl.php.net/get/imagick-3.7.0.tgz --no-check-certificate && tar xf imagick-3.7.0.tgz && cd imagick-3.7.0 && phpize && ./configure && make install
RUN docker-php-ext-enable imagick

# Install APCu extension
RUN cd /tmp && wget https://pecl.php.net/get/apcu-5.1.22.tgz --no-check-certificate && tar xf apcu-5.1.22.tgz && cd apcu-5.1.22 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/php.ini &&\
 echo "extension=apcu.so" >>  /usr/local/etc/php/php.ini

RUN touch /usr/local/etc/php/php.ini &&\
 echo "max_execution_time=600" >>  /usr/local/etc/php/php.ini && \
 echo "max_input_time=600" >>  /usr/local/etc/php/php.ini && \
 echo "memory_limit=512M" >>  /usr/local/etc/php/php.ini && \
 echo "post_max_size=512M" >>  /usr/local/etc/php/php.ini && \
 echo "upload_max_filesize=512M" >>  /usr/local/etc/php/php.ini && \
 echo "upload_tmp_dir=/tmp" >>  /usr/local/etc/php/php.ini

# Install mcrypt extension
RUN cd /tmp &&  wget https://pecl.php.net/get/mcrypt-1.0.6.tgz --no-check-certificate && tar xf mcrypt-1.0.6.tgz && cd mcrypt-1.0.6 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/php.ini &&\
 echo "extension=mcrypt.so" >>  /usr/local/etc/php/php.ini

# INSTALL MEMCACHED
RUN pecl install igbinary msgpack
RUN touch /usr/local/etc/php/php.ini &&\
 echo "extension=msgpack.so" >>  /usr/local/etc/php/php.ini && \
 echo "extension=igbinary.so" >>  /usr/local/etc/php/php.ini

RUN cd /tmp && wget https://pecl.php.net/get/memcached-3.2.0.tgz --no-check-certificate && tar xf memcached-3.2.0.tgz && cd memcached-3.2.0 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/php.ini  &&\
 echo "extension=memcached.so" >>  /usr/local/etc/php/php.ini

# Installation of Composer
RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php
RUN cd /usr/src && mv composer.phar /usr/bin/composer

# Installation drushRUN cd /usr/local/src/ && mkdir drush12 && cd drush12 && composer require drush/drush:^12
RUN ln -s /usr/local/src/drush12/vendor/bin/drush /usr/local/bin/drush12
RUN cd /usr/local/src/ && mkdir drush11 && cd drush11 && composer require drush/drush:^11
RUN ln -s /usr/local/src/drush11/vendor/bin/drush /usr/local/bin/drush11
RUN cd /usr/local/src/ && mkdir drush10 && cd drush10 && composer require drush/drush:^10
RUN ln -s /usr/local/src/drush10/vendor/bin/drush /usr/local/bin/drush10
RUN cd /usr/local/src/ && mkdir drush9 && cd drush9 && composer require drush/drush:^9
RUN ln -s /usr/local/src/drush9/vendor/bin/drush /usr/local/bin/drush9

# Set timezone to Europe/Paris
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
# Install PREDIS
RUN cd /tmp &&  wget https://pecl.php.net/get/redis-5.3.4.tgz --no-check-certificate && tar xf redis-5.3.4.tgz && cd redis-5.3.4 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/php.ini  &&\
 echo "extension=redis.so" >>  /usr/local/etc/php/php.ini
###########################################################################
#                        END OF PHP EXTENSIONS                            #
###########################################################################
###########################################################################
#                              Create User                                #
###########################################################################
# Create new web user and grant sudo without password
RUN useradd web -d /var/www -g www-data -s /bin/bash
RUN usermod -aG sudo web
RUN echo 'web ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R web:www-data /tmp/ /var/log/nginx
RUN chmod -R 600 /var/log/nginx
RUN chmod -R 777 /tmp/ /var/www/


###########################################################################
#                                  Frontend                               #
###########################################################################
# Installation node.js
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install nodejs -y
###########################################################################
#                                  SYSTEM                                 #
###########################################################################
RUN apt-get install -y cron mc

RUN mkdir "/etc/nginx/vhost-skeleton"
COPY config/nginx/vhost /etc/nginx/vhost-skeleton/skeleton
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
# Add .bashrc config
COPY config/container/root.bashrc /root/.bashrc
RUN mkdir /etc/nginx/ssl
COPY config/ssl/* /etc/nginx/ssl
COPY config/nginx/php-fpm.conf /usr/local/etc/php-fpm.d/000-php-fpm.conf
###########################################################################
#                              SHELL SCRIPT                               #
###########################################################################
COPY core/nginx/addvhost.sh /usr/local/bin/addvhost
RUN chown web:root /usr/local/bin/addvhost && chmod +x /usr/local/bin/addvhost
COPY core/nginx/delvhost.sh /usr/local/bin/delvhost
RUN chown web:root /usr/local/bin/delvhost && chmod +x /usr/local/bin/delvhost
RUN  rm -rf /tmp/*

COPY config/container/install-nodejs.sh /usr/local/bin/install-nodejs
RUN chown web:root /usr/local/bin/install-nodejs && chmod +x /usr/local/bin/install-nodejs

EXPOSE 80 443 9000
COPY config/container/docker-entrypoint.sh /docker-nginx-entrypoint.sh
RUN chmod 777 /docker-nginx-entrypoint.sh && chmod +x /docker-nginx-entrypoint.sh
ENTRYPOINT ["/docker-nginx-entrypoint.sh"]

#STOPSIGNAL SIGQUIT

