# vim: set ft=make :
########################
### thinos-system.just
########################
# Toggle PVE-VDIClient

# [group('System')]
toggle-pvevdi: distrobox-check-fedora
    distrobox enter -n fedora -- bash -c 'sudo dnf install python3-pip python3-tkinter virt-viewer git -y && \
        cd ~/.local/share && git clone https://github.com/apoordev/PVE-VDIClient.git && cd PVE-VDIClient && \
        chmod +x requirements.sh && ./requirements.sh && \
        mkdir ~/.local/share/applications && \
        cp VDIClient.desktop ~/.local/share/applicaions/'
    echo "You MUST create a config at ~/.config/VDIClient/vdiclient.ini"
    echo "The Program WILL NOT START without a proper config."
    echo "You can find an example config at ~/.local/share/PVE-VDIClient/vdiclient.ini.example"

# Toggle tailscale
[group('System')]
toggle-tailscale:
    #!/bin/bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh
    source /usr/lib/os-release

    TAILSCALED_STATUS="$(systemctl is-enabled tailscaled || true )"

    if [ "$TAILSCALED_STATUS" == "enabled" ] || [ "$TAILSCALED_STATUS" == "disabled" ]; then
        TAILSCALED="Installed"
    else
        TAILSCALED="Not Found"
        echo "${b}${red}Unable to enable or disable Tailscale.${n}"
        echo "The tailscaled service must be present and either enabled or disabled to run this script."
        echo "tailscaled service status: $TAILSCALED_STATUS"
    fi


    if [ "$TAILSCALED" == "Installed" ]; then
        echo "Enable or disable Tailscale?"
        TS_OPTION=$(Choose Enable Disable)

        if [ "$TS_OPTION" = "Enable" ]; then
            systemctl enable --now tailscaled
            TAILSCALED_STATUS="$(systemctl is-enabled tailscaled || true )"
            if [ "$TAILSCALED_STATUS" == "enabled" ]; then
                echo "${b}${green}Tailscale is enabled.${n}"
                echo "If this is your first time using Tailscale, setup is necessary."
                echo "Refer to Tailscale's documentation at https://tailscale.com/kb/1346/start."
            fi
        elif [ "$TS_OPTION" = "Disable" ]; then
            systemctl disable --now tailscaled
            TAILSCALED_STATUS="$(systemctl is-enabled tailscaled || true )"
            if [ "$TAILSCALED_STATUS" == "disabled" ]; then
                echo "${b}${red}Tailscale is disabled.${n}"
            fi
        fi
    fi

# Create fedora distrobox if it doesn't exist
[private]
distrobox-check-fedora:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    if grep -qvz "fedora" <<< $(distrobox list); then
      echo "Setting up Fedora distrobox"
      distrobox create --name fedora --image ghcr.io/ublue-os/fedora-toolbox:latest
    fi
