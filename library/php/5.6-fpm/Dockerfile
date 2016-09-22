FROM php:5.6-fpm

# Adding some basic stuff to make chameleon run
RUN apt-get update && apt-get install -y \
    aspell \
    aspell-de \
    git \
    libicu-dev \
    libmcrypt-dev \
    libmemcached-dev \
    zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring pdo_mysql intl mysql mysqli

# Adding layer for imagemagick. This adds A LOT of extra payload to this docker.
# Remove it if you don't need it
RUN apt-get update && apt-get install -y \
   imagemagick libmagickwand-dev libmagickcore-dev jpegoptim optipng freetds-dev libcurl3-dev libicu-dev \
   && pecl install imagick \
   && docker-php-ext-enable imagick

RUN docker-php-ext-configure sybase_ct --with-sybase-ct=shared,/usr

RUN docker-php-ext-install -j$(nproc) gd soap sybase_ct zip opcache bcmath sockets curl intl

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.max_nesting_level = 1000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove

COPY config/php.ini /usr/local/etc/php/

COPY config/patchpanel.sh /

RUN chmod 755 /patchpanel.sh

# workaround: symlinking /usr/bin/php as it's expected in that location by some scripts
RUN ln -s /usr/local/bin/php /usr/bin/php 

WORKDIR /usr/local/apache2/htdocs/customer

ENTRYPOINT [ "/patchpanel.sh" ]
CMD [ "php-fpm" ]
