# ESONO Apache

### this docker image provides apache as microservice to:
* put behind a proxy like ha-proxy (providing TLS-Termination) 
* delivery static content
* connect to php-fpm
* add custom configuration
* support google's mod_pagespeed

### It does *not*:
* perform TLS-Termination itself or support certificates whatsoever
* support multiple vhosts by itself - this has to be managed by the frontend proxy

### Required ENV variables:
* SERVICE_USER_ID - the id of the user it should run as
* SERVICE_USER_NAME - the name of the user it should run as

### Optional ENV variables:
* VHOST_CUSTOM_CONFIG - absolute path (inside the docker) of a config file mounted from the host - see example below
* HTACCESS_USER - htaccess user (multiple users / userlist not supported). Access is granted to all if empty!
* HTACCESS_PASS - htaccess pass
* HTACCESS_WHITELIST_IP_REGEX - regex whitelist this set of IPs. Example: `(^192\.168\.1\..*$)|(^10\.42\..*$)`

### Webroot mountpoint to
* `/usr/local/apache2/htdocs/customer/web` - this path is safe for mounting back until `/usr/local/apache2/htdocs` without the risk of overwriting apache's own configuration files.

### Custom host configuration example

```
<IfModule pagespeed_module>
  ModPagespeed on
  ModPagespeedRespectXForwardedProto on
  ModPagespeedEnableFilters rewrite_css,rewrite_javascript,remove_comments,lazyload_images,insert_dns_prefetch,sprite_images,rewrite_style_attributes,inline_javascript,move_css_above_scripts,rewrite_images,collapse_whitespace,extend_cache
  # multiple domains are possible for the ModPagespeedLoadFromFile directive  
  ModPagespeedLoadFromFile "https://www.yourdomain.tld" "/usr/local/apache2/htdocs/customer/web/"
  ModPagespeedDisallow "*/cms*"
</IfModule>

 Header always set Strict-Transport-Security "max-age=31556926; includeSubDomains; preload"
 Header set Content-Security-Policy "default-src 'self' fonts.googleapis.com fonts.gstatic.com data: https:;"
 Header set Content-Security-Policy "script-src 'unsafe-inline';"
 Header set Content-Security-Policy "style-src 'self' fonts.googleapis.com 'unsafe-inline';"
 Header set X-XSS-Protection "1"
 Header set X-Content-Type-Options: "nosniff"
 Header set X-Frame-Options "SAMEORIGIN"

 FileEtag INode MTime Size
 <Directory ~ "^\/usr\/local\/apache2\/htdocs\/customer\/web\/assets" >
   ExpiresActive on
   ExpiresDefault "access plus 1 years"
 </Directory>
 <Directory ~ "^\/usr\/local\/apache2\/htdocs\/customer\/web\/chameleon\/(mediapool|outbox\/static\/(css|js))" >
   ExpiresActive on
   ExpiresDefault "access plus 1 years"
 </Directory>
```
