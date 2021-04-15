#!/bin/bash

check_process_privileges() {
    if [ "$EUID" -ne 0 ]; then
        echo "Privilege escalation needed."
        echo "Exiting"
        exit 1
    fi
}

remove_packages() {
    apt-get purge ant claws-mail code-the-classics ffmpeg exim4-base geany hplip mu-editor printer-driver-escpr printer-driver-gutenprint python-games qpdfview vlc bluej greenfoot-unbundled scratch nuscratch sense-emu-tools sonic-pi thonny smartsim libreoffice -y
    apt-get autoremove --purge -y
    apt-get clean -y
}

diasable_services() {
    local services=(sshd ssh avahi-daemon cups.service cups)
    for service in "${services[@]}"; do
        systemctl disable --now "${service}"
    done
}

remove_from_groups() {
    local groups=(adm plugdev lpadmin dialout sudo)
    for group in "${groups[@]}"; do
        gpasswd -d "${USER}" "${group}"
    done
}

setup_ufw() {
    apt-get install ufw -y
    ufw default deny incoming
    # if SSH is needed enable rate limiting
    # ufw allow ssh
    # ufw limit ssh
}

# TODO add ufw and configure

check_process_privileges
remove_packages
diasable_services
setup_ufw
remove_from_groups
