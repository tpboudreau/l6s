
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache rrdtool && \
    addgroup -S -g 1010 librenms && \
    adduser -S -u 1010 -G librenms -g librenms librenms

COPY entrypoint.sh services.sh /

RUN chmod 755 /entrypoint.sh /services.sh

ENV LIBRENMS_RRDCACHED_HOST=n.n.n.n \
    LIBRENMS_RRDCACHED_PORT=p

USER librenms

ENTRYPOINT ["./entrypoint.sh"]

