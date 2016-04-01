FROM php:5.6-fpm

# Adding some basic stuff to make chameleon run
RUN apt-get update && apt-get install -y \
    aspell \
    aspell-de \
    libmcrypt-dev \
    libmemcached-dev \
    zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring pdo_mysql

# Adding layer for imagemagick. This adds A LOT of extra payload to this docker.
# Remove it if you don't need it
RUN apt-get update && apt-get install -y \
   imagemagick libmagickwand-dev libmagickcore-dev \
   && pecl install imagick \
   && docker-php-ext-enable imagick

RUN docker-php-ext-install -j$(nproc) gd

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.max_nesting_level = 1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY config/php.ini /usr/local/etc/php/

COPY config/patchpanel.sh /

RUN chmod 755 /patchpanel.sh

CMD [ "/patchpanel.sh" ]
