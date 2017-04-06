FROM elasticsearch:5.3

VOLUME ["/data"]

WORKDIR /data

ENTRYPOINT ["/elasticsearch/bin/elasticsearch"]

COPY config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

EXPOSE 9200
EXPOSE 9300

CMD [""]
