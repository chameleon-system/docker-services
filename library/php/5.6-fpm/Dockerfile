FROM php:5.6-fpm

# Adding some basic stuff to make chameleon run
RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    libmemcached-dev \
    zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring

# Adding layer for imagemagick. This adds A LOT of extra payload to this docker.
# Remove it if you don't need it
RUN apt-get update && apt-get install -y \
   imagemagick libmagickwand-dev libmagickcore-dev \
   && pecl install imagick \
   && docker-php-ext-enable imagick

COPY config/php.ini /usr/local/etc/php/
