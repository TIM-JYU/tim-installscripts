#!/usr/bin/env bash

# shellcheck disable=SC1091
source ./checkargs.sh

# Install Docker.
apt update
apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

# Install Docker Compose.
curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" >/usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

source ./common.sh "$@"
