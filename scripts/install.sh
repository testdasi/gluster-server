#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install attr psmisc glusterfs-server fuse

# Clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Fix script permissions
chmod 770 /entrypoint.sh
chmod 770 /healthcheck.sh
