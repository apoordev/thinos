#!/bin/bash

set -ouex pipefail

dnf install -y tmux 

systemctl enable podman.socket
