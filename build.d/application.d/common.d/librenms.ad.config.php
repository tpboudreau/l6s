
$config['auth_ad_debug'] = ${LIBRENMS_AUTH_AD_DEBUG};
$config['auth_ad_url'] = '${LIBRENMS_AUTH_AD_URL}';
$config['auth_ad_timeout'] = ${LIBRENMS_AUTH_AD_TIMEOUT};
$config['auth_ad_domain'] = '${LIBRENMS_AUTH_AD_DOMAIN}';
$config['auth_ad_check_certificates'] = ${LIBRENMS_AUTH_AD_CHECK_CERTIFICATES};

$config['auth_ad_base_dn'] = '${LIBRENMS_AUTH_AD_BASE_DN}';
$config['auth_ad_binduser'] = '${LIBRENMS_AUTH_AD_BINDUSER}';
$config['auth_ad_binddn'] = '${LIBRENMS_AUTH_AD_BINDDN}';
$config['auth_ad_bindpassword'] = '${LIBRENMS_AUTH_AD_BINDPASSWORD}';
$config['active_directory']['users_purge'] = ${LIBRENMS_AUTH_AD_USERS_PURGE};
$config['auth_ad_require_groupmembership'] = ${LIBRENMS_AUTH_AD_REQUIRE_GROUPMEMBERSHIP};
$config['auth_ad_groups']['${LIBRENMS_AUTH_AD_ADMIN_GROUP}']['level'] = 10;
$config['auth_ad_groups']['${LIBRENMS_AUTH_AD_USER_GROUP}']['level'] = 5;
$config['auth_ad_user_filter'] = '${LIBRENMS_AUTH_AD_USER_FILTER}';
$config['auth_ad_group_filter'] = '${LIBRENMS_AUTH_AD_GROUP_FILTER}';

