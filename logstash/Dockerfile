FROM opensearchproject/logstash-oss-with-opensearch-output-plugin:7.16.3

RUN bin/logstash-plugin install logstash-filter-alter

COPY logstash.conf /usr/share/logstash/pipeline/

EXPOSE 4560