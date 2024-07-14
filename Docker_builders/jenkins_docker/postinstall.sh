#!/bin/bash

# Add registry host
echo "172.17.0.1 my.registry" >> /etc/hosts

# Docker login local registry
docker login my.registry:5000