
FROM haproxy:2.0-alpine

RUN apk add --no-cache libcap && \
    setcap 'cap_net_raw,cap_net_admin+eip' /usr/local/sbin/haproxy && \
    addgroup -S -g 1111 haproxy && \
    adduser -S -u 1111 -G haproxy -g haproxy haproxy && \
    rm -f /docker-entrypoint.sh && \
    mkdir -p /haproxy && \
    chown haproxy:haproxy /haproxy && \
    chmod 755 /haproxy && \
    chmod 777 /run

COPY haproxy.cfg pong.http entrypoint.sh /haproxy/
RUN chown -R haproxy:haproxy /haproxy && \
    chmod 644 /haproxy/haproxy.cfg /haproxy/pong.http && \
    chmod 755 /haproxy/entrypoint.sh

USER haproxy

ENTRYPOINT [ "/haproxy/entrypoint.sh" ]

