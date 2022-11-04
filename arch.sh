#!/usr/bin/env bash

# Stop running the script if an error occurs.
set -e
set -o pipefail

# Install Docker.
# Force refresh of package databases
sudo pacman -Syy
# Required for non-Gnome desktop environments
sudo pacman -S gnome-terminal
sudo pacman -S ca-certificates curl gnupg python3 git
# Download and install Docker static binaries
curl -LO https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz
tar xzvf docker-20.10.9.tgz
sudo cp ./docker/* /usr/bin
curl -LO https://desktop.docker.com/linux/main/amd64/docker-desktop-4.13.1-x86_64.pkg.tar.zst
sudo pacman -U ./docker-desktop-4.13.1-x86_64.pkg.tar.zst
systemctl --user enable docker-desktop
systemctl --user start docker-desktop
# Create docker group in anticipation of later setup step
sudo groupadd docker

if [[ "$*" == *"--profile dev"* ]]; then
    # Download nodejs, npm and pip
    sudo pacman -S nodejs npm python-pip python-virtualenv dbus-x11
    # Downgrade npm to 6.x
    sudo npm install -g npm@6
    # install snap
    sudo pacman -S snapd
    # install pycharm
    sudo snap install pycharm-professional --classic
fi

# shellcheck disable=SC1091
source ./setup.sh "$@"
