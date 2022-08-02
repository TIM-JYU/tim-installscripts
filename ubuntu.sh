#!/usr/bin/env bash

# Install Docker.
apt update
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce python3 git

# Install Docker Compose.
curl -L "https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if [[ "$*" == *"--profile dev"* ]]; then
    # Download nodejs, npm and pip
    apt install -y nodejs npm python3-pip dbus-x11
    # Downgrade npm to 6.x
    npm install -g npm@6
    # install snap
    apt install -y snapd
    # install pycharm
    snap install pycharm-professional --classic
    # Remove possibly conflicting packages
    apt remove -y python3-debian python3-distro-info
fi

# shellcheck disable=SC1091
source ./setup.sh "$@"
