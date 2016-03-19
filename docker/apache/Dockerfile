FROM debian:jessie

RUN echo Europe/Paris |  tee /etc/timezone &&  dpkg-reconfigure --frontend noninteractive tzdata
ENV DEBIAN_FRONTEND noninteractive

# Installation Apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
RUN sed -i s/" main"/" main contrib non-free"/g /etc/apt/sources.list
RUN apt-get update && apt-get -y install apache2 apache2-mpm-worker libapache2-mod-fastcgi && apt-get clean && apt-get autoclean
RUN a2enmod rewrite proxy_fcgi actions
RUN mkdir /cgi-bin
ADD fastcgi.conf /etc/apache2/mods-available/
ADD vhost.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf
RUN a2ensite vhost.conf

VOLUME /var/www/html

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
