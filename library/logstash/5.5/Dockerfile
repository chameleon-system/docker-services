FROM logstash:5.5

RUN logstash-plugin install logstash-output-exec
RUN logstash-plugin install logstash-input-file
RUN logstash-plugin install logstash-output-tcp
RUN logstash-plugin install logstash-input-cloudwatch
