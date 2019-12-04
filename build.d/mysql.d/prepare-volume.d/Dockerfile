
FROM ubuntu:18.04

RUN addgroup --system --gid 999 mysql && \
    adduser --system --uid 999 --gid 999 --disabled-login --disabled-password --no-create-home --gecos MySQL mysql && \
    mkdir -p /configuration /database /initialization && \
    chown mysql:mysql /configuration /database /initialization && \
    chmod 755 /configuration /database /initialization

COPY librenms.cnf alter.sql /tmp/
COPY entrypoint.sh /

RUN chown mysql:mysql /entrypoint.sh && \
    chmod 755 /entrypoint.sh && \
    chmod 644 /tmp/librenms.cnf /tmp/alter.sql

USER mysql

ENTRYPOINT ["/entrypoint.sh"]

