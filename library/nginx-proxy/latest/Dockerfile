FROM:jwilder/nginx-proxy:latest
COPY config/certs /etc/nginx/certs
RUN { \
      echo 'proxy_connect_timeout       600;'; \
      echo 'proxy_send_timeout       600;'; \
      echo 'proxy_read_timeout       600;'; \
      echo 'send_timeout       600;'; \
    } > /etc/nginx/conf.d/chameleon.conf
