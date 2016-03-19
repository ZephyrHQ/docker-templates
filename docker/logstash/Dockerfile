from logstash:2.1

ADD logstash.conf /etc/logstash/logstash.conf
VOLUME /etc/logstash

CMD ["logstash", "agent", "-f", "/etc/logstash/logstash.conf"]
