#!/usr/bin/env bash

# Run docker commands without sudo.
# Absolute path for usermod is intentional; otherwise it doesn't always work on RHEL8.

# check if TIM_USER is set
if [ -z "$TIM_USER" ]; then
    TIM_USER=${USER}
fi

sudo /usr/sbin/usermod -aG docker "${TIM_USER}"

# Create TIM folder and adjust permissions.
sudo mkdir -p /opt/tim
sudo chown "${TIM_USER}":docker /opt/tim
sudo chmod ug+rwxs /opt/tim

# Install TIM.
cd /opt/tim || (echo "Could cd to /opt/tim directory. Is it there and are the permissions OK?" && exit 1)
sudo -u "${TIM_USER}" git clone https://github.com/TIM-JYU/TIM.git .
sudo -u "${TIM_USER}" ./tim setup --no-interactive "$@"

echo TIM install script finished.
