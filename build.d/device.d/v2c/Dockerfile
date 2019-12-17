
FROM alpine:latest as base

RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl gettext

COPY snmpd.conf.template .

#RUN COMMUNITY=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16) envsubst < snmpd.conf.template > /tmp/snmpd.conf && \
RUN COMMUNITY=librenmsDevice envsubst < snmpd.conf.template > /tmp/snmpd.conf && \
    curl -o /tmp/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro

#===============================================================================

FROM alpine:latest as serve

RUN apk update && \
    apk upgrade && \
    apk add --no-cache net-snmp bash

COPY --from=base /tmp/snmpd.conf /etc/snmp/snmpd.conf
COPY --from=base /tmp/distro /usr/bin/distro

RUN chmod 644 /etc/snmp/snmpd.conf && \
    chmod 755 /usr/bin/distro && \
    addgroup -S -g 101 snmpd && \
    adduser -S -u 101 -G snmpd -g snmpd snmpd

EXPOSE 161 161/udp

ENTRYPOINT ["/usr/sbin/snmpd", "-f", "-Lo", "-V", "-u", "101", "-g", "101", "-c", "/etc/snmp/snmpd.conf"]

