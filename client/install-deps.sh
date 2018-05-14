#!/bin/bash

SENSU_PLUGINS=(
  apache
  # ceph
  # cgroups
  # conntrack
  cpu-checks
  disk-checks
  dns
  docker
  elasticsearch
  environmental-checks
  etcd
  filesystem-checks
  github
  gitlab
  hardware
  haproxy
  http
  icecast
  imap
  influxdb
  io-checks
  # ipmi
  ipvs
  ldap
  load-checks
  logstash
  lvm
  # memory-checks
  mongodb
  mysql
  network-checks
  nginx
  openvpn
  pdns
  php-fpm
  postfix
  postgres
  # process-checks
  # rabbitmq
  raid-checks
  redis
  sensu
  sftp
  sidekiq
  # solr
  ssl
  trafficserver
  twemproxy
  uchiwa
  unicorn
  uptime-checks
  varnish
  # vmstats
  wordpress
  DrMurx/coreos@0.0.1
)

set -e

apt-get update
apt-get install -y --no-install-recommends gnupg libxml2 libxml2-dev libxslt1-dev zlib1g-dev build-essential

# pre-deps for checks which might need a docker binary
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
echo 'deb [arch=amd64] https://download.docker.com/linux/debian/ stretch stable' > /etc/apt/sources.list.d/docker.list

# pre-deps for sensu-plugins-raid-checks
curl -s https://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | apt-key add -
echo 'deb http://mirror.rackspace.com/hwraid.le-vert.net/debian/ stretch main' > /etc/apt/sources.list.d/megacli.list

apt-get update


# deps for sensu-plugins-disk-checks
apt-get install -y --no-install-recommends smartmontools

# deps for sensu-plugins-docker and other checks which might need a docker binary
apt-get install -y --no-install-recommends docker-ce

# deps for sensu-plugins-environmental-checks
apt-get install -y --no-install-recommends lm-sensors

# deps for sensu-plugins-io-stats
apt-get install -y --no-install-recommends ioping

# deps for sensu-plugins-lvm
apt-get install -y --no-install-recommends lvm2

# deps for sensu-plugins-mongodb
apt-get install -y --no-install-recommends python-pymongo

# deps for sensu-plugins-mysql
apt-get install -y --no-install-recommends libmariadb-dev

# deps for sensu-plugins-mysql
apt-get install -y --no-install-recommends libpq-dev

# deps for sensu-plugins-raid-checks
apt-get install -y --no-install-recommends megacli pciutils

# deps for sensu-plugins-wordpress
apt-get install -y --no-install-recommends ruby-dev libgmp-dev libcurl4-openssl-dev
gem install cms_scanner -v 0.0.38.2
gem install wpscan

# deps for deadman-check.sh
apt-get install -y --no-install-recommends netcat


# Install Plugins
PARALLEL_INSTALLATION=0 UNINSTALL_BUILD_TOOLS=0 /bin/install ${SENSU_PLUGINS[@]}


# post-deps for sensu-plugins-wordpress: compatibility to wpscan v3
sed -i -e 's|--follow-redirection --no-color|--wp-version-all --format cli-no-colour|g' /usr/local/bundle/bin/check-wpscan.rb
wpscan --update


apt-get remove -y gnupg libxml2 libxml2-dev libxslt1-dev zlib1g-dev build-essential
apt-get autoremove -y

rm -rf /var/lib/apt/lists/*
