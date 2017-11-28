#!/bin/bash
#
# patchpanel.sh is used to control defined configuration parameters of this docker's service.
# We decided to use a script like this for several reasons:
#
# 1st: Mulitple inheritance of different binary filesystem layers isn't possible
#
# 2nd: Using a "live" building multi layer Dockerfile configurations on remotely controlled
#      docker-machine scenarios is not what we want due to performance and consistency reasons.
#
# 3rd: Injecting local configuration files is not cool as well, because of reason no. 2 and the
#      fact that it can lead to different docker service behaviours due to non obvious reasons
#      like different file system rights or misspelled mountpoints while the effect isn't
#      immediately visible.
#
# 4th: When the underlying service changes configuration formats/defaults/whatever we just have
#      to change this patchpanel script once and all our docker-compose.yml scripts will continue
#      working without any change.
#
# With this patchpanel.sh a clear interface is defined, usable in the same way in every environment
# no matter if locally via docker-compose only or remotely via docker-compose and docker-machine.
# 
# This patchpanel.sh script is set as default CMD for this docker. After starting it configures
# the service as defined in the environment variables and starts it.
#
# This procedure is suitable for basically all dockerized services.
# Keep this information in all patchpanel.sh files. The following lines are now service specific.
#
outputchannel="/proc/self/fd/2"

# setting run user from environment
useradd -u $SERVICE_USER_ID $SERVICE_USER_NAME -d /usr/local/apache2/htdocs/ -s /bin/bash

sed -i "s/daemon/$SERVICE_USER_NAME/g" /usr/local/apache2/conf/httpd.conf

if [ ! -z "$HTACCESS_USER" ] && [ ! -z "$HTACCESS_PASS" ]; then
  echo "htpasswd -c /usr/local/apache2/conf/htuser $HTACCESS_USER $HTACCESS_PASS"
  htpasswd -b -c /usr/local/apache2/conf/htuser $HTACCESS_USER $HTACCESS_PASS
  sed -i 's/<\/VirtualHost>//g' /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
  echo "<Location />
    Order deny,allow
    Deny from all
    AuthName \"protected\"
    AuthUserFile /usr/local/apache2/conf/htuser
    AuthType Basic
    Require valid-user" >> /usr/local/apache2/conf/extra/sites-enabled/vhost.conf

  if [ ! -z "$HTACCESS_WHITELIST_IP_REGEX" ]; then
    echo "SetEnvIf X-FORWARDED-FOR \"$HTACCESS_WHITELIST_IP_REGEX\" AllowIP" >> /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
  fi

  echo "Allow from env=AllowIP
    Satisfy Any
  </Location>
  </VirtualHost>" >> /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
fi

if [ ! -z "$VHOST_CUSTOM_CONFIG" ]; then
  sed -i 's/<\/VirtualHost>//g' /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
  echo "Include $VHOST_CUSTOM_CONFIG
        </VirtualHost>" >> /usr/local/apache2/conf/extra/sites-enabled/vhost.conf
fi

exec httpd-foreground
