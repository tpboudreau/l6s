
ARG MODE
ARG REPO

FROM ubuntu:18.04 as base

ARG TIMEZONE=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

RUN apt-get -qq update && \
    apt-get -qq install -y software-properties-common && \
    add-apt-repository universe && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install tzdata && \
    apt-get -qq install -y acl composer curl fping graphviz imagemagick mariadb-client memcached mtr-tiny nmap python-memcache python-mysqldb rrdtool snmp unzip whois && \
    apt-get -qq install -y pkg-config php7.2-dev zlib1g-dev libmemcached-dev && \
    apt-get -qq install -y php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-json php7.2-mbstring php7.2-mysql php7.2-mysqlnd php7.2-snmp php7.2-xml php7.2-zip

RUN groupadd -g 1010 -r librenms && \
    useradd -c librenms -u 1010 -g 1010 -r -M librenms

RUN mkdir build && \
    curl -o build/memcached-3.1.4.tgz https://pecl.php.net/get/memcached-3.1.4.tgz && \
    cd build && \
    tar xzf memcached-3.1.4.tgz && \
    cd memcached-3.1.4 && \
    phpize && ./configure && make install && \
    cd / && \
    rm -rf /build

COPY common.d/memcached.ini /etc/php/7.2/mods-available/
COPY common.d/timezone.ini /etc/php/7.2/cli/conf.d
COPY common.d/timezone.ini /etc/php/7.2/fpm/conf.d
RUN ln -s /etc/php/7.2/mods-available/memcached.ini /etc/php/7.2/cli/conf.d/memcached.ini && \
    ln -s /etc/php/7.2/mods-available/memcached.ini /etc/php/7.2/fpm/conf.d/memcached.ini

RUN rm /etc/systemd/system/multi-user.target.wants/*.service && \
    rm /etc/systemd/system/timers.target.wants/*.timer

#==============================================================================

FROM base as build

ARG REPO

RUN apt-get -q install -y wget && \
    mkdir -p /opt/librenms && \
    chown librenms:librenms /opt/librenms && \
    chmod 770 /opt/librenms

WORKDIR /opt/librenms

RUN wget -nv -O /tmp/librenms.tar.gz ${REPO} && \
    tar xzf /tmp/librenms.tar.gz --strip-components=1 && \
    chown -R librenms:librenms /opt/librenms && \
    setfacl -d -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/ && \
    setfacl -R -m g::rwx /opt/librenms/rrd /opt/librenms/logs /opt/librenms/bootstrap/cache/ /opt/librenms/storage/

RUN su -c '/opt/librenms/scripts/composer_wrapper.php install --no-dev' - librenms

RUN tar czf /tmp/librenms.tar.gz --acls /opt/librenms

#==============================================================================

FROM ubuntu:18.04 as prepare-volume

RUN apt-get update -y && \
    apt-get -q install -y gettext-base 

RUN groupadd -g 1010 -r librenms && \
    useradd -c librenms -u 1010 -g 1010 -r -M librenms && \
    mkdir -p /opt/librenms && \
    chown librenms:librenms /opt/librenms && \
    chmod 770 /opt/librenms

COPY --from=build /tmp/librenms.tar.gz /tmp/
COPY common.d/librenms.config.php /tmp/librenms.config.php
COPY common.d/librenms.env /tmp/librenms.env
COPY common.d/librenms.dispatcher.config.php /tmp/librenms.dispatcher.config.php
RUN chown librenms:librenms /tmp/librenms* && chmod 640 /tmp/librenms*

COPY prepare-volume.d/entrypoint.sh /entrypoint.sh
COPY common.d/services.sh /services.sh

WORKDIR /opt/librenms

USER librenms

VOLUME /opt/librenms

ENTRYPOINT ["/entrypoint.sh"]

#==============================================================================

FROM build as prepare-mysql

COPY common.d/librenms.config.php /tmp/librenms.config.php
COPY common.d/librenms.env /tmp/librenms.env
COPY common.d/librenms.dispatcher.config.php /tmp/librenms.dispatcher.config.php
RUN chown librenms:librenms /tmp/librenms* && chmod 640 /tmp/librenms*

COPY prepare-mysql.d/entrypoint.sh /entrypoint.sh
COPY prepare-mysql.d/count_tables.sql /count_tables.sql
COPY common.d/services.sh /services.sh

WORKDIR /opt/librenms

USER librenms

ENTRYPOINT ["/entrypoint.sh"]

#==============================================================================

FROM build as dispatcher

WORKDIR /opt/librenms

RUN apt-get -q install -y gettext-base python3-pip && \
    pip3 install -r requirements.txt

COPY common.d/librenms.config.php /tmp/librenms.config.php
COPY common.d/librenms.env /tmp/librenms.env
COPY common.d/librenms.dispatcher.config.php /tmp/librenms.dispatcher.config.php
RUN chown librenms:librenms /tmp/librenms* && chmod 640 /tmp/librenms*

COPY dispatcher.d/entrypoint.sh /entrypoint.sh
COPY common.d/services.sh /services.sh

USER librenms

ENTRYPOINT ["/entrypoint.sh"]

#==============================================================================

FROM build as cleanup-application

COPY common.d/librenms.config.php /tmp/librenms.config.php
COPY common.d/librenms.env /tmp/librenms.env
COPY common.d/librenms.dispatcher.config.php /tmp/librenms.dispatcher.config.php
RUN chown librenms:librenms /tmp/librenms* && chmod 640 /tmp/librenms*

COPY cleanup-application.d/entrypoint.sh /entrypoint.sh
COPY common.d/services.sh /services.sh

WORKDIR /opt/librenms

USER librenms

ENTRYPOINT ["/entrypoint.sh"]

#==============================================================================

FROM build as check-mysql

RUN apt-get update -y && \
    apt-get -q install -y gettext-base python-pip && \
    pip install mysql-connector

COPY check-mysql.d/entrypoint.sh /entrypoint.sh
COPY common.d/services.sh /services.sh
COPY check-mysql.d/check_database.py /check_database.py

WORKDIR /opt/librenms

USER librenms

ENTRYPOINT ["/entrypoint.sh"]

#==============================================================================

FROM build as generate-key

WORKDIR /opt/librenms

USER librenms

ENTRYPOINT ["php", "artisan", "key:generate", "--show"]

#==============================================================================

FROM base as application-php-fpm

WORKDIR /opt/librenms

RUN mkdir -p /sock && \
    chmod 777 /sock && \
    chmod 777 /run

COPY php-fpm.d/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
RUN rm /etc/php/7.2/fpm/pool.d/*
COPY php-fpm.d/docker.first.conf /etc/php/7.2/fpm/pool.d/+docker.conf
COPY php-fpm.d/librenms.conf /etc/php/7.2/fpm/pool.d/librenms.conf
COPY php-fpm.d/docker.last.conf /etc/php/7.2/fpm/pool.d/~docker.conf

VOLUME /opt/librenms /sock

WORKDIR /opt/librenms

USER librenms

ENTRYPOINT ["/usr/sbin/php-fpm7.2", "-y", "/etc/php/7.2/fpm/php-fpm.conf", "-g", "/run/php-fpm.pid", "-F", "-O"]

#==============================================================================

FROM application-php-fpm as validate-application

USER root

RUN apt-get -q install -y git

USER librenms

VOLUME /opt/librenms

WORKDIR /opt/librenms

ENTRYPOINT ["php", "validate.php", "-g", "configuration,database,dependencies,php,programs,rrdcheck,user"]

#==============================================================================

FROM ${MODE} as image

