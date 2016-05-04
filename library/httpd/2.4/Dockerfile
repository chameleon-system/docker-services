FROM httpd:2.4

# Adding chameleon specific apache configuration. Some extra mods are now activated:
# rewrite, proxy, proxy_httpd, proxy_fcgi
COPY config/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY config/ssl/ssl-cert-snakeoil.pem /usr/local/apache2/conf/server.crt
COPY config/ssl/ssl-cert-snakeoil.key /usr/local/apache2/conf/server.key
COPY config/sites-enabled/vhost.conf /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
COPY config/patchpanel.sh /usr/local/bin/

EXPOSE 80 443

CMD ["patchpanel.sh"]
