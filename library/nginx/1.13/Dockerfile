FROM nginx:1.13

# Adding chameleon specific apache configuration. Some extra mods are now activated:
# rewrite, proxy, proxy_httpd, proxy_fcgi
COPY config/sites-enabled/vhost.template /etc/nginx/conf.d/vhost.template
COPY config/patchpanel.sh /usr/local/bin/

EXPOSE 80

CMD ["patchpanel.sh"]
