
FROM alpine:latest

COPY entrypoint.sh /

RUN chmod 755 /entrypoint.sh && \
    mkdir -p /volume && \
    chmod 777 /volume

VOLUME /volume

ENTRYPOINT ["/entrypoint.sh"]

