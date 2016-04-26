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
cat << heredocdocu >> $outputchannel
ENV available: EPP_XDEBUG=true|false (enables/disables xdebug module - default = false)
heredocdocu

if [ "true" == "$EPP_XDEBUG" ]; then
  echo "found EPP_XDEBUG=true: enabling xdebug" >> $outputchannel
  echo "xdebug.remote_host = localhost \
xdebug.remote_connect_back = 1 \
xdebug.remote_port = 9000 \
xdebug.remote_handler = dbgp \
xdebug.remote_mode = req \
xdebug.max_nesting_level=500 \
xdebug.profiler_enable_trigger = 1 \
" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
else
  echo "found EPP_XDEBUG=false or not set: disabling xdebug" >> $outputchannel
  rm -f /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

exec php-fpm
