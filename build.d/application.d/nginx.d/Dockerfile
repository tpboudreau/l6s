
FROM nginx:alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache acl && \
    addgroup -S -g 1010 librenms && \
    adduser -S -u 1010 -G librenms -g librenms librenms && \
    addgroup nginx librenms && \
    mkdir -p /var/log/nginx && \
    chown nginx:nginx /var/log/nginx && \
    chmod 755 /var/log/nginx && \
    rm /etc/nginx/conf.d/* && \
    mkdir -p /nginx && \
    chown nginx:nginx /nginx && \
    chmod 755 /nginx && \
    mkdir -p /sock && \
    chmod 777 /sock && \
    chmod 777 /run

COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf
COPY librenms.conf /etc/nginx/conf.d/librenms.conf
COPY whitelist.conf.default /nginx/whitelist.conf
COPY entrypoint.sh /entrypoint.sh

RUN chown nginx:nginx /nginx/whitelist.conf /entrypoint.sh && \
    chmod 644 /nginx/whitelist.conf && \
    chmod 755 /entrypoint.sh

VOLUME /opt/librenms /sock

EXPOSE 8000

USER nginx

ENTRYPOINT [ "/entrypoint.sh" ]

