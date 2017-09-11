FROM ubuntu:16.04

RUN apt-get update && apt-get install -y cifs-utils
COPY mount.sh /usr/local/bin/mount.sh
RUN chmod 755 /usr/local/bin/mount.sh 

WORKDIR /usr/local/bin

ENTRYPOINT ["mount.sh"]
