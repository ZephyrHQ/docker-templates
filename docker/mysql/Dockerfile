FROM mysql:5.6

VOLUME /var/lib/mysql
COPY my.cnf /etc/mysql/my.cnf
RUN chmod 644 /etc/mysql/my.cnf
RUN echo Europe/Paris |  tee /etc/timezone &&  dpkg-reconfigure --frontend noninteractive tzdata



