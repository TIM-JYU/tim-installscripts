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
    pacman -S --noconfirm --needed nodejs npm python-pip python-virtualenv
    # Downgrade npm to 6.x
    npm install -g npm@6
    # install snap
    echo "Installing Snap environment"
    # note: snapd isn't officially available for vanilla arch, so we install it from AUR
    if [ "$DISTRO" == "arch" ]; then
        # cd ~/.tim-install || (echo "Could not go to the temporary install cache (~/.tim-install), is the folder writable?" && exit 1)
        git clone --quiet https://aur.archlinux.org/snapd.git
        chmod -R o+w ./snapd && cd ./snapd
        sed -i 's/-trimpath/-trimpath -buildvcs=false/' PKGBUILD
        # install deps, build package and install it
        # the locale setting LC_ALL=C needs to be passed to makepkg
        sudo -u "$TIM_USER" LC_ALL=C makepkg -s -i --noconfirm --needed --clean
        cd ..
    else
        # manjaro has pre-built snapd in the official repos
        pacman -S --noconfirm --needed snapd
    fi

    # don't create the symlink if it already exists, as the script will error out
    if [ ! -L "/snap" ]; then
        # symlink workaround for snap
        ln -s /var/lib/snapd/snap /snap
    fi
    # make sure the snapd service is running
    systemctl start snapd
    # install pycharm
    snap install pycharm-professional --classic
fi

# shellcheck disable=SC1091
echo "Running TIM setup..."
source ./setup.sh "$@"
