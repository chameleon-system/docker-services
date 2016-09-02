#!/bin/bash
if [ -z "$RABBITMQ_HIGH_MEMORY_WATERMARK" ]
then
  echo "\$RABBITMQ_HIGH_MEMORY_WATERMARK not set - defaulting to 1 GB high memory watermark"
  export RABBITMQ_HIGH_MEMORY_WATERMARK=1073741824
fi
echo "[{rabbit, [{vm_memory_high_watermark, {absolute, $RABBITMQ_HIGH_MEMORY_WATERMARK}}]}]." >> /etc/rabbitmq/rabbitmq-customized.config
. docker-entrypoint.sh "$@"
