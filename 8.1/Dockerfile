FROM php:8.1-fpm
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


# Create new web user for apache and grant sudo without password
RUN useradd web -d /var/www -g www-data -s /bin/bash
RUN usermod -aG sudo web
RUN echo 'web ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Installation node.js

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install nodejs -y

# Installation of Composer
RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php
RUN cd /usr/src && mv composer.phar /usr/bin/composer

# Install xdebug.
RUN cd /tmp/ && wget https://github.com/xdebug/xdebug/archive/refs/tags/3.2.2.zip && unzip 3.2.2.zip && cd xdebug-3.2.2/ && phpize && ./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config && make && make install
RUN cd /tmp/xdebug-3.2.2 && cp modules/xdebug.so /usr/local/lib/php/extensions/
RUN touch /usr/local/etc/php/php.ini &&\
    echo ';zend_extension=/usr/local/lib/php/extensions/xdebug.so' >> /usr/local/etc/php/php.ini
RUN touch /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.mode=debug' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.discover_client_host=0' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.client_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.log=/tmp/php8-xdebug.log' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.client_host=hostname' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.idekey=PHPSTORM' >> /usr/local/etc/php/conf.d/xdebug.ini

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

RUN chown -R web:www-data /var/www/html

# Change owner tmp Folder
RUN chown -R web:www-data /tmp/
RUN chmod -R 777 /tmp/

# Installation drush
RUN cd /usr/local/src/ && mkdir drush && cd drush && composer require drush/drush
RUN ln -s /usr/local/src/drush/vendor/bin/drush /usr/local/bin/drush

# Set timezone to Europe/Paris
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Install php-xhprof
RUN cd /tmp && git clone "https://github.com/tideways/php-xhprof-extension.git" && cd php-xhprof-extension && phpize && ./configure && make && make install
RUN cd / && rm -rf /tmp/*

RUN touch /usr/local/etc/php/php.ini &&\
 echo ";extension=tideways_xhprof.so" >>  /usr/local/etc/php/php.ini

# Add xdebug function
COPY core/xdebug.sh /usr/local/bin/xdebug
RUN chown web:root /usr/local/bin/xdebug && chmod +x /usr/local/bin/xdebug

# Add xhprof function
COPY core/xhprof.sh /usr/local/bin/xhprof
RUN chown web:root /usr/local/bin/xhprof && chmod +x /usr/local/bin/xhprof

# Add .bashrc config
COPY config/.bashrc /root/.bashrc

RUN apt-get install -y libmagickwand-dev
RUN cd /tmp &&  wget https://pecl.php.net/get/imagick-3.7.0.tgz --no-check-certificate && tar xf imagick-3.7.0.tgz && cd imagick-3.7.0 && phpize && ./configure && make install

RUN docker-php-ext-enable imagick
RUN apt-get install -y cron

# Install PREDIS
RUN cd /tmp &&  wget https://pecl.php.net/get/redis-5.3.4.tgz --no-check-certificate && tar xf redis-5.3.4.tgz && cd redis-5.3.4 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/conf.d/redis.ini &&\
 echo "extension=redis.so" >>  /usr/local/etc/php/conf.d/redis.ini

# INSTALL MC
RUN apt-get install mc -y

# INSTALL MEMCACHED
RUN cd /tmp && wget https://pecl.php.net/get/memcached-3.2.0.tgz --no-check-certificate && tar xf memcached-3.2.0.tgz && cd memcached-3.2.0 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/conf.d/memcached.ini &&\
 echo "extension=memcached.so" >>  /usr/local/etc/php/conf.d/memcached.ini

# Install APCu extension
RUN cd /tmp && wget https://pecl.php.net/get/apcu-5.1.22.tgz --no-check-certificate && tar xf apcu-5.1.22.tgz && cd apcu-5.1.22 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/conf.d/apcu.ini &&\
 echo "extension=apcu.so" >>  /usr/local/etc/php/conf.d/apcu.ini

RUN touch /usr/local/etc/php/php.ini &&\
 echo "max_execution_time=600" >>  /usr/local/etc/php/php.ini && \
 echo "max_input_time=600" >>  /usr/local/etc/php/php.ini && \
 echo "memory_limit=512M" >>  /usr/local/etc/php/php.ini && \
 echo "post_max_size=512M" >>  /usr/local/etc/php/php.ini && \
 echo "upload_max_filesize=512M" >>  /usr/local/etc/php/php.ini && \
 echo "upload_tmp_dir=/tmp" >>  /usr/local/etc/php/php.ini

# Install mcrypt extension
RUN cd /tmp &&  wget https://pecl.php.net/get/mcrypt-1.0.6.tgz --no-check-certificate && tar xf mcrypt-1.0.6.tgz && cd mcrypt-1.0.6 && phpize && ./configure && make install
RUN touch /usr/local/etc/php/conf.d/mcrypt.ini &&\
 echo "extension=mcrypt.so" >>  /usr/local/etc/php/conf.d/mcrypt.ini

EXPOSE 80 443 9000
#COPY core/vhost /etc/nginx/sites-enabled/vhost
RUN mkdir "/var/www/vhost"
COPY core/vhost /var/www/vhost/vhost-exemple/vhost
COPY core/addvhost.sh /usr/local/bin/addvhost
RUN chown web:root /usr/local/bin/addvhost && chmod +x /usr/local/bin/addvhost
COPY core/delvhost.sh /usr/local/bin/delvhost
RUN chown web:root /usr/local/bin/delvhost && chmod +x /usr/local/bin/delvhost

RUN apt-get install -y cron && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

COPY core/install-nodejs.sh /usr/local/bin/install-nodejs
RUN chown web:root /usr/local/bin/install-nodejs && chmod +x /usr/local/bin/install-nodejs
#COPY core/docker-entrypoint.sh /
#RUN chmod 777 /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh
#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
