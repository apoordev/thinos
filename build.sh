#!/bin/bash

set -ouex pipefail

# Consolidate Just Files
find /tmp/just -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Install VDI Tools
dnf install -y tmux spice-gtk-tools virt-viewer

# Install Tailscale
curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

dnf install -y tailscale

systemctl enable podman.socket
systemctl disable tailscaled.service
