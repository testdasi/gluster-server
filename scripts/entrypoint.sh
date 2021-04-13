#!/bin/bash

if [[ -f "/etc/glusterfs/glusterd.vol" ]]; then
    echo '[info] Glusterd management volume exists, do nothing.'
else
    echo '[info] Glusterd management volume missing, copying over default.'
    cp -n /glusterd.vol /etc/glusterfs/
fi

echo '[info] Start glusterd'
glusterd --log-level ERROR

echo '[info] Not much else to do...'
sleep_time=3600
echo ''
while true
do
    gluster peer status
    gluster volume status
    sleep $sleep_time
done
