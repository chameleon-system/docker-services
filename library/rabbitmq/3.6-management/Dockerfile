FROM rabbitmq:3.6-management
COPY customized-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["customized-entrypoint.sh"]
CMD ["rabbitmq-server", "-config", "/etc/rabbitmq/rabbitmq-customized.config"]
