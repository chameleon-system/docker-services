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

# setting run user from environment
id -u $SERVICE_USER_NAME &>/dev/null | useradd -u $SERVICE_USER_ID $SERVICE_USER_NAME -d /home/$SERVICE_USER_NAME -s /bin/bash

# setting run user from environment

sed -i "s/www-data/$SERVICE_USER_ID/g" /usr/local/etc/php-fpm.d/www.conf

if [ "true" == "$EPP_XDEBUG" ]; then
  echo -e "xdebug.remote_host = $EPP_XDEBUG_REMOTE_HOST \n
xdebug.max_nesting_level = 1000 \n
xdebug.remote_enable = 1 \n
xdebug.remote_connect_back = 1 \n
xdebug.remote_port = 9000 \n
xdebug.remote_handler = dbgp \n
xdebug.remote_mode = req \n
xdebug.max_nesting_level=500 \n
xdebug.profiler_enable_trigger = 1 \n
" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug-esono.ini
else
  rm -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

if [ "true" == "$EPP_BLACKFIRE" ]; then
  mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so
  printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /usr/local/etc/php/conf.d/blackfire.ini
fi

if [ "true" == "$EPP_SHOW_ERRORS" ]; then
  sed -i "s/display_errors = Off/display_errors = On/g" /usr/local/etc/php/php.ini
fi

# retrieve rancher specific environment information and populate them into ENV variables for logspout
LOGSTASH_FIELDS="stack=$(wget -qO - 'http://rancher-metadata.rancher.internal/2015-12-19/self/stack/name'),environment=$(wget -qO - 'http://rancher-metadata.rancher.internal/2015-12-19/self/stack/environment_name')"

if [ "$1" = 'php-fpm' ]; then
    exec "$@"
else
    exec gosu $SERVICE_USER_ID:$SERVICE_USER_ID "$@"
fi
