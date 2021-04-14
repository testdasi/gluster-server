#!/bin/bash

if [[ -f "/etc/glusterfs/glusterd.vol" ]]; then
    echo '[info] Glusterd management volume exists. Skip fixing.'
else
    echo '[info] Glusterd management volume id missing. Copy over default to fix.'
    cp -n /glusterd.vol /etc/glusterfs/
fi

echo '[info] Starting glusterd.'
glusterd --log-level ERROR

echo '[info] Wait 30s for things to settle down.'
sleep_time=30
sleep $sleep_time
echo ''

if [ -z "$MOUNT_PATH" ] || [ -z "$GLUSTER_VOL" ];
then
  echo '[info] Mount variables not set (or set incorrectly). Skip mounting.'  
else
  echo '[info] Attempting to mount...'  
  for i in $(echo $GLUSTER_VOL | sed "s/,/ /g")
  do
    mount.glusterfs localhost:/$i $MOUNT_PATH/$i
  done
fi
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
