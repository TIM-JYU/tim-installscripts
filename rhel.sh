#!/usr/bin/env bash

# Install Docker and components
yum -y module remove container-tools
yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce git python3
systemctl start docker
systemctl enable docker.service
systemctl enable containerd.service

# Install Docker Compose.
curl -L "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-$(uname -s)-$(uname -m)" > /bin/docker-compose
chmod +x /bin/docker-compose

if [[ "$*" == *"--profile dev"* ]]; then
    # Download nodejs, npm and pip
    yum -y install nodejs npm python3-pip
    # Downgrade npm to 6.x
    npm install -g npm@6
    # install snap
    yum install -y snapd
    # install pycharm
    snap install pycharm-professional --classic
fi

# shellcheck disable=SC1091
source ./setup.sh "$@"
