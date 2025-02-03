#!/bin/bash

set -ouex pipefail

MAJOR_VERSION_NUMBER="$(sh -c '. /usr/lib/os-release ; echo $VERSION_ID | cut -d'.' -f1')"
export MAJOR_VERSION_NUMBER

# Install VDI Tools
dnf install -y tmux virt-viewer

# Install Tailscale
#curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf config-manager --add-repo "https://pkgs.tailscale.com/stable/rhel/${MAJOR_VERSION_NUMBER}/tailscale.repo"
dnf config-manager --set-disabled tailscale-stable
dnf -y --enablerepo tailscale-stable install \
	tailscale

dnf group install -y --nobest 'KDE'

dnf -y install \
	plymouth \
	plymouth-system-theme \
	fwupd

systemctl enable podman.socket
systemctl disable tailscaled.service
