#!/bin/bash

#* install x11 base
# dnf -y install @base-x
dnf -y install gtk4-devel rust-gtk4-devel qt-devel
dnf -y install xorg-x11-server-common xorg-x11-server-devel xorg-x11-xauth xorg-x11-drivers xorg-x11-drv-nvidia x11docker libX11-common libX11-devel
dnf -y install xorg-x11-server-Xwayland xorg-x11-server-Xwayland-devel wayland-devel libwayland-server
dnf -y install xorg-x11-util-macros xorg-x11-xinit-session wayland-utils
dnf -y install xsettingsd xsensors xsecurelock xmodmap xfontsel xdpyinfo xcursorgen libXfont libXfont-devel libICE libICE-devel

# dnf -y --skip-broken install xorg-x11-*
dnf -y install xorg-x11-xdm
echo "DISPLAYMANAGER=xdm" >> /etc/sysconfig/desktop

#* install fonts
dnf -y install jetbrains-mono-fonts


#* install ly
dnf -y install libpamtest pam-devel # dependencies
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
make install installsystemd
systemctl enable ly.service
systemctl disable getty@tty2.service

#* fix ly selinux permissions
# wget https://github.com/nullgemm/ly/files/5922013/ly.tar.gz
tar -xzf ../bin/assets/ly.tar.gz -C .
bash ./ly.sh

cd ..
rm -rf ./ly

# temp
#todo: fix
exit

#* install i3
dnf -y install i3 i3status dmenu i3lock xbacklight feh conky

systemctl set-default graphical.target


#* add i3 shortcust
sed -i 's/^# resize window/# custom\n\n#resize window/m' /etc/i3/config
sed -i 's/^# custom/# custom\nbindsym Control+Mod1+Delete exec i3-msg exit/m' /etc/i3/config


#todo: setup i3 theme (https://codeberg.org/derat/xsettingsd#settings)

tar -xzf ./bin/assets/backgrounds.tar.gz -C /usr/share/backgrounds
feh --bg-fill /usr/share/backgrounds/aspiesoft/black.png

#* set theme
gsettings set org.gnome.desktop.interface clock-format 12h
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

gsettings set org.gnome.desktop.interface gtk-theme "Fluent-round-Dark"

dnf -y install lxappearance
dnf -y install plymouth-system-theme mesa-dri-drivers mesa-vulkan-drivers abattis-cantarell-fonts

dnf -y install xorg-x11-drv-fbdev xorg-x11-drv-vesa

#todo: auto detect gpu type
dnf -y install xorg-x11-amdgpu


#* install apps
dnf -y install gnome-terminal gnome-text-editor nemo nemo-fileroller chromium

#* install network tools
dnf -y install nginx certbot python3-certbot-nginx

#* install php
dnf -y install php php-bcmath php-dba php-dom php-enchant php-fileinfo php-mysqli php-pspell php-soap php-sockets php-tidy php-xmlreader php-xmlwriter php-zip php-memcache php-mailparse php-imagick php-redis php-curl php-common php-opcache
dnf -y install mariadb-server
