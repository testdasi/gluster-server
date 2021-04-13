#!/bin/bash

echo '[info] Start glusterd service'
echo ''
systemctl start glusterd

echo '[info] Not much else to do...'
sleep_time=3600
echo ''
while true
do
    gluster peer status
    gluster volume status
    sleep $sleep_time
done
