# ESONO Apache

### this docker image provides apache as microservice to:
* put behind a proxy like ha-proxy (providing TLS-Termination) 
* delivery static content
* connect to php-fpm
* add custom configuration
* support google's mod_pagespeed

### It does *not*:
* perform TLS-Termination itself or support certificates whatsoever
* support multiple vhosts

### Required ENV variables:
* SERVICE_USER_ID - the id of the user it should run as
* SERVICE_USER_NAME - the name of the user it should run as

### Optional ENV variables:
* VHOST_CUSTOM_CONFIG - absolute path (inside the docker) of a config file mounted from the host
* HTACCESS_USER - htaccess user (multiple users / userlist not supported). Access is granted to all if empty!
* HTACCESS_PASS - htaccess pass
* HTACCESS_WHITELIST_IP_REGEX - regex whitelist this set of IPs. Example: `(^192\.168\.1\..*$)|(^10\.42\..*$)`

### Webroot mountpoint to
* `/usr/local/apache2/htdocs/customer/web` - this path is safe for mounting back until `/usr/local/apache2/htdocs` without the risk of overwriting apache's own configuration files.
