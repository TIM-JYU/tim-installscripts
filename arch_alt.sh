#!/usr/bin/env bash

# Stop running the script if an error occurs.
set -e
set -o pipefail

# Force refresh of package databases
pacman -Syy --noconfirm

# Install tools needed to run TIM
pacman -S --noconfirm --needed ca-certificates curl gnupg python3 git

# Install Docker
pacman -S --noconfirm --needed gnome-terminal docker docker-compose
systemctl enable docker.service
systemctl start docker.service

if [[ "$*" == *"--profile dev"* ]]; then
    # Download nodejs, npm and pip
    sudo pacman -S --noconfirm --needed nodejs npm python-pip python-virtualenv
    # Downgrade npm to 6.x
    sudo npm install -g npm@6
    # install snap
    sudo pacman -S --noconfirm --needed snapd
    # symlink workaround for snap
    sudo ln -s /var/lib/snapd/snap /snap
    # install pycharm
    sudo snap install pycharm-professional --classic
fi

# shellcheck disable=SC1091
source ./setup.sh "$@"
