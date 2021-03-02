# mysqld-exporter-stub

A minimal docker image that starts a webserver on port `9125` that always replies
with a `200 OK` status code, no matter what.

This image is meant to be used as a replacement for mysqld-exporter in instances,
where that exporter cannot be disabled.