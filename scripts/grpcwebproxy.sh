#!/bin/sh

echo "HOST = $HOST"
sed -e "s/%HOST_ADDRESS%/$HOST/g" /config.yaml > /etc/envoy/envoy.yaml
cat /etc/envoy/envoy.yaml
eval "/usr/local/bin/envoy -c /etc/envoy/envoy.yaml"
