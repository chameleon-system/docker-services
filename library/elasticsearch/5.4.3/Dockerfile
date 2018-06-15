FROM elasticsearch:5.4.3

VOLUME ["/data"]

WORKDIR /data

COPY config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install "http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-analysis-decompound/5.4.3.0/elasticsearch-analysis-decompound-5.4.3.0-plugin.zip"

EXPOSE 9200
EXPOSE 9300

