#
# ElasticSearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM java:7

# Install ElasticSearch.
RUN \
  cd /tmp && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.2.tar.gz && \
  tar xvzf elasticsearch-1.5.2.tar.gz && \
  rm -f elasticsearch-1.5.2.tar.gz && \
  mv /tmp/elasticsearch-1.5.2 /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
ENTRYPOINT ["/elasticsearch/bin/elasticsearch"]

COPY config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

CMD [""]
