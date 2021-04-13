#!/bin/bash

### Autoheal ###
crashed=0

# Check glusterd status
pidlist=$(pgrep glusterd)
if [ -z "$pidlist" ]
then
    echo '[ERROR] Healthcheck failed. Attempting cure.'
    crashed=$(( $crashed + 1 ))
    systemctl start glusterd
fi

if (( $crashed > 0 ))
then
    exit 1
else
    exit 0
fi
