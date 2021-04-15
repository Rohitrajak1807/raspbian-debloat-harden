# raspbian-debloat-harden

Simple script to cleanup some unnecessary applications and hardening a stock Raspbian installation

## What this script does:
1. Removes the following applications along with their dependencies:
    ```bash
        ant 
        claws-mail 
        code-the-classics 
        ffmpeg 
        exim4-base 
        geany 
        hplip 
        mu-editor 
        printer-driver-escpr 
        printer-driver-gutenprint 
        python-games 
        qpdfview 
        vlc 
        bluej 
        greenfoot-unbundled 
        scratch 
        nuscratch 
        sense-emu-tools 
        sonic-pi 
        thonny 
        smartsim 
        libreoffice
    ```
2. Disables the following servies:
   ```bash
        sshd
        avahi-daemon
        cups
   ```

3. Updates all packages and performs a ```dist-upgrade```
4. Installs ```ufw``` enables it and blocks all incoming connections. (```ufw default deny incoming```)
5. Installs ```apparmor apparmor-profiles apparmor-utils``` and enforces all rules in ```/etc/apparmor.d/*```
6. Blacklists ```usbhid``` module
7. Fixes sudoers file, changes ```(ALL:ALL)``` to ```(ALL)``` for ```root``` and ```%sudo```
8. Removes ```$USER``` from ```adm plugdev lpadmin dialout sudo``` groups