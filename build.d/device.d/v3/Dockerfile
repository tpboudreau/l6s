
FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache net-snmp

COPY snmpd.conf /etc/snmp/snmpd.conf

RUN addgroup -S -g 101 snmpd && \
    adduser -S -u 101 -G snmpd -g snmpd snmpd && \
    chmod 644 /etc/snmp/snmpd.conf

EXPOSE 161 161/udp

ENTRYPOINT ["/usr/sbin/snmpd", "-f", "-Lo", "-V", "-u", "101", "-g", "101"]

