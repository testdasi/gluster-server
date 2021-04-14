#!/bin/bash

if [[ -f "/etc/glusterfs/glusterd.vol" ]]; then
    echo '[info] Glusterd management volume exists. Do nothing.'
else
    echo '[info] Glusterd management volume id missing. Copy over default.'
    cp -n /glusterd.vol /etc/glusterfs/
fi

echo '[info] Starting glusterd.'
glusterd --log-level ERROR

echo '[info] Wait 30s for things to settle down.'
sleep_time=30
sleep $sleep_time
echo ''

echo '[info] Healthcheck is running in background.'
echo '[info] Not much else to do...'
sleep_time=3600
echo ''

while true
do
    echo '[info] Quick status:'
    echo ''
    gluster peer status
    echo ''
    gluster volume status
    echo ''
    sleep $sleep_time
done
