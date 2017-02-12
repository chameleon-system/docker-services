FROM httpd:2.4

# Adding chameleon specific apache configuration. Some extra mods are now activated:
# rewrite, proxy, proxy_httpd, proxy_fcgi
COPY config/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY config/sites-enabled/vhost.conf /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
COPY config/patchpanel.sh /usr/local/bin/

RUN apt update && apt install -y wget apache2.2-common apache2-bin
RUN wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
RUN dpkg -i mod-pagespeed-*.deb
RUN rm -f mod-pagespeed-*.deb
RUN cp /usr/lib/apache2/modules/mod_pagespeed_ap24.so /usr/local/apache2/modules/

EXPOSE 80

CMD ["patchpanel.sh"]
