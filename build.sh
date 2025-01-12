#!/bin/bash

set -ouex pipefail

curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

dnf install -y tmux tailscale

systemctl enable podman.socket
systemctl disable tailscaled.service
