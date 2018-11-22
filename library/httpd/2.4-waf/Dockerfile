FROM ubuntu:18.04

RUN mkdir -p /usr/local/apache2/htdocs/customer/web /usr/local/apache2/conf

RUN apt-get update \
    && apt-get install -y \
       apache2 \
       libapache2-mod-security2 \
       curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/pagespeed \
    && cd /opt/pagespeed \
    && curl https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb --output mod-pagespeed.deb\
    && dpkg -i mod-pagespeed.deb \
    && rm -rf /opt/pagespeed \
    && mkdir -p /var/cache/mod_pagespeed /var/log/pagespeed /var/run/apache2 /var/lock/apache2

COPY config/sites-enabled/vhost.conf /etc/apache2/sites-available/vhost.conf
COPY config/patchpanel.sh /usr/local/bin/
COPY config/apache2.conf /etc/apache2/apache2.conf

RUN mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

RUN sed -i 's/ModPagespeed on/ModPagespeed off/g' /etc/apache2/mods-enabled/pagespeed.conf

RUN a2ensite vhost.conf \
    && a2dissite 000-default.conf

RUN a2enmod rewrite proxy_fcgi headers expires remoteip

WORKDIR /usr/local/apache2/htdocs

EXPOSE 80

CMD ["patchpanel.sh"]
