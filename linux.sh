#!/usr/bin/env bash

# TIM download and install script
# Currently supported distros
# * rhel
# * ubuntu

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

echo "$*"

exit 0

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
curl -s "$SCRIPTS_URL_BASE/common.sh" > common.sh
curl -s "$SCRIPTS_URL_BASE/$DOWNLOAD_CODE.sh" > install.sh

chmod u+x checkargs.sh common.sh install.sh

echo "Running installation (you will be prompted for your password)..."
echo "(You can also cancel the installation and run it later with \`sudo ~./tim-install/install.sh\`)"
sudo TIM_USER="$USER" ./install.sh "$@"