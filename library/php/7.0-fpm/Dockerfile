FROM php:7.0-fpm

# Adding some basic stuff to make chameleon run
RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    libmemcached-dev \
    zlib1g-dev \
    git

RUN git clone -b php7 --single-branch https://github.com/php-memcached-dev/php-memcached.git \
    && ( \
        cd php-memcached \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
       ) \
    && rm -rf php-memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) opcache mcrypt iconv mbstring

# Adding layer for imagemagick. This adds A LOT of extra payload to this docker.
# Remove it if you don't need it
RUN apt-get update && apt-get install -y \
    imagemagick libmagickwand-dev libmagickcore-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick

COPY config/php.ini /usr/local/etc/php/
