#!/usr/bin/env bash

# TIM download and install script
# Currently supported distros
# * rhel
# * ubuntu
# * arch / manjaro (experimental)

# Print help if --help is given
if [[ "$1" == "--help" ]]; then
    echo 'Set up TIM environment on a server.
Arguments:
--profile {dev, prod, test}     : Profile to use (REQUIRED)
--hostname <hostname>           : Host URL of the server to install (default: "http://localhost")
--http-port <port>              : HTTP port to use (default: 80)
--https-port <port>             : HTTPS port to use (default: 443)
'
    exit 0
fi

# Determine the distro using /etc/os-release
if [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    DISTRO="$ID"
    SIMILAR_DISTRO="$ID_LIKE"
else
    echo "Could not determine distro. Exiting."
    exit 1
fi

# Check if the distro is supported
if [[ "$DISTRO" == "ubuntu" || "$SIMILAR_DISTRO" == *"ubuntu"* ]]; then
    DOWNLOAD_CODE="ubuntu"
elif [[ "$DISTRO" == "rhel" || "$SIMILAR_DISTRO" == *"rhel"* ]]; then
    DOWNLOAD_CODE="rhel"
elif [[ "$DISTRO" == "arch" || "$DISTRO" == "manjaro" || "$SIMILAR_DISTRO" == *"arch"* ]]; then
    DOWNLOAD_CODE="arch"
else
    echo "Distro $DISTRO is not supported. Exiting."
    exit 1
fi

echo "Determined distro: $DOWNLOAD_CODE"
echo "Downloading installation scripts..."

mkdir -p ~/.tim-install
cd ~/.tim-install || (echo "Could not go to the temporary install cache (~/.tim-install), is the folder writable?" && exit 1)

SCRIPTS_URL_BASE=https://raw.githubusercontent.com/TIM-JYU/tim-installscripts/master

# Download the scripts
curl -s "$SCRIPTS_URL_BASE/setup.sh" > setup.sh
curl -s "$SCRIPTS_URL_BASE/$DOWNLOAD_CODE.sh" > install.sh

chmod u+x setup.sh install.sh

# Check if TIM_USER is already set, otherwise use the current user
if [ -z "$TIM_USER" ]; then
    TIM_USER="$USER"
fi

echo "Running installation (you will be prompted for your password)..."
echo "(You can also cancel the installation and run it later with \`sudo ~/.tim-install/install.sh\`)"
sudo TIM_USER="$TIM_USER" DISTRO="$DISTRO" ./install.sh "$@"