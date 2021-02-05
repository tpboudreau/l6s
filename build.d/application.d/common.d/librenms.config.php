<?php

$config['user'] = 'librenms';
$config['distributed_poller'] = true;
$config['auth_mechanism'] = '${LIBRENMS_AUTH_MECHANISM}';
$config['update'] = 0;
$config['base_url'] = '${LIBRENMS_BASE_URL}';

$config['db_host'] = '${LIBRENMS_MYSQL_HOST}';
$config['db_port'] = '${LIBRENMS_MYSQL_PORT}';
$config['db_user'] = '${LIBRENMS_MYSQL_USER}';
$config['db_pass'] = '${LIBRENMS_MYSQL_PASSWORD}';
$config['db_name'] = '${LIBRENMS_MYSQL_DATABASE}';
$config['db_socket'] = '';

$config['rrd_dir'] = '/opt/librenms/rrd';
$config['rrdcached'] = '${LIBRENMS_RRDCACHED_HOST}:${LIBRENMS_RRDCACHED_PORT}';
$config['rrdtool_version'] = '1.7.0';

$config['memcached']['enable'] = true;
$config['memcached']['host'] = '${LIBRENMS_MEMCACHED_HOST}';
$config['memcached']['port'] = '${LIBRENMS_MEMCACHED_PORT}';

$config['use_snmp_ping'] = ${LIBRENMS_SNMP_PING};
$config['record_snmp_ping_rtt'] = ${LIBRENMS_SNMP_PING_RTT};
$config['snmp_ping_retries'] = 2;
$config['snmp_ping_timeout'] = 5;

$config['rrdtool'] = '/usr/bin/rrdtool';
$config['fping'] = '/usr/bin/fping';
$config['fping6'] = '/usr/bin/fping6';
$config['traceroute']= '/usr/sbin/traceroute';
$config['traceroute6'] = '/usr/bin/traceroute6';
$config['snmpwalk'] = '/usr/bin/snmpwalk';
$config['snmpbulkwalk'] = '/usr/bin/snmpbulkwalk';
$config['snmpget'] = '/usr/bin/snmpget';
$config['snmpgetnext'] = '/usr/bin/snmpgetnext';
$config['snmpstatus'] = '/usr/bin/snmpstatus';
$config['whois'] = '/usr/bin/whois';
$config['ping'] = '/bin/ping';
$config['mtr'] = '/usr/bin/mtr';
$config['nmap'] = '/usr/bin/nmap';
$config['ipmitool'] = '/usr/bin/ipmitool';
$config['dot'] = '/usr/bin/dot';
$config['unflatten'] = '/usr/bin/unflatten';
$config['neato'] = '/usr/bin/neato';
$config['sfdp'] = '/usr/bin/sfdp';

$config['snmp']['community'] = array('public');

$config['php_memory_limit'] = '${LIBRENMS_MEMORY_LIMIT}';

