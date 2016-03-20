FROM httpd:2.4

# Adding chameleon specific apache configuration. Some extra mods are now activated:
# rewrite, proxy, proxy_httpd, proxy_fcgi
COPY config/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY config/vhost.conf /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
