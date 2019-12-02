
$config['service_poller_workers'] = ${LIBRENMS_DISPATCHER_POLLER_WORKERS};
$config['service_services_workers'] = ${LIBRENMS_DISPATCHER_SERVICES_WORKERS};
$config['service_discovery_workers'] = ${LIBRENMS_DISPATCHER_DISCOVERY_WORKERS};

$config['service_poller_frequency'] = 300;
$config['service_services_frequency'] = 300;
$config['service_discovery_frequency'] = 21600;
$config['service_billing_frequency'] = 300;
$config['service_billing_calculate_frequency'] = 60;
$config['service_poller_down_retry'] = 60;
$config['service_loglevel'] = 'INFO';
$config['service_update_enabled'] = false;

#$config['distributed_poller_name'] = php_uname('n');
$config['distributed_poller_name'] = '${LIBRENMS_DISPATCHER_POLLER_NAME}';
$config['distributed_poller_group'] = '${LIBRENMS_DISPATCHER_POLLER_GROUP}';
$config['distributed_poller_memcached_host'] = '${LIBRENMS_MEMCACHED_HOST}';
$config['distributed_poller_memcached_port'] = '${LIBRENMS_MEMCACHED_PORT}';

