#!/bin/sh
# vim:sw=4:ts=4:et

# Calls the entrypoint of the base nginx image,
# ignoring all parameters passed to the call entirely.
/docker-entrypoint.sh nginx -g 'daemon off;'