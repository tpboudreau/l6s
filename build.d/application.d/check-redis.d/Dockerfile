
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache redis && \
    addgroup -S -g 1010 librenms && \
    adduser -S -u 1010 -G librenms -g librenms librenms

COPY entrypoint.sh services.sh /

RUN chmod 755 /entrypoint.sh /services.sh

USER librenms

ENTRYPOINT ["./entrypoint.sh"]

