FROM debian:jessie

MAINTAINER "Diego Marangoni" <https://github.com/diegomarangoni>

RUN groupadd -r mysql && useradd -r -g mysql mysql \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 1BB943DB \
    && echo 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/debian jessie main' > /etc/apt/sources.list.d/mariadb.list \
    && { \
            echo 'Package: *'; \
            echo 'Pin: release o=MariaDB'; \
            echo 'Pin-Priority: 999'; \
        } > /etc/apt/preferences.d/mariadb \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get install -y --no-install-recommends curl mariadb-galera-server xtrabackup netcat-openbsd socat pv \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql \
    && sed -Ei 's/^(bind-address)/#&/' /etc/mysql/my.cnf


VOLUME /xxxxxxxxxxxxxxxxx
VOLUME /var/lib/mysql
RUN mkdir /cache
VOLUME /cache
COPY docker-host /docker-host
COPY docker-entrypoint.sh /entrypoint.sh
COPY galera.sh /galera.sh
COPY notify.sh /notify.sh
COPY my.cnf /etc/mysql/my.cnf
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306 4567 4568 4444 13306
CMD ["mysqld"]