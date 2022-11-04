#!/usr/bin/env bash

# Stop running the script if an error occurs.
set -e
set -o pipefail

# Install Docker.
# Force refresh of package databases
sudo pacman -Syy
# Required for non-Gnome desktop environments
sudo pacman -S gnome-terminal
sudo pacman -S --needed ca-certificates curl gnupg python3 git
# Community provided binaries, forgo Docker Desktop
sudo pacman -S --needed docker
sudo pacman -S --needed docker-compose
systemctl --user enable docker.service
systemctl --user enable containerd.service
systemctl --user start docker.service
# Create docker group in anticipation of later setup step
sudo groupadd docker

if [[ "$*" == *"--profile dev"* ]]; then
    # Download nodejs, npm and pip
    sudo pacman -S --needed nodejs npm python-pip python-virtualenv
    # Downgrade npm to 6.x
    sudo npm install -g npm@6
    # install snap
    sudo pacman -S --needed snapd
    # symlink workaround for snap
    sudo ln -s /var/lib/snapd/snap /snap
    # install pycharm
    sudo snap install pycharm-professional --classic
fi

# shellcheck disable=SC1091
source ./setup.sh "$@"
