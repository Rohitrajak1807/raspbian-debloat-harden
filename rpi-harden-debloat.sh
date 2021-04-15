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

disable_services() {
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
    ufw enable
    ufw default deny incoming
    # if SSH is needed enable rate limiting
    # ufw allow ssh
    # ufw limit ssh
}

setup_apparmor() {
    apt-get install apparmor-profiles apparmor-utils -y
    aa-enforce /etc/apparmor.d/*
}

disable_usbhid_devices() {
    echo 'blacklist usbhid' > /etc/modprobe.d/usbhid-blacklist.conf
    update-initramfs -u
}

update_and_upgrade() {
    apt-get update -y
    apt-get upgrade -y
    apt-get dist-upgrade -y
}

fix_sudoers() {
    touch /tmp/sudoers.tmp
    cp /etc/sudoers /tmp/sudoers.tmp
    sed -i "s/ALL\:ALL/ALL/g" /tmp/sudoers.tmp
    visudo -c -f /tmp/sudoers.tmp
    cp /tmp/sudoers.tmp /etc/sudoers
    rm /tmp/sudoers.tmp
}

check_process_privileges
remove_packages
disable_services
update_and_upgrade
setup_ufw
setup_apparmor
disable_usbhid_devices
fix_sudoers
remove_from_groups
