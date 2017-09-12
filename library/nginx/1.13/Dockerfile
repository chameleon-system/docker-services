FROM nginx:1.13

# Adding chameleon specific apache configuration. Some extra mods are now activated:
# rewrite, proxy, proxy_httpd, proxy_fcgi
COPY config/sites-enabled/default.conf /etc/nginx/conf.d/default.conf
COPY config/patchpanel.sh /usr/local/bin/

EXPOSE 80

CMD ["patchpanel.sh"]
