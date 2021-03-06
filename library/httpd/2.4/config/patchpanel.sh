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

VHOST="/etc/apache2/sites-available/vhost.conf"
LOCKFILE="/etc/patchpanel.lock"

# only run configuration once
if [ ! -f ${LOCKFILE} ]; then

	# setting run user from environment
	useradd -u $SERVICE_USER_ID $SERVICE_USER_NAME -d /usr/local/apache2/htdocs/ -s /bin/bash
	sed -i "s/APACHE_RUN_USER=www-data/APACHE_RUN_USER=$SERVICE_USER_NAME/g" /etc/apache2/envvars

    # set custom document root if configured (sed used with commas to avoid collisions with slashes in $PUBLIC_DIR)
    if [ ! -z "$PUBLIC_DIR" ]; then
        sed -i "s,htdocs/customer/web,htdocs/$PUBLIC_DIR,g" ${VHOST}
    fi

	# include htaccess protection if set
	if [ ! -z "$HTACCESS_USER" ] && [ ! -z "$HTACCESS_PASS" ]; then
	  echo "htpasswd -c /usr/local/apache2/conf/htuser $HTACCESS_USER $HTACCESS_PASS"
	  htpasswd -b -c /usr/local/apache2/conf/htuser $HTACCESS_USER $HTACCESS_PASS
	  sed -i 's/<\/VirtualHost>//g' ${VHOST}
	  echo "<Location />
	    Order deny,allow
	    Deny from all
	    AuthName \"protected\"
	    AuthUserFile /usr/local/apache2/conf/htuser
	    AuthType Basic
	    Require valid-user" >> ${VHOST}

	  # Whitelist all IPs matching a REGEX if given
	  if [ ! -z "$HTACCESS_WHITELIST_IP_REGEX" ]; then
	    echo "SetEnvIf X-FORWARDED-FOR \"$HTACCESS_WHITELIST_IP_REGEX\" AllowIP" >> ${VHOST}
	  fi

	  echo "Allow from env=AllowIP
	    Satisfy Any
	  </Location>
	  </VirtualHost>" >> ${VHOST}
	fi

	# include custom configuration if set
	if [ ! -z "$VHOST_CUSTOM_CONFIG" ]; then
	  sed -i 's/<\/VirtualHost>//g' ${VHOST}
	  echo " Include $VHOST_CUSTOM_CONFIG
</VirtualHost>" >> ${VHOST}
	fi

	# write lockfile to prevent multiple execution
	touch ${LOCKFILE}
fi

chown -R ${SERVICE_USER_ID} /var/cache/mod_pagespeed
chown -R ${SERVICE_USER_ID} /var/log/pagespeed

rm -f /var/run/apache2/apache2.pid

. /etc/apache2/envvars

exec apache2 -DFOREGROUND
