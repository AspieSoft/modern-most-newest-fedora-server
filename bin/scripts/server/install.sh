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

#* install i3
dnf -y install i3 i3status dmenu i3lock xbacklight feh conky

systemctl set-default graphical.target


#todo: setup i3 theme (https://codeberg.org/derat/xsettingsd#settings)


#* Install apps
dnf -y install gnome-terminal gnome-text-editor nemo chromium
