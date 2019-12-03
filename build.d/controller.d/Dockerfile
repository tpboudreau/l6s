
FROM haproxy:2.0-alpine

RUN apk add --no-cache gettext libcap && \
    setcap 'cap_net_raw,cap_net_admin+eip' /usr/local/sbin/haproxy && \
    addgroup -S -g 1010 provider && \
    adduser -S -u 1010 -G provider -g provider provider && \
    addgroup -S -g 1111 haproxy && \
    adduser -S -u 1111 -G haproxy -g haproxy haproxy && \
    addgroup haproxy provider && \
    rm -f docker-entrypoint.sh && \
    mkdir -p /haproxy && \
    chown haproxy:haproxy /haproxy && \
    chmod 755 /haproxy && \
    mkdir -p /sock && \
    chmod 777 /sock && \
    chmod 777 /run

COPY haproxy.cfg.template whitelist_addresses.default entrypoint.sh /haproxy/
RUN ln -s /haproxy/whitelist_addresses.default /haproxy/whitelist_addresses && \
    chown -R haproxy:haproxy /haproxy && \
    chmod 644 /haproxy/haproxy.* /haproxy/whitelist_addresses && \
    chmod 755 /haproxy/entrypoint.sh

VOLUME /sock

USER haproxy

ENTRYPOINT ["/haproxy/entrypoint.sh"]

