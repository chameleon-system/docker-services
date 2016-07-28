FROM php:5.6-fpm

# Adding some basic stuff to make chameleon run
RUN apt-get update && apt-get install -y \
    aspell \
    aspell-de \
    libicu-dev \
    libmcrypt-dev \
    libmemcached-dev \
    zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring pdo_mysql intl mysql

# Adding layer for imagemagick. This adds A LOT of extra payload to this docker.
# Remove it if you don't need it
RUN apt-get update && apt-get install -y \
   imagemagick libmagickwand-dev libmagickcore-dev jpegoptim optipng freetds-dev \
   && pecl install imagick \
   && docker-php-ext-enable imagick

RUN docker-php-ext-configure sybase_ct --with-sybase-ct=shared,/usr

RUN docker-php-ext-install -j$(nproc) gd soap sybase_ct

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.max_nesting_level = 1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY config/php.ini /usr/local/etc/php/

COPY config/patchpanel.sh /

RUN chmod 755 /patchpanel.sh

# workaround: symlinking /usr/bin/php as it's expected in that location by some scripts
RUN ln -s /usr/local/bin/php /usr/bin/php 

WORKDIR /usr/local/apache2/htdocs/customer

VOLUME composercache:/.composer

CMD [ "/patchpanel.sh" ]
