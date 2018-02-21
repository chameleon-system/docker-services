# Chameleon system docker services

* This repository contains Dockerfiles for services needed to run Chameleon.
* All Dockerfiles should extend from official Docker images or other chameleon-system images only to retain a comprehensible chain of inheritance.
* The goal of this repository is to provide ready-to-run-images to be used in docker-compose application stack configurations that run the chameleon system

# Service specific documentation

## PHP

### Available Environment Variables

* EPP_XDEBUG=true|false (enables/disables xdebug module - default = false)
* EPP_XDEBUG_REMOTE_HOST=ip-address (the ip-address or hostname (must be resolvable from inside docker!) where your debugging IDE can be reached)
* EPP_SHOW_ERRORS=true|false (enables/disables displaying of PHP error messages)
* SERVICE_USER_ID=user_id (the user id php-fpm should run as. for example:33 or 1000)
* SERVICE_USER_NAME=user_name (the user name for the given id php-fpm should use)
* SSH_CONFIG=Path to an ssh config on the host which you may optionally provide.
## APACHE

### Available Environment Variables

* HTACCESS_USER=Username for htaccess
* HTACCESS_PASS=Password for htaccess
* HTACCESS_WHITELIST_IP_REGEX=The IP-address or a regex matching an IP-address range to whitelist against htaccess control
