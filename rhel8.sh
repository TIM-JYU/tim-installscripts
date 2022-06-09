#!/usr/bin/env bash

# shellcheck disable=SC1091
source ./checkargs.sh

# Install Docker.
yum -y module remove container-tools
yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce git
systemctl start docker
systemctl enable docker.service
systemctl enable containerd.service

# Install Docker Compose.
curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" >/bin/docker-compose
chmod +x /bin/docker-compose

source ./common.sh "$@"
