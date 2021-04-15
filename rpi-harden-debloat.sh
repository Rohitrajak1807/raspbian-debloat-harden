#!/bin/sh

systemctl disable --now sshd
systemctl disable --now ssh
systemctl disable --now avahi-daemon
systemctl disable --now cups.service


apt-get purge ant claws-mail code-the-classics ffmpeg exim4-base geany hplip mu-editor printer-driver-escpr printer-driver-gutenprint python-games qpdfview vlc bluej greenfoot-unbundled scratch nuscratch sense-emu-tools sonic-pi thonny smartsim libreoffice -y
apt-get autoremove --purge -y
apt-get clean -y

