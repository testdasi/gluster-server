#!/bin/bash

# install more packages
apt-get -y update \
    && apt-get -y install systemd

apt-get -y install glusterfs-server
systemctl enable glusterd

# Clean up
apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/*
