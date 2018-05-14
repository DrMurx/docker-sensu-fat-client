#!/bin/bash

SENSU_PLUGINS=(
  execute
  # irc
  # logstash
  telegram
)

set -e

apt-get update
apt-get install -y libxml2 libxml2-dev libxslt1-dev zlib1g-dev build-essential

# Install Plugins
PARALLEL_INSTALLATION=0 UNINSTALL_BUILD_TOOLS=0 /bin/install ${SENSU_PLUGINS[@]}


apt-get remove -y libxml2 libxml2-dev libxslt1-dev zlib1g-dev build-essential
apt-get autoremove -y

rm -rf /var/lib/apt/lists/*
