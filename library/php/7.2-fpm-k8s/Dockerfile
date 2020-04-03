# PHP_VERSION defines the php version (docker tag from https://hub.docker.com/_/php) to use

ARG PHP_VERSION=7.2-fpm
ARG PHP_RELEASE=php_base
FROM php:${PHP_VERSION}
ARG GD_FREETYPE_DIRECTIVE="--with-freetype-dir=/usr/include/"
ARG GD_JPEG_DIRECTIVE="--with-jpeg-dir=/usr/include/"
ARG MEMCACHED_VERSION=memcached
ARG PHP_ADDITIONAL_EXTENSIONS=""

RUN apt-get update && apt-get install -y gnupg \
    && curl -sSL https://packages.blackfire.io/gpg.key | apt-key add - \
    && echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list \
    && apt-get update \
    && apt-get install -y blackfire-php

# install common dependencies
# Adding some basic stuff to make chameleon run
RUN apt-get update && apt-get install -y \
    aspell \
    aspell-de \
    freetds-dev \
    jpegoptim \
    libcurl3-dev \
    libfreetype6-dev\
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libmemcached-dev \
    libonig-dev \
    libtidy-dev \
    libzip-dev \
    libxml2-dev \
    locales \
    optipng \
    pngquant \
    unzip \
    zlib1g-dev \
    && locale-gen de_DE.UTF-8 \
    && locale-gen en_EN.UTF-8

# Adding layer for imagemagick. This adds A LOT of extra payload to this docker.
# Remove it if you don't need it
RUN apt-get update && apt-get install -y \
    imagemagick libmagickwand-dev libmagickcore-dev  \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN docker-php-ext-configure gd "${GD_FREETYPE_DIRECTIVE}" "${GD_JPEG_DIRECTIVE}"
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    curl \
    gd \
    iconv \
    intl \
    mbstring \
    mysqli \
    opcache \
    pdo_mysql \
    soap \
    sockets \
    tidy \
    zip ${PHP_ADDITIONAL_EXTENSIONS}

# add ms sql server support for PDO
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/ \
    && docker-php-ext-install -j$(nproc) pdo_dblib

RUN pecl install ${MEMCACHED_VERSION} \
    && docker-php-ext-enable memcached

COPY config/php.ini /usr/local/etc/php/
COPY config/proxy.conf /usr/local/etc/php-fpm.d/

COPY config/zzz-blackfire.ini /usr/local/etc/php/conf.d/zzz-blackfire.ini

COPY tools /usr/local/bin/tools

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# workaround: symlinking /usr/bin/php as it's expected in that location by some scripts
RUN ln -s /usr/local/bin/php /usr/bin/php

WORKDIR /usr/local/apache2/htdocs

CMD [ "php-fpm" ]
