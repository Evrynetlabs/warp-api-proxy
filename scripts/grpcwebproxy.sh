#!/bin/sh

sed -i "s/%HOST_ADDRESS%/$HOST/g" /config.yaml
sed -i "s/%ADMIN_PORT%/$ADMIN_PORT/g" /config.yaml
sed -i "s/%LISTENER_PORT%/$LISTENER_PORT/g" /config.yaml
sed -i "s/%HOST_PORT%/$HOST_PORT/g" /config.yaml

eval "/usr/local/bin/envoy -c /config.yaml"
